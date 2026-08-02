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
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await ref.read(orderRepositoryProvider).listPendingDiscountRequests();
      setState(() {
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _approve(int id) async {
    try {
      await ref.read(orderRepositoryProvider).approveDiscount(id);
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
        );
      }
    }
  }

  Future<void> _reject(int id) async {
    try {
      await ref.read(orderRepositoryProvider).rejectDiscount(id);
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    if (_loading) return const Scaffold(body: LoadingView());
    if (_error != null) {
      return Scaffold(
        body: ErrorView(
          message: AppErrorMapper.localize(context, _error!),
          error: _error,
          onRetry: _load,
        ),
      );
    }

    return Scaffold(
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
                        IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () => _approve(r.id)),
                        IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () => _reject(r.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
