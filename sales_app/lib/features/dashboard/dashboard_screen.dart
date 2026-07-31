import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../watchlist/watchlist_screens.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _loading = true;
  String? _error;
  double _totalDue = 0;
  int _unpaidOrders = 0;
  int _openManualOrders = 0;
  int _vanProducts = 0;
  int _lowStock = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final auth = ref.read(authProvider);
    final salesPersonId = requireSalesPersonId(auth);
    if (salesPersonId == null) {
      setState(() {
        _loading = false;
        _error = auth.canPickSalesPerson
            ? 'Select a salesperson to view the dashboard.'
            : 'Your account is not linked to a salesperson profile.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final reportRepo = ref.read(reportRepositoryProvider);
      final manualRepo = ref.read(manualOrderRepositoryProvider);
      final inventoryRepo = ref.read(inventoryRepositoryProvider);

      final due = await reportRepo.salesPersonDue(salesPersonId);
      final openPool = await manualRepo.list(openPool: true);
      final assigned = await manualRepo.list(assignedSalesPersonId: salesPersonId, status: 'assigned');
      final inReview = await manualRepo.list(assignedSalesPersonId: salesPersonId, status: 'in_review');
      final vanStock = await inventoryRepo.vanStock(salesPersonId);

      setState(() {
        _totalDue = due.data.totalDue;
        _unpaidOrders = due.data.orders.length;
        _openManualOrders = openPool.total + assigned.total + inReview.total;
        _vanProducts = vanStock.length;
        _lowStock = vanStock.where((s) {
          final alert = s.product?.alertQuantity ?? 0;
          return alert > 0 && s.balance <= alert;
        }).length;
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
    final auth = ref.watch(authProvider);
    final currency = NumberFormat.currency(symbol: 'SAR ');

    if (_loading) return const LoadingView(message: 'Loading dashboard...');
    if (_error != null) {
      return ErrorView(
        message: _error!,
        onRetry: auth.canPickSalesPerson ? () => context.go('/select-salesperson') : _load,
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Hello, ${auth.user?.name ?? 'Salesperson'}', style: Theme.of(context).textTheme.titleLarge),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => context.push('/notifications'),
              ),
            ],
          ),
          if (auth.activeSalesPerson != null)
            Text('Acting as: ${auth.activeSalesPerson!.name}', style: Theme.of(context).textTheme.bodyMedium)
          else if (auth.salesPerson != null)
            Text(auth.salesPerson!.name, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          _SummaryCard(
            title: 'Outstanding dues',
            value: currency.format(_totalDue),
            subtitle: '$_unpaidOrders unpaid orders',
            icon: Icons.payments,
            onTap: () => context.go('/dues'),
          ),
          _SummaryCard(
            title: 'Manual orders',
            value: '$_openManualOrders',
            subtitle: 'Open / assigned / in review',
            icon: Icons.phone_in_talk,
            onTap: () => context.go('/manual-orders'),
          ),
          _SummaryCard(
            title: 'Van stock',
            value: '$_vanProducts products',
            subtitle: _lowStock > 0 ? '$_lowStock low stock alerts' : 'Tap to manage stock',
            icon: Icons.local_shipping,
            onTap: () => context.go('/van-stock'),
          ),
          _SummaryCard(
            title: 'My orders',
            value: 'View all',
            subtitle: 'Create and edit orders',
            icon: Icons.receipt_long,
            onTap: () => context.go('/orders'),
          ),
          _SummaryCard(
            title: 'Watch-list',
            value: 'Save leads',
            subtitle: 'GPS locations for future visits',
            icon: Icons.bookmark_add_outlined,
            onTap: () => context.push('/watchlist'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => quickSaveWatchlistLocation(context, ref),
            icon: const Icon(Icons.add_location_alt),
            label: const Text('Quick-save current location'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
        onTap: onTap,
      ),
    );
  }
}
