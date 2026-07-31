import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../providers/customer_context_provider.dart';
import '../features/auth/login_screen.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/manual_orders/create_manual_order_screen.dart';
import '../features/manual_orders/manual_order_detail_screen.dart';
import '../features/manual_orders/manual_order_list_screen.dart';
import '../features/orders/create_order_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/order_list_screen.dart';
import '../features/profile/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/catalog',
    refreshListenable: _RouterRefresh(ref),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final loggingIn = location == '/login';

      if (auth.isLoading) return null;
      if (!auth.isAuthenticated) return loggingIn ? null : '/login';
      if (loggingIn) return '/catalog';
      if (!isCustomerRole(auth.roles)) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/catalog',
                builder: (context, state) => const CatalogScreen(),
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
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/manual-orders',
                builder: (context, state) => const ManualOrderListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateManualOrderScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => ManualOrderDetailScreen(
                      id: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  String _titleForLocation(String location) {
    if (location.contains('/orders/create')) return 'Create order';
    if (RegExp(r'/orders/\d+').hasMatch(location)) return 'Order detail';
    if (location.contains('/manual-orders/create')) return 'New request';
    if (RegExp(r'/manual-orders/\d+').hasMatch(location)) return 'Request detail';

    return switch (navigationShell.currentIndex) {
      0 => 'Catalog',
      1 => 'Orders',
      2 => 'Manual Orders',
      3 => 'Profile',
      _ => 'ARM Orders',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final title = _titleForLocation(location);
    final showBack = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        leading: showBack ? BackButton(onPressed: () => context.pop()) : null,
        title: Text(title),
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
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Catalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.phone_in_talk_outlined),
            selectedIcon: Icon(Icons.phone_in_talk),
            label: 'Manual',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this.ref) {
    ref.listen<AuthState>(authProvider, (previous, next) => notifyListeners());
    ref.listen<CustomerContextState>(customerContextProvider, (previous, next) => notifyListeners());
  }

  final Ref ref;
}
