import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class MoreHubScreen extends ConsumerWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingSyncCountProvider);
    final auth = ref.watch(authProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('More', style: Theme.of(context).textTheme.headlineSmall),
        Text('Security', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        BiometricSettingsTile(
          enabled: auth.biometricEnabled,
          available: auth.biometricAvailable,
          tokenExpiresAt: auth.tokenExpiresAt,
          onEnable: (reason) => ref.read(authProvider.notifier).enableBiometricLogin(reason),
          onDisable: () => ref.read(authProvider.notifier).disableBiometricLogin(),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.sync_problem),
          title: const Text('Sync issues'),
          subtitle: const Text('Review failed or stuck offline uploads'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => SyncStatusScreen(
                  syncService: ref.read(syncServiceProvider),
                  loadItems: () => ref.read(syncServiceProvider).actionableItems(),
                ),
              ),
            );
          },
        ),
        const Divider(),
        pending.when(
          data: (count) => count > 0
              ? Card(
                  margin: const EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: const Icon(Icons.sync_problem),
                    title: Text('$count pending sync'),
                    subtitle: const Text('Tap to sync when online'),
                    onTap: () {
                      ref.read(syncServiceProvider).syncIfOnline();
                      ref.invalidate(pendingSyncCountProvider);
                    },
                  ),
                )
              : const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        const SizedBox(height: 8),
        _section(context, 'Reports', [
          _tile(context, 'Sales Report', Icons.bar_chart, '/more/reports/sales'),
          _tile(context, 'Profit Report', Icons.trending_up, '/more/reports/profit'),
          _tile(context, 'Expense Report', Icons.pie_chart, '/more/reports/expenses'),
          _tile(context, 'Expense Summary', Icons.summarize, '/more/reports/expense-summary'),
        ]),
        _section(context, 'Expenses', [
          _tile(context, 'Expenses', Icons.payments, '/more/expenses/list'),
          _tile(context, 'Expense Categories', Icons.account_tree, '/more/expenses/categories'),
          _tile(context, 'Vehicles', Icons.directions_car, '/more/expenses/vehicles'),
        ]),
        _section(context, 'Catalog', [
          _tile(context, 'Products', Icons.inventory_2, '/more/catalog/products'),
          _tile(context, 'Categories', Icons.category, '/more/catalog/categories'),
          _tile(context, 'Tags', Icons.label, '/more/catalog/tags'),
          _tile(context, 'Brands', Icons.branding_watermark, '/more/catalog/brands'),
          _tile(context, 'Units', Icons.straighten, '/more/catalog/units'),
          _tile(context, 'Promotions', Icons.local_offer, '/more/catalog/promotions'),
        ]),
        _section(context, 'Shipping', [
          _tile(context, 'Countries', Icons.public, '/more/shipping/countries'),
          _tile(context, 'Suppliers', Icons.factory, '/more/shipping/suppliers'),
          _tile(context, 'Containers', Icons.all_inbox, '/more/shipping/containers'),
          _tile(context, 'Purchases', Icons.shopping_cart, '/more/shipping/purchases'),
        ]),
        _section(context, 'Admin', [
          _tile(context, 'Discount approval', Icons.percent, '/more/approval/discount'),
          _tile(context, 'Sales Persons', Icons.people, '/sales/persons'),
          _tile(context, 'Customer Types', Icons.badge, '/customers/types'),
          _tile(context, 'Watch-list', Icons.bookmark_add_outlined, '/customers/watchlist'),
          _tile(context, 'Users', Icons.manage_accounts, '/more/users'),
        ]),
        if (kDebugMode)
          _section(context, 'Debug', [
            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Isar benchmarks'),
              subtitle: const Text('Logs timings to console'),
              onTap: () async {
                final stores = ref.read(offlineStoresProvider);
                final results = await IsarBenchmarks.runAll(stores);
                if (!context.mounted) return;
                final text = results.map((r) => r.toString()).join('\n');
                debugPrint('Isar benchmarks:\n$text');
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
              },
            ),
          ]),
      ],
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ...children,
      ],
    );
  }

  Widget _tile(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(route),
    );
  }
}
