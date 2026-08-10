import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/repositories.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final pending = ref.watch(pendingSyncCountProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(auth.user?.name ?? 'Admin'),
            accountEmail: Text(auth.user?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.admin_panel_settings),
            ),
          ),
          pending.when(
            data: (count) => count > 0
                ? ListTile(
                    leading: const Icon(Icons.sync_problem),
                    title: Text('$count pending sync'),
                    onTap: () {
                      ref.read(syncServiceProvider).syncIfOnline();
                      ref.invalidate(pendingSyncCountProvider);
                    },
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          _section(context, 'Overview'),
          _tile(context, 'Dashboard', Icons.dashboard, '/'),
          _section(context, 'Catalog'),
          _tile(context, 'Products', Icons.inventory_2, '/catalog/products'),
          _tile(context, 'Categories', Icons.category, '/catalog/categories'),
          _tile(context, 'Tags', Icons.label, '/catalog/tags'),
          _tile(context, 'Brands', Icons.branding_watermark, '/catalog/brands'),
          _tile(context, 'Units', Icons.straighten, '/catalog/units'),
          _tile(
            context,
            'Promotions',
            Icons.local_offer,
            '/catalog/promotions',
          ),
          _section(context, 'Customers'),
          _tile(context, 'Customers hub', Icons.hub_outlined, '/customers/hub'),
          _tile(context, 'Customer Types', Icons.badge, '/customers/types'),
          _tile(context, 'Vans', Icons.local_shipping, '/customers/vans'),
          _tile(context, 'Importers', Icons.business, '/customers/importers'),
          _tile(context, 'Shops', Icons.store, '/customers/shops'),
          _tile(context, 'Areas', Icons.map_outlined, '/customers/areas'),
          _tile(
            context,
            'Assignments',
            Icons.assignment_ind,
            '/customers/assignments',
          ),
          _tile(
            context,
            'SP dashboard',
            Icons.dashboard,
            '/customers/dashboard',
          ),
          _tile(context, 'Territories', Icons.map, '/customers/territories'),
          _tile(
            context,
            'Assignment calendar',
            Icons.calendar_month,
            '/customers/calendar',
          ),
          _tile(
            context,
            'Unassigned',
            Icons.person_off,
            '/customers/unassigned',
          ),
          _tile(context, 'Assignment audit', Icons.history, '/customers/audit'),
          _tile(context, 'Shop map', Icons.place, '/customers/map'),
          _tile(
            context,
            'Watch-list',
            Icons.bookmark_add_outlined,
            '/customers/watchlist',
          ),
          _tile(context, 'Churn risk', Icons.warning_amber, '/customers/churn'),
          _section(context, 'Sales'),
          _tile(context, 'Sales Persons', Icons.people, '/sales/persons'),
          _tile(context, 'Orders', Icons.receipt_long, '/sales/orders'),
          _tile(
            context,
            'Manual Orders',
            Icons.phone_in_talk,
            '/sales/manual-orders',
          ),
          _tile(
            context,
            'Team calendar',
            Icons.calendar_month,
            '/sales/team-calendar',
          ),
          _tile(context, 'Invoices', Icons.description, '/sales/invoices'),
          _section(context, 'Shipping'),
          _tile(context, 'Countries', Icons.public, '/shipping/countries'),
          _tile(context, 'Suppliers', Icons.factory, '/shipping/suppliers'),
          _tile(context, 'Containers', Icons.all_inbox, '/shipping/containers'),
          _tile(
            context,
            'Purchases',
            Icons.shopping_cart,
            '/shipping/purchases',
          ),
          _section(context, 'Expenses'),
          _tile(
            context,
            'Expense Categories',
            Icons.account_tree,
            '/expenses/categories',
          ),
          _tile(context, 'Expenses', Icons.payments, '/expenses/list'),
          _tile(
            context,
            'Vehicles',
            Icons.directions_car,
            '/expenses/vehicles',
          ),
          _section(context, 'Inventory'),
          _tile(
            context,
            'Warehouse Stock',
            Icons.warehouse,
            '/inventory/warehouse',
          ),
          _tile(
            context,
            'Van Stock',
            Icons.local_shipping_outlined,
            '/inventory/van',
          ),
          _tile(context, 'Load Van', Icons.download, '/inventory/load'),
          _tile(context, 'Stock Adjust', Icons.tune, '/inventory/adjust'),
          _tile(
            context,
            'Damage Write-off',
            Icons.delete_forever,
            '/inventory/damage-writeoff',
          ),
          _section(context, 'Reports'),
          _tile(context, 'Sales Report', Icons.bar_chart, '/reports/sales'),
          _tile(
            context,
            'Sales Performance',
            Icons.insights,
            '/more/reports/sales-performance',
          ),
          _tile(context, 'Profit Report', Icons.trending_up, '/reports/profit'),
          _tile(
            context,
            'Expense Report',
            Icons.pie_chart,
            '/reports/expenses',
          ),
          _tile(
            context,
            'Expense Summary',
            Icons.summarize,
            '/reports/expense-summary',
          ),
          _section(context, 'Admin'),
          _tile(context, 'More hub', Icons.more_horiz, '/more'),
          _tile(context, 'Users', Icons.manage_accounts, '/users'),
          const Divider(),
          BiometricSettingsTile(
            enabled: auth.biometricEnabled,
            available: auth.biometricAvailable,
            tokenExpiresAt: auth.tokenExpiresAt,
            onEnable: (reason) =>
                ref.read(authProvider.notifier).enableBiometricLogin(reason),
            onDisable: () =>
                ref.read(authProvider.notifier).disableBiometricLogin(),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              if (!await confirmLogoutWithPendingData(
                context,
                ref.read(syncServiceProvider),
              )) {
                return;
              }
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Text(
      title,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );

  Widget _tile(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: () {
      Navigator.pop(context);
      // go (not push) so a shell-branch destination switches that
      // branch and the bottom nav follows, instead of stacking a
      // duplicate route on top of the current tab.
      context.go(route);
    },
  );
}
