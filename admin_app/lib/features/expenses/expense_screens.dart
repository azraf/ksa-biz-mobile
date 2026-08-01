import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';
import '../../providers/screen_providers.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';

class ExpenseCategoriesScreen extends ConsumerWidget {
  const ExpenseCategoriesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<ExpenseCategoryModel>>(
      future: ref.read(expenseRepositoryProvider).listCategories(withChildren: true),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: LoadingView());
        }
        if (snap.hasError) {
          return Scaffold(
            body: ErrorView(
              message: AppErrorMapper.localize(context, snap.error!),
              error: snap.error,
            ),
          );
        }
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
    final expensesAsync = ref.watch(expensesListProvider);

    final listPadding = fabScrollPadding(context, includeBottomNav: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/more/expenses/list/create'),
        child: const Icon(Icons.add),
      ),
      body: expensesAsync.when(
        loading: () => ListView.builder(
          padding: listPadding,
          itemCount: 8,
          itemBuilder: (_, __) => const SkeletonListTile(),
        ),
        error: (e, _) => ErrorView(
          message: AppErrorMapper.localize(context, e),
          error: e,
          onRetry: () => ref.read(expensesListProvider.notifier).refresh(),
        ),
        data: (expenses) => expenses.isEmpty
            ? const EmptyView(message: 'No expenses yet')
            : RefreshIndicator(
                onRefresh: () => ref.read(expensesListProvider.notifier).refresh(),
                child: ListView.separated(
                  padding: listPadding,
                  itemCount: expenses.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final e = expenses[i];
                    final pending = e.id < 0;
                    return ListTile(
                      title: Text('${e.expenseDate} — SAR ${e.amount.toStringAsFixed(2)}'),
                      subtitle: Text(e.status),
                      trailing: pending
                          ? const StatusChip(label: 'pending_sync', icon: Icons.cloud_upload_outlined)
                          : null,
                      onTap: () => context.push('/more/expenses/list/${e.id}'),
                    );
                  },
                ),
              ),
      ),
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
  bool _loading = true;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      _categories = await ref.read(expenseRepositoryProvider).listCategories();
      if (widget.expenseId != null) {
        ExpenseModel expense;
        if (widget.expenseId! < 0) {
          final list = await ref.read(offlineExpenseRepositoryProvider).list();
          expense = list.items.firstWhere((e) => e.id == widget.expenseId);
        } else {
          expense = await ref.read(expenseRepositoryProvider).get(widget.expenseId!);
        }
        _categoryId = expense.expenseCategoryId;
        _amount.text = expense.amount.toString();
        _date.text = expense.expenseDate;
        _description.text = expense.description ?? '';
        _status = expense.status;
      } else {
        if (_categories.isNotEmpty) _categoryId = _categories.first.id;
        _date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loadError = e;
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    if (_categoryId == null) return;
    final body = {
      'expense_category_id': _categoryId,
      'amount': double.tryParse(_amount.text) ?? 0,
      'expense_date': _date.text,
      'description': _description.text,
      'status': _status,
    };
    try {
      final repo = ref.read(offlineExpenseRepositoryProvider);
      if (widget.expenseId == null) {
        await repo.create(body);
      } else {
        await repo.update(widget.expenseId!, body);
      }
      ref.invalidate(pendingSyncCountProvider);
      ref.invalidate(expensesListProvider);
      if (context.mounted) context.pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: LoadingView());
    if (_loadError != null) {
      return Scaffold(
        body: ErrorView(
          message: AppErrorMapper.localize(context, _loadError!),
          error: _loadError,
          onRetry: _load,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.expenseId == null ? 'New Expense' : 'Edit Expense')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            value: _categoryId,
            decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            items: _categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
            onChanged: (v) => setState(() => _categoryId = v),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amount,
            decoration: const InputDecoration(labelText: 'Amount (SAR)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _date,
            decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
            items: ['draft', 'submitted', 'approved', 'paid']
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _status = v ?? 'draft'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _description,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _categoryId == null ? null : _save,
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
        if (item == null) await repo.create(v); else await repo.update(item.id, v);
      },
    )));
  }
}
