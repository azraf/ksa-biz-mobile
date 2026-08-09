import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';

class ExpenseCategoriesScreen extends ConsumerWidget {
  const ExpenseCategoriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<ExpenseCategoryModel>>(
      future: ref.read(expenseRepositoryProvider).listCategories(withChildren: true),
      builder: (context, snap) {
        if (!snap.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        return Scaffold(
          appBar: AppBar(title: const Text('Expense Categories')),
          body: ListView(
            children: snap.data!.map((c) => ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.type ?? ''),
                )).toList(),
          ),
        );
      },
    );
  }
}

class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(offlineExpenseRepositoryProvider);
    return CrudListScreen<ExpenseModel>(
      title: 'Expenses',
      loadItems: () async => (await repo.list()).items,
      itemTitle: (e) => '${e.expenseDate} — SAR ${e.amount.toStringAsFixed(2)} (${e.status})',
      isPending: (e) => e.id < 0,
      onTap: (e) => context.push('/more/expenses/list/${e.id}'),
      onAdd: () => context.push('/more/expenses/list/create'),
    );
  }
}

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen({super.key, this.expenseId});
  final int? expenseId;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  List<ExpenseCategoryModel> _categories = [];
  int? _categoryId;
  final _amount = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();
  String _status = 'draft';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _categories = await ref.read(expenseRepositoryProvider).listCategories();
    if (widget.expenseId != null && widget.expenseId! > 0) {
      final expense = await ref.read(expenseRepositoryProvider).get(widget.expenseId!);
      _categoryId = expense.expenseCategoryId;
      _amount.text = expense.amount.toString();
      _date.text = expense.expenseDate;
      _description.text = expense.description ?? '';
      _status = expense.status;
    } else {
      if (_categories.isNotEmpty) _categoryId = _categories.first.id;
      _date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.expenseId == null ? 'New Expense' : 'Edit Expense')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            initialValue: _categoryId,
            decoration: const InputDecoration(labelText: 'Category'),
            items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
            onChanged: (v) => setState(() => _categoryId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amount,
            decoration: const InputDecoration(labelText: 'Amount (SAR)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _date,
            decoration: const InputDecoration(labelText: 'Date'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: ['draft', 'submitted', 'approved', 'paid']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _status = v ?? 'draft'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Description'),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _categoryId == null ? null : () async {
              final body = {
                'expense_category_id': _categoryId,
                'amount': double.tryParse(_amount.text) ?? 0,
                'expense_date': _date.text,
                'description': _description.text,
                'status': _status,
              };
              final repo = ref.read(offlineExpenseRepositoryProvider);
              if (widget.expenseId == null) {
                await repo.create(body);
              } else {
                await repo.update(widget.expenseId!, body);
              }
              ref.invalidate(pendingSyncCountProvider);
              if (context.mounted) context.pop();
            },
            child: const Text('Save (offline-capable)'),
          ),
        ],
      ),
    );
  }
}

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).vehicles;
    return CrudListScreen<VehicleModel>(
      title: 'Vehicles',
      loadItems: repo.list,
      itemTitle: (v) => '${v.name} (${v.plateNumber ?? ''})',
      onTap: (v) => _edit(context, ref, v),
      onAdd: () => _edit(context, ref, null),
      onDelete: (v) => repo.delete(v.id),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, VehicleModel? item) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: item == null ? 'New Vehicle' : 'Edit Vehicle',
      initialValues: item == null ? {} : item.toJson(),
      fields: const [
        FieldConfig(key: 'name', label: 'Name', required: true),
        FieldConfig(key: 'plate_number', label: 'Plate Number'),
        FieldConfig(key: 'notes', label: 'Notes', type: FieldType.textarea),
        FieldConfig(key: 'is_active', label: 'Active', type: FieldType.boolean),
      ],
      onSave: (v) async {
        final repo = ref.read(adminRepositoriesProvider).vehicles;
        if (item == null) {
          await repo.create(v);
        } else {
          await repo.update(item.id, v);
        }
      },
    )));
  }
}
