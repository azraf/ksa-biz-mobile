import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

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

  String _titleForLocation(BuildContext context, String location) {
    final l10n = AppLocalizations.of(context);
    if (location.contains('/orders/create')) return l10n.orderTitleCreateOrder;
    if (RegExp(r'/orders/\d+').hasMatch(location)) return l10n.orderTitleOrderDetail;
    if (location.contains('/manual-orders/create')) return l10n.orderTitleNewRequest;
    if (RegExp(r'/manual-orders/\d+').hasMatch(location)) return l10n.orderTitleRequestDetail;

    return switch (navigationShell.currentIndex) {
      0 => l10n.orderTitleCatalog,
      1 => l10n.orderNavOrders,
      2 => l10n.orderTitleManualOrders,
      3 => l10n.orderNavProfile,
      _ => l10n.orderAppName,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).matchedLocation;
    final title = _titleForLocation(context, location);
    final showBack = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(
        leading: showBack ? BackButton(onPressed: () => context.pop()) : null,
        title: Text(title),
        actions: [
          if (navigationShell.currentIndex != 3)
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.go('/profile'),
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.storefront_outlined),
            selectedIcon: const Icon(Icons.storefront),
            label: l10n.orderNavCatalog,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.orderNavOrders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.phone_in_talk_outlined),
            selectedIcon: const Icon(Icons.phone_in_talk),
            label: l10n.orderNavManual,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.orderNavProfile,
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
