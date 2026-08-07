import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/approval/discount_approval_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/catalog/catalog_screens.dart';
import '../features/customers/assignment_screens.dart';
import '../features/customers/customers_hub_screen.dart';
import '../features/customers/customer_screens.dart';
import '../features/customers/watchlist_screens.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/expenses/expense_screens.dart';
import '../features/inventory/inventory_screens.dart';
import '../features/more/more_hub_screen.dart';
import '../features/reports/report_screens.dart';
import '../features/sales/manual_order_detail_screen.dart';
import '../features/sales/order_edit_screen.dart';
import '../features/sales/sales_screens.dart';
import '../features/shipping/shipping_screens.dart';
import '../features/profile/profile_screen.dart';
import '../features/users/user_screens.dart';
import '../providers/auth_provider.dart';
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
      if (loggingIn) return '/';
      if (!auth.isAdmin) return '/login';

      final legacy = _legacyPathRedirect(state.matchedLocation);
      if (legacy != null) return legacy;

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminHomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sales',
                redirect: (_, __) => '/sales/orders',
                routes: [
                  GoRoute(
                    path: 'orders',
                    builder: (_, __) => const OrdersScreen(),
                    routes: [
                      GoRoute(path: 'create', builder: (_, __) => const CreateOrderScreen()),
                      GoRoute(
                        path: ':id',
                        builder: (_, s) =>
                            OrderDetailScreen(orderId: int.parse(s.pathParameters['id']!)),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (_, s) =>
                                AdminOrderEditScreen(orderId: int.parse(s.pathParameters['id']!)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(path: 'manual-orders', builder: (_, __) => const ManualOrdersScreen(), routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, s) =>
                          AdminManualOrderDetailScreen(id: int.parse(s.pathParameters['id']!)),
                    ),
                  ]),
                  GoRoute(path: 'invoices', builder: (_, __) => const InvoicesScreen()),
                  GoRoute(path: 'persons', builder: (_, __) => const SalesPersonsScreen()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/customers',
                redirect: (_, __) => '/customers/hub',
                routes: [
                  GoRoute(path: 'hub', builder: (_, __) => const CustomersHubScreen()),
                  GoRoute(path: 'shops', builder: (_, __) => const CustomerShopsScreen(), routes: [
                    GoRoute(
                      path: ':id',
                      builder: (_, s) => ShopDetailScreen(shopId: int.parse(s.pathParameters['id']!)),
                    ),
                  ]),
                  GoRoute(path: 'vans', builder: (_, __) => const CustomerVansScreen()),
                  GoRoute(path: 'importers', builder: (_, __) => const CustomerImportersScreen()),
                  GoRoute(path: 'types', builder: (_, __) => const CustomerTypesScreen()),
                  GoRoute(path: 'areas', builder: (_, __) => const AreasScreen()),
                  GoRoute(path: 'assignments', builder: (_, __) => const CustomerAssignmentsScreen()),
                  GoRoute(path: 'dashboard', builder: (_, __) => const SalesPersonDashboardScreen()),
                  GoRoute(path: 'territories', builder: (_, __) => const SalesPersonTerritoryScreen()),
                  GoRoute(path: 'calendar', builder: (_, __) => const AssignmentCalendarScreen()),
                  GoRoute(path: 'unassigned', builder: (_, __) => const UnassignedCustomersScreen()),
                  GoRoute(path: 'audit', builder: (_, __) => const AssignmentAuditScreen()),
                  GoRoute(path: 'map', builder: (_, __) => const ShopMapScreen()),
                  GoRoute(path: 'watchlist', builder: (_, __) => const AdminWatchlistScreen()),
                  GoRoute(path: 'churn', builder: (_, __) => const ChurnRiskScreen()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                redirect: (_, __) => '/inventory/warehouse',
                routes: [
                  GoRoute(path: 'warehouse', builder: (_, __) => const WarehouseStockScreen()),
                  GoRoute(path: 'van', builder: (_, __) => const VanStockScreen()),
                  GoRoute(path: 'load', builder: (_, __) => const LoadVanScreen()),
                  GoRoute(path: 'adjust', builder: (_, __) => const StockAdjustmentScreen()),
                  GoRoute(path: 'damage-writeoff', builder: (_, __) => const DamageWriteoffScreen()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (_, __) => const MoreHubScreen(),
                routes: [
                  GoRoute(path: 'reports/sales', builder: (_, __) => const SalesReportScreen()),
                  GoRoute(path: 'reports/profit', builder: (_, __) => const ProfitReportScreen()),
                  GoRoute(path: 'reports/expenses', builder: (_, __) => const ExpenseReportScreen()),
                  GoRoute(
                    path: 'reports/expense-summary',
                    builder: (_, __) => const ExpenseSummaryReportScreen(),
                  ),
                  GoRoute(path: 'expenses/categories', builder: (_, __) => const ExpenseCategoriesScreen()),
                  GoRoute(
                    path: 'expenses/list',
                    builder: (_, __) => const ExpensesScreen(),
                    routes: [
                      GoRoute(path: 'create', builder: (_, __) => const ExpenseFormScreen()),
                      GoRoute(
                        path: ':id',
                        builder: (_, s) =>
                            ExpenseFormScreen(expenseId: int.parse(s.pathParameters['id']!)),
                      ),
                    ],
                  ),
                  GoRoute(path: 'expenses/vehicles', builder: (_, __) => const VehiclesScreen()),
                  GoRoute(path: 'catalog/tags', builder: (_, __) => const TagsScreen()),
                  GoRoute(path: 'catalog/brands', builder: (_, __) => const BrandsScreen()),
                  GoRoute(path: 'catalog/units', builder: (_, __) => const UnitsScreen()),
                  GoRoute(path: 'catalog/categories', builder: (_, __) => const CategoriesScreen()),
                  GoRoute(
                    path: 'catalog/products',
                    builder: (_, __) => const ProductsScreen(),
                    routes: [
                      GoRoute(path: 'create', builder: (_, __) => const ProductFormScreen()),
                      GoRoute(
                        path: ':id',
                        builder: (_, s) =>
                            ProductFormScreen(productId: int.parse(s.pathParameters['id']!)),
                      ),
                    ],
                  ),
                  GoRoute(path: 'catalog/promotions', builder: (_, __) => const PromotionsScreen()),
                  GoRoute(path: 'shipping/countries', builder: (_, __) => const CountriesScreen()),
                  GoRoute(path: 'shipping/suppliers', builder: (_, __) => const SuppliersScreen()),
                  GoRoute(path: 'shipping/containers', builder: (_, __) => const ContainersScreen()),
                  GoRoute(path: 'shipping/purchases', builder: (_, __) => const PurchasesScreen()),
                  GoRoute(path: 'approval/discount', builder: (_, __) => const DiscountApprovalScreen()),
                  GoRoute(path: 'users', builder: (_, __) => const UsersScreen()),
                  GoRoute(path: 'profile', builder: (_, __) => const AdminProfileScreen()),
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
              leading: const CircleAvatar(child: Icon(Icons.admin_panel_settings)),
              title: Text(auth.user?.name ?? 'Admin'),
              subtitle: Text(auth.user?.email ?? ''),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () async {
                Navigator.pop(ctx);
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
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
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
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
  final Ref ref;
}
