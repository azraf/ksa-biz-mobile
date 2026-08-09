import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class DiscountApprovalScreen extends ConsumerStatefulWidget {
  const DiscountApprovalScreen({super.key});

  @override
  ConsumerState<DiscountApprovalScreen> createState() => _DiscountApprovalScreenState();
}

class _DiscountApprovalScreenState extends ConsumerState<DiscountApprovalScreen> {
  List<DiscountApprovalRequestModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await ref.read(orderRepositoryProvider).listPendingDiscountRequests();
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _approve(int id) async {
    await ref.read(orderRepositoryProvider).approveDiscount(id);
    await _load();
  }

  Future<void> _reject(int id) async {
    await ref.read(orderRepositoryProvider).rejectDiscount(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Discount approval')),
        body: const LoadingView(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Discount approval')),
      body: _items.isEmpty
          ? const EmptyView(message: 'No pending discount requests')
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) {
                final r = _items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Order #${r.orderId}'),
                    subtitle: Text('${currency.format(r.requestedAmount)} · ${r.reason ?? ''}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: Icon(Icons.check, color: AppColors.success(context)), onPressed: () => _approve(r.id)),
                        IconButton(icon: Icon(Icons.close, color: AppColors.danger(context)), onPressed: () => _reject(r.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
