import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class ManualOrderListScreen extends ConsumerStatefulWidget {
  const ManualOrderListScreen({super.key});

  @override
  ConsumerState<ManualOrderListScreen> createState() => _ManualOrderListScreenState();
}

class _ManualOrderListScreenState extends ConsumerState<ManualOrderListScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _lists = <int, List<ManualOrderRequestModel>>{};
  final _loading = <int, bool>{};
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) _loadTab(_tabs.index);
    });
    _loadTab(0);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _loadTab(int index) async {
    final auth = ref.read(authProvider);
    final salesPersonId = requireSalesPersonId(auth);
    setState(() {
      _loading[index] = true;
      _error = null;
    });

    try {
      final repo = ref.read(manualOrderRepositoryProvider);
      PaginatedResponse<ManualOrderRequestModel> result;
      switch (index) {
        case 0:
          result = await repo.list(openPool: true);
          break;
        case 1:
          result = await repo.list(assignedSalesPersonId: salesPersonId, status: 'assigned');
          break;
        case 2:
          result = await repo.list(assignedSalesPersonId: salesPersonId, status: 'in_review');
          break;
        default:
          result = await repo.list(status: 'converted');
      }
      setState(() {
        _lists[index] = result.items;
        _loading[index] = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading[index] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Open pool'),
            Tab(text: 'Assigned'),
            Tab(text: 'In review'),
            Tab(text: 'Converted'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: List.generate(4, (index) {
              if (_loading[index] == true) return const LoadingView();
              if (_error != null) return ErrorView(message: _error!, onRetry: () => _loadTab(index));
              final items = _lists[index] ?? [];
              if (items.isEmpty) return const EmptyView(message: 'No manual orders');
              return RefreshIndicator(
                onRefresh: () => _loadTab(index),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return ListTile(
                      title: Text(item.customerShop?.name ?? 'Shop #${item.customerShopId}'),
                      subtitle: Text('${item.source} · ${item.status}'),
                      trailing: StatusChip(label: item.status),
                      onTap: () => context.push('/manual-orders/${item.id}'),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
