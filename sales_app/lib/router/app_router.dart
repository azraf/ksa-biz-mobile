import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/select_sales_person_screen.dart';
import '../features/customers/customer_orders_screen.dart';
import '../features/customers/customer_screens.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/field_map/field_map_screen.dart';
import '../features/plan/collection_candidates_screen.dart';
import '../features/plan/plan_hub_screen.dart';
import '../features/manual_orders/convert_order_screen.dart';
import '../features/manual_orders/manual_order_detail_screen.dart';
import '../features/manual_orders/manual_order_list_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/orders/create_order_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/orders/order_edit_screen.dart';
import '../features/orders/order_list_screen.dart';
import '../features/performance/performance_screen.dart';
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
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(),
      body: ErrorView(message: AppLocalizations.of(context).commonPageNotFound),
    ),
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
        builder: (context, state, navigationShell) =>
            HomeShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(),
              ),
              // These screens live inside the shell so every page keeps the
              // bottom nav; they draw their own AppBars (shell hides its own).
              GoRoute(
                path: '/notifications',
                builder: (context, state) => const NotificationsScreen(),
              ),
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                path: '/field-map',
                builder: (context, state) => const FieldMapScreen(),
              ),
              GoRoute(
                path: '/performance',
                builder: (context, state) => const PerformanceReviewScreen(),
              ),
              GoRoute(
                path: '/watchlist',
                builder: (context, state) => const WatchlistListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (_, _) => const WatchlistCreateScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => WatchlistDetailScreen(
                      id: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: '/customers',
                builder: (context, state) => const CustomersHubScreen(),
                routes: [
                  GoRoute(
                    path: 'shop/:id',
                    builder: (_, state) {
                      final args = state.extra as CustomerDetailRouteArgs?;
                      return CustomerDetailScreen(
                        customerType: 'customer_shop',
                        customerId: int.parse(state.pathParameters['id']!),
                        initialCustomer: args?.customer,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'orders',
                        builder: (_, state) => CustomerOrdersScreen(
                          customerType: 'customer_shop',
                          customerId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'van/:id',
                    builder: (_, state) {
                      final args = state.extra as CustomerDetailRouteArgs?;
                      return CustomerDetailScreen(
                        customerType: 'customer_van',
                        customerId: int.parse(state.pathParameters['id']!),
                        initialCustomer: args?.customer,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'orders',
                        builder: (_, state) => CustomerOrdersScreen(
                          customerType: 'customer_van',
                          customerId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'importer/:id',
                    builder: (_, state) {
                      final args = state.extra as CustomerDetailRouteArgs?;
                      return CustomerDetailScreen(
                        customerType: 'customer_importer',
                        customerId: int.parse(state.pathParameters['id']!),
                        initialCustomer: args?.customer,
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'orders',
                        builder: (_, state) => CustomerOrdersScreen(
                          customerType: 'customer_importer',
                          customerId: int.parse(state.pathParameters['id']!),
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
                path: '/manual-orders',
                builder: (context, state) => const ManualOrderListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => ManualOrderDetailScreen(
                      id: int.parse(state.pathParameters['id']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'convert',
                        builder: (_, state) => ConvertOrderScreen(
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
                path: '/orders',
                builder: (context, state) => const OrderListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateOrderScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => OrderDetailScreen(
                      id: int.parse(state.pathParameters['id']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) => OrderEditScreen(
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
                path: '/van-stock',
                builder: (context, state) => const VanStockScreen(),
                routes: [
                  GoRoute(
                    path: 'load',
                    builder: (_, _) => const LoadVanScreen(),
                  ),
                  GoRoute(
                    path: 'transfer',
                    builder: (_, _) => const TransferScreen(),
                  ),
                  GoRoute(
                    path: 'damage',
                    builder: (_, _) => const DamageReplacementScreen(),
                  ),
                  GoRoute(
                    path: 'exchange',
                    builder: (_, _) => const ProductExchangeScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/plan',
                builder: (context, state) =>
                    PlanHubScreen(initialTab: state.uri.queryParameters['tab']),
                routes: [
                  GoRoute(
                    path: 'candidates',
                    builder: (_, _) => const CollectionCandidatesScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Old deep link — dues now lives inside the Plan hub.
      GoRoute(path: '/dues', redirect: (_, _) => '/plan?tab=dues'),
    ],
  );
});

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  String _titleForLocation(String location, AppLocalizations l10n) {
    if (location.contains('/orders/create')) return l10n.salesTitleCreateOrder;
    if (location.contains('/orders/') && location.endsWith('/edit'))
      return l10n.salesTitleEditOrder;
    final orderDetail = RegExp(r'/orders/(\d+)');
    if (orderDetail.hasMatch(location) && !location.contains('create'))
      return l10n.salesTitleOrderDetail;
    if (location.contains('/manual-orders/') && location.endsWith('/convert'))
      return l10n.salesTitleConvertOrder;
    if (RegExp(r'/manual-orders/\d+').hasMatch(location))
      return l10n.salesTitleManualOrder;
    if (location.contains('/van-stock/load')) return l10n.salesTitleLoadVan;
    if (location.contains('/van-stock/transfer'))
      return l10n.salesTitleTransferStock;
    if (location.contains('/van-stock/damage'))
      return l10n.salesTitleDamageReplacement;
    if (location.contains('/van-stock/exchange'))
      return l10n.salesTitleProductExchange;

    return switch (navigationShell.currentIndex) {
      0 => l10n.salesTitleDashboard,
      1 => l10n.salesTitleManualOrders,
      2 => l10n.salesTitleOrders,
      3 => l10n.salesTitleVanStock,
      4 => l10n.salesTitlePlan,
      _ => l10n.salesAppName,
    };
  }

  bool _showBackButton(BuildContext context) {
    return GoRouter.of(context).canPop();
  }

  /// Screens moved into the shell that draw their own AppBar — the shell
  /// hides its bar there to avoid a double header.
  bool _screenHasOwnAppBar(String location) {
    return location.startsWith('/customers') ||
        location.startsWith('/watchlist') ||
        location.startsWith('/field-map') ||
        location.startsWith('/notifications') ||
        location.startsWith('/profile') ||
        location.startsWith('/plan/candidates');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).matchedLocation;
    final title = _titleForLocation(location, l10n);
    final showBack = _showBackButton(context);

    return Scaffold(
      appBar: _screenHasOwnAppBar(location)
          ? null
          : AppBar(
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
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.salesNavHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.phone_in_talk_outlined),
            selectedIcon: const Icon(Icons.phone_in_talk),
            label: l10n.salesNavManual,
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: l10n.salesNavOrders,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_shipping_outlined),
            selectedIcon: const Icon(Icons.local_shipping),
            label: l10n.salesNavVan,
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note_outlined),
            selectedIcon: const Icon(Icons.event_note),
            label: l10n.salesNavPlan,
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
