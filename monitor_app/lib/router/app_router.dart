import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/expenses/expense_list_screen.dart';
import '../features/inventory/van_stock_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/maps/location_map_screen_wrapper.dart';
import '../features/reports/report_screens.dart';
import '../features/reports/reports_hub_screen.dart';
import '../features/sales/order_screens.dart';
import '../providers/auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: ErrorView(message: 'Page not found'),
    ),
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      if (auth.isLoading) return null;
      if (!auth.isAuthenticated) return loggingIn ? null : '/login';
      if (loggingIn) return '/';
      if (!auth.roles.contains('monitor')) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MonitorHomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
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
                    builder: (context, state) => const OrderListScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, state) =>
                            OrderDetailScreen(id: int.parse(state.pathParameters['id']!)),
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
                path: '/inventory',
                redirect: (context, state) =>
                    state.uri.path == '/inventory' ? '/inventory/van' : null,
                routes: [
                  GoRoute(path: 'van', builder: (context, state) => const VanStockScreen()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/expenses', builder: (context, state) => const ExpenseListScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsHubScreen(),
                routes: [
                  GoRoute(path: 'sales', builder: (_, _) => const SalesReportScreen()),
                  GoRoute(path: 'profit', builder: (_, _) => const ProfitReportScreen()),
                  GoRoute(path: 'expenses', builder: (_, _) => const ExpenseReportScreen()),
                  GoRoute(
                    path: 'expense-summary',
                    builder: (_, _) => const ExpenseSummaryReportScreen(),
                  ),
                  GoRoute(path: 'map', builder: (_, _) => const MonitorLocationMapScreen()),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});

class MonitorHomeShell extends StatelessWidget {
  const MonitorHomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  String _titleForLocation(String location) {
    if (RegExp(r'/sales/orders/\d+').hasMatch(location)) return 'Order detail';
    if (location.contains('/reports/map')) return 'Location map';
    if (location.contains('/reports/sales')) return 'Sales report';
    if (location.contains('/reports/profit')) return 'Profit report';
    if (location.contains('/reports/expenses')) return 'Expense report';
    if (location.contains('/reports/expense-summary')) return 'Expense summary';

    return switch (navigationShell.currentIndex) {
      0 => 'Dashboard',
      1 => 'Sales',
      2 => 'Inventory',
      3 => 'Expenses',
      4 => 'Reports',
      _ => 'ARM Monitor(M)',
    };
  }

  bool _showBackButton(BuildContext context) => GoRouter.of(context).canPop();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final title = _titleForLocation(location);
    final showBack = _showBackButton(context);

    return Scaffold(
      // The map screen draws its own AppBar — avoid a double header.
      appBar: location.contains('/reports/map')
          ? null
          : AppBar(
              leading: showBack ? BackButton(onPressed: () => context.pop()) : null,
              title: Text(title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () => context.push('/profile'),
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
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen<AuthState>(authProvider, (previous, next) => notifyListeners());
  }

  final Ref ref;
}
