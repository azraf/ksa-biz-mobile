import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/select_sales_person_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/dues/dues_screen.dart';
import '../features/manual_orders/convert_order_screen.dart';
import '../features/manual_orders/manual_order_detail_screen.dart';
import '../features/manual_orders/manual_order_list_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/orders/create_order_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/order_edit_screen.dart';
import '../features/orders/order_list_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/van_stock/damage_replacement_screen.dart';
import '../features/van_stock/load_van_screen.dart';
import '../features/van_stock/product_exchange_screen.dart';
import '../features/van_stock/transfer_screen.dart';
import '../features/van_stock/van_stock_screen.dart';
import '../features/watchlist/watchlist_screens.dart';
import '../providers/auth_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final loggingIn = location == '/login';
      final selecting = location == '/select-salesperson';

      if (auth.isLoading) return null;
      if (!auth.isAuthenticated) return loggingIn ? null : '/login';
      if (loggingIn) {
        return auth.needsSalesPersonSelection ? '/select-salesperson' : '/';
      }
      if (auth.needsSalesPersonSelection && !selecting) {
        return '/select-salesperson';
      }
      if (selecting && !auth.needsSalesPersonSelection) {
        return '/';
      }
      if (!auth.canPickSalesPerson &&
          auth.effectiveSalesPersonId == null &&
          !selecting &&
          !loggingIn) {
        return null;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/select-salesperson',
        builder: (context, state) => const SelectSalesPersonScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manual-orders',
                builder: (context, state) => const ManualOrderListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        ManualOrderDetailScreen(id: int.parse(state.pathParameters['id']!)),
                    routes: [
                      GoRoute(
                        path: 'convert',
                        builder: (_, state) =>
                            ConvertOrderScreen(id: int.parse(state.pathParameters['id']!)),
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
                path: '/orders',
                builder: (context, state) => const OrderListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateOrderScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        OrderDetailScreen(id: int.parse(state.pathParameters['id']!)),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) =>
                            OrderEditScreen(id: int.parse(state.pathParameters['id']!)),
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
                path: '/van-stock',
                builder: (context, state) => const VanStockScreen(),
                routes: [
                  GoRoute(path: 'load', builder: (_, __) => const LoadVanScreen()),
                  GoRoute(path: 'transfer', builder: (_, __) => const TransferScreen()),
                  GoRoute(path: 'damage', builder: (_, __) => const DamageReplacementScreen()),
                  GoRoute(path: 'exchange', builder: (_, __) => const ProductExchangeScreen()),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/dues', builder: (context, state) => const DuesScreen()),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/watchlist',
        builder: (context, state) => const WatchlistListScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (_, __) => const WatchlistCreateScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (_, state) => WatchlistDetailScreen(
              id: int.parse(state.pathParameters['id']!),
            ),
          ),
        ],
      ),
    ],
  );
});

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  String _titleForLocation(String location) {
    if (location.contains('/orders/create')) return 'Create order';
    if (location.contains('/orders/') && location.endsWith('/edit')) return 'Edit order';
    final orderDetail = RegExp(r'/orders/(\d+)');
    if (orderDetail.hasMatch(location) && !location.contains('create')) return 'Order detail';
    if (location.contains('/manual-orders/') && location.endsWith('/convert')) return 'Convert to order';
    if (RegExp(r'/manual-orders/\d+').hasMatch(location)) return 'Manual order';
    if (location.contains('/van-stock/load')) return 'Load van';
    if (location.contains('/van-stock/transfer')) return 'Transfer stock';
    if (location.contains('/van-stock/damage')) return 'Damage replacement';
    if (location.contains('/van-stock/exchange')) return 'Product exchange';

    return switch (navigationShell.currentIndex) {
      0 => 'Dashboard',
      1 => 'Manual Orders',
      2 => 'Orders',
      3 => 'Van Stock',
      4 => 'Dues',
      _ => 'ARM Sales(M)',
    };
  }

  bool _showBackButton(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final title = _titleForLocation(location);
    final showBack = _showBackButton(context);

    return Scaffold(
      appBar: AppBar(
        leading: showBack
            ? BackButton(onPressed: () => context.pop())
            : null,
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
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_in_talk_outlined),
            selectedIcon: Icon(Icons.phone_in_talk),
            label: 'Manual',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Van',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Dues',
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
