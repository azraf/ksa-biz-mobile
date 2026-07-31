import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/customer_context_provider.dart';
import '../../providers/repositories.dart';
import '../../utils/order_filters.dart';

class ManualOrderListScreen extends ConsumerStatefulWidget {
  const ManualOrderListScreen({super.key});

  @override
  ConsumerState<ManualOrderListScreen> createState() => _ManualOrderListScreenState();
}

class _ManualOrderListScreenState extends ConsumerState<ManualOrderListScreen> {
  List<ManualOrderRequestModel> _requests = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = ref.read(customerContextProvider).profile;
    if (profile == null) {
      setState(() {
        _loading = false;
        _error = 'Customer profile not loaded.';
      });
      return;
    }

    if (!profile.isShop) {
      setState(() {
        _requests = [];
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await ref.read(manualOrderRepositoryProvider).list();
      setState(() {
        _requests = filterManualOrdersForCustomer(result.items, profile);
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
    final profile = ref.watch(customerContextProvider).profile;

    if (profile != null && !profile.isShop) {
      return const EmptyView(
        message: 'Manual order requests are available for shop accounts only.',
        icon: Icons.info_outline,
      );
    }

    return Scaffold(
      floatingActionButton: profile?.isShop == true
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/manual-orders/create'),
              icon: const Icon(Icons.add),
              label: const Text('New request'),
            )
          : null,
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _requests.isEmpty
                  ? const EmptyView(message: 'No manual order requests yet')
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        itemCount: _requests.length,
                        itemBuilder: (_, i) {
                          final item = _requests[i];
                          return ListTile(
                            title: Text(item.customerShop?.name ?? 'Shop #${item.customerShopId}'),
                            subtitle: Text(
                              [
                                if (item.notes != null && item.notes!.isNotEmpty) item.notes!,
                                '${item.source} · ${item.status}',
                              ].join('\n'),
                            ),
                            trailing: StatusChip(label: item.status),
                            onTap: () => context.push('/manual-orders/${item.id}'),
                          );
                        },
                      ),
                    ),
    );
  }
}
