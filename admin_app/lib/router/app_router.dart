import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/approval/approval_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/catalog/catalog_screens.dart';
import '../features/customers/assignment_screens.dart';
import '../features/customers/customers_hub_screen.dart';
import '../features/customers/customer_screens.dart';
import '../features/customers/watchlist_screens.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/expenses/expense_screens.dart';
import '../features/inventory/inspection_screens.dart';
import '../features/inventory/inventory_screens.dart';
import '../features/more/more_hub_screen.dart';
import '../features/more/settings_screens.dart';
import '../features/reports/report_screens.dart';
import '../features/reports/sales_performance_screen.dart';
import '../features/sales/manual_order_detail_screen.dart';
import '../features/sales/team_calendar_screen.dart';
import '../features/sales/order_edit_screen.dart';
import '../features/sales/sales_screens.dart';
import '../features/shipping/shipping_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/users/user_screens.dart';
import '../providers/auth_provider.dart';
import '../providers/repositories.dart';
import '../widgets/app_drawer.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

String? _legacyPathRedirect(String location) {
  if (location.startsWith('/reports/')) return '/more$location';
  if (location.startsWith('/catalog/')) return '/more$location';
  if (location.startsWith('/shipping/')) return '/more$location';
  if (location.startsWith('/expenses/')) return '/more$location';
  if (location == '/users') return '/more/users';
  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      if (auth.isLoading) return null;
      if (!auth.isAuthenticated) return loggingIn ? null : '/login';
      if (!auth.isAdmin) return loggingIn ? null : '/login';
      if (loggingIn) return '/';

      final legacy = _legacyPathRedirect(state.matchedLocation);
      if (legacy != null) return legacy;

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: const ErrorView(message: 'Page not found'),
    ),
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminHomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const DashboardScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sales',
                redirect: (context, state) =>
                    state.uri.path == '/sales' ? '/sales/orders' : null,
                routes: [
                  GoRoute(
                    path: 'orders',
                    builder: (_, _) => const OrdersScreen(),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder: (_, _) => const CreateOrderScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, s) => OrderDetailScreen(
                          orderId: int.parse(s.pathParameters['id']!),
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (_, s) => AdminOrderEditScreen(
                              orderId: int.parse(s.pathParameters['id']!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'manual-orders',
                    builder: (_, _) => const ManualOrdersScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, s) => AdminManualOrderDetailScreen(
                          id: int.parse(s.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'invoices',
                    builder: (_, _) => const InvoicesScreen(),
                  ),
                  GoRoute(
                    path: 'persons',
                    builder: (_, _) => const SalesPersonsScreen(),
                  ),
                  GoRoute(
                    path: 'team-calendar',
                    builder: (_, _) => const TeamCalendarScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customers',
                redirect: (context, state) =>
                    state.uri.path == '/customers' ? '/customers/hub' : null,
                routes: [
                  GoRoute(
                    path: 'hub',
                    builder: (_, _) => const CustomersHubScreen(),
                  ),
                  GoRoute(
                    path: 'shops',
                    builder: (_, _) => const CustomerShopsScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, s) => ShopDetailScreen(
                          shopId: int.parse(s.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'vans',
                    builder: (_, _) => const CustomerVansScreen(),
                  ),
                  GoRoute(
                    path: 'importers',
                    builder: (_, _) => const CustomerImportersScreen(),
                  ),
                  GoRoute(
                    path: 'types',
                    builder: (_, _) => const CustomerTypesScreen(),
                  ),
                  GoRoute(
                    path: 'areas',
                    builder: (_, _) => const AreasScreen(),
                  ),
                  GoRoute(
                    path: 'assignments',
                    builder: (_, _) => const CustomerAssignmentsScreen(),
                  ),
                  GoRoute(
                    path: 'dashboard',
                    builder: (_, _) => const SalesPersonDashboardScreen(),
                  ),
                  GoRoute(
                    path: 'territories',
                    builder: (_, _) => const SalesPersonTerritoryScreen(),
                  ),
                  GoRoute(
                    path: 'calendar',
                    builder: (_, _) => const AssignmentCalendarScreen(),
                  ),
                  GoRoute(
                    path: 'unassigned',
                    builder: (_, _) => const UnassignedCustomersScreen(),
                  ),
                  GoRoute(
                    path: 'audit',
                    builder: (_, _) => const AssignmentAuditScreen(),
                  ),
                  GoRoute(
                    path: 'map',
                    builder: (_, _) => const ShopMapScreen(),
                  ),
                  GoRoute(
                    path: 'watchlist',
                    builder: (_, _) => const AdminWatchlistScreen(),
                  ),
                  GoRoute(
                    path: 'churn',
                    builder: (_, _) => const ChurnRiskScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                redirect: (context, state) => state.uri.path == '/inventory'
                    ? '/inventory/warehouse'
                    : null,
                routes: [
                  GoRoute(
                    path: 'warehouse',
                    builder: (_, _) => const WarehouseStockScreen(),
                  ),
                  GoRoute(
                    path: 'van',
                    builder: (_, _) => const VanStockScreen(),
                  ),
                  GoRoute(
                    path: 'load',
                    builder: (_, _) => const LoadVanScreen(),
                  ),
                  GoRoute(
                    path: 'adjust',
                    builder: (_, _) => const StockAdjustmentScreen(),
                  ),
                  GoRoute(
                    path: 'damage-writeoff',
                    builder: (_, _) => const DamageWriteoffScreen(),
                  ),
                  GoRoute(
                    path: 'inspections',
                    builder: (_, _) => const InventoryInspectionsListScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (context, state) => InventoryInspectionDetailScreen(
                          id: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (_, _) => const MoreHubScreen(),
                routes: [
                  GoRoute(
                    path: 'reports/sales',
                    builder: (_, _) => const SalesReportScreen(),
                  ),
                  GoRoute(
                    path: 'reports/sales-performance',
                    builder: (_, _) => const SalesPerformanceScreen(),
                  ),
                  GoRoute(
                    path: 'reports/profit',
                    builder: (_, _) => const ProfitReportScreen(),
                  ),
                  GoRoute(
                    path: 'reports/expenses',
                    builder: (_, _) => const ExpenseReportScreen(),
                  ),
                  GoRoute(
                    path: 'reports/expense-summary',
                    builder: (_, _) => const ExpenseSummaryReportScreen(),
                  ),
                  GoRoute(
                    path: 'expenses/categories',
                    builder: (_, _) => const ExpenseCategoriesScreen(),
                  ),
                  GoRoute(
                    path: 'expenses/list',
                    builder: (_, _) => const ExpensesScreen(),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder: (_, _) => const ExpenseFormScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, s) => ExpenseFormScreen(
                          expenseId: int.parse(s.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'expenses/vehicles',
                    builder: (_, _) => const VehiclesScreen(),
                  ),
                  GoRoute(
                    path: 'catalog/tags',
                    builder: (_, _) => const TagsScreen(),
                  ),
                  GoRoute(
                    path: 'catalog/brands',
                    builder: (_, _) => const BrandsScreen(),
                  ),
                  GoRoute(
                    path: 'catalog/units',
                    builder: (_, _) => const UnitsScreen(),
                  ),
                  GoRoute(
                    path: 'catalog/categories',
                    builder: (_, _) => const CategoriesScreen(),
                  ),
                  GoRoute(
                    path: 'catalog/products',
                    builder: (_, _) => const ProductsScreen(),
                    routes: [
                      GoRoute(
                        path: 'create',
                        builder: (_, _) => const ProductFormScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, s) => ProductFormScreen(
                          productId: int.parse(s.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'catalog/promotions',
                    builder: (_, _) => const PromotionsScreen(),
                  ),
                  GoRoute(
                    path: 'shipping/countries',
                    builder: (_, _) => const CountriesScreen(),
                  ),
                  GoRoute(
                    path: 'shipping/suppliers',
                    builder: (_, _) => const SuppliersScreen(),
                  ),
                  GoRoute(
                    path: 'shipping/containers',
                    builder: (_, _) => const ContainersScreen(),
                  ),
                  GoRoute(
                    path: 'shipping/purchases',
                    builder: (_, _) => const PurchasesScreen(),
                  ),
                  GoRoute(
                    path: 'approval/discount',
                    builder: (_, _) => const ApprovalScreen(),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (_, _) => const AppSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'users',
                    builder: (_, _) => const UsersScreen(),
                  ),
                  GoRoute(
                    path: 'profile',
                    builder: (_, _) => const AdminProfileScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class AdminHomeShell extends ConsumerWidget {
  const AdminHomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  String _titleForIndex(int index) {
    return switch (index) {
      0 => 'Home',
      1 => 'Sales',
      2 => 'Customers',
      3 => 'Inventory',
      _ => 'More',
    };
  }

  void _showProfileMenu(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider);
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.admin_panel_settings),
              ),
              title: Text(auth.user?.name ?? 'Admin'),
              subtitle: Text(auth.user?.email ?? ''),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () async {
                Navigator.pop(ctx);
                if (!context.mounted) return;
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
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Shell app bar only when nothing is pushed; a pushed screen brings its
    // own. The Sales/Inventory tab roots (CrudListScreen / WarehouseStockScreen)
    // also draw their own AppBar below this one — same as v1, and the
    // shell's bar is what carries the drawer/hamburger, so it must stay.
    final canPop = GoRouter.of(context).canPop();
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: canPop
          ? null
          : AppBar(
              title: Text(_titleForIndex(navigationShell.currentIndex)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () => _showProfileMenu(context, ref),
                ),
              ],
            ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Customers',
          ),
          NavigationDestination(
            icon: Icon(Icons.warehouse_outlined),
            selectedIcon: Icon(Icons.warehouse),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            selectedIcon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
  }
  final Ref ref;
}
