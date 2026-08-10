import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

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
    // customerContextProvider resolves asynchronously — wait for it rather
    // than reading .profile before it's had a chance to finish (see
    // OrderHomeScreen._load for the same race and why it matters).
    await ref.read(customerContextProvider.notifier).load();
    final profile = ref.read(customerContextProvider).profile;
    if (profile == null) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        _loading = false;
        _error = l10n.orderCustomerProfileNotLoaded;
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
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(customerContextProvider).profile;

    return Scaffold(
      floatingActionButton: profile != null
          ? TranslucentFab(
              onOpen: () => context.push('/manual-orders/create'),
              icon: const Icon(Icons.add),
              label: l10n.orderManualNewRequest,
            )
          : null,
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _requests.isEmpty
                  ? EmptyView(message: l10n.orderManualEmpty)
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView.builder(
                        padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                        itemCount: _requests.length,
                        itemBuilder: (_, i) {
                          final item = _requests[i];
                          return ListTile(
                            title: Text(
                              item.customerName ??
                                  l10n.commonShopFallback(item.customerShopId ?? item.id),
                            ),
                            subtitle: Text(
                              [
                                if (item.notes != null && item.notes!.isNotEmpty) item.notes!,
                                '${item.source} · ${localizedStatusLabel(context, item.status)}',
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
