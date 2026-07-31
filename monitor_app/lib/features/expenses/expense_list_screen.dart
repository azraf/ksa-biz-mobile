import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  List<ExpenseModel> _expenses = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(expenseRepositoryProvider).list();
      setState(() {
        _expenses = result.items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    if (_expenses.isEmpty) return const EmptyView(message: 'No expenses found');

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _expenses.length,
        itemBuilder: (_, i) {
          final expense = _expenses[i];
          return ListTile(
            title: Text(currency.format(expense.amount)),
            subtitle: Text('${expense.expenseDate} · ${expense.status}'),
            trailing: expense.category?.name != null ? Text(expense.category!.name) : null,
            onTap: () => _showDetail(expense),
          );
        },
      ),
    );
  }

  void _showDetail(ExpenseModel expense) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Expense detail', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(currency.format(expense.amount)),
              subtitle: Text('${expense.expenseDate} · ${expense.status}'),
            ),
            if (expense.category?.name != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Category'),
                subtitle: Text(expense.category!.name),
              ),
            if (expense.description != null && expense.description!.isNotEmpty)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Description'),
                subtitle: Text(expense.description!),
              ),
          ],
        ),
      ),
    );
  }
}
