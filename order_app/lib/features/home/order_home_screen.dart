import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/customer_context_provider.dart';
import '../../providers/format_providers.dart';
import '../../providers/repositories.dart';
import '../../utils/order_filters.dart';

class OrderHomeScreen extends ConsumerStatefulWidget {
  const OrderHomeScreen({super.key});

  @override
  ConsumerState<OrderHomeScreen> createState() => _OrderHomeScreenState();
}

class _OrderHomeScreenState extends ConsumerState<OrderHomeScreen> {
  List<OrderModel> _recent = [];
  double _monthTotal = 0;
  double _outstanding = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = ref.read(customerContextProvider).profile;
  if (profile == null) {
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context).orderContextError;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(orderRepositoryProvider).list();
      final orders = filterOrdersForCustomer(result.items, profile);
      final now = DateTime.now();
      double month = 0;
      double due = 0;
      for (final o in orders) {
        final created = DateTime.tryParse(o.createdAt ?? '');
        if (created != null && created.year == now.year && created.month == now.month) {
          month += o.totalBill;
        }
        due += (o.amountDue > 0 ? o.amountDue : o.totalBill - o.amountPaid);
      }
      setState(() {
        _recent = orders.take(5).toList();
        _monthTotal = month;
        _outstanding = due;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = AppErrorMapper.localize(context, e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = ref.watch(currencyFormatProvider);

    if (_loading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (_, __) => const SkeletonListTile(),
      );
    }
    if (_error != null) {
      return ErrorView(message: _error!, onRetry: _load);
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.orderHomeThisMonth, style: Theme.of(context).textTheme.titleMedium),
                  Text(currency.format(_monthTotal), style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(l10n.orderHomeOutstanding),
                  Text(currency.format(_outstanding), style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(l10n.orderHomeRecent, style: Theme.of(context).textTheme.titleMedium),
          if (_recent.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.commonNoOrdersYet),
            )
          else
            ..._recent.map(
              (o) => ListTile(
                title: Text(l10n.commonOrderNumber(o.id)),
                trailing: Text(currency.format(o.totalBill)),
                onTap: () => context.push('/orders/${o.id}'),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/catalog'),
            child: Text(l10n.orderNavCatalog),
          ),
        ],
      ),
    );
  }
}
