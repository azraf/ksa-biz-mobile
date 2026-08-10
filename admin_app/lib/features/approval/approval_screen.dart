import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/repositories.dart';

class ApprovalScreen extends ConsumerStatefulWidget {
  const ApprovalScreen({super.key});

  @override
  ConsumerState<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends ConsumerState<ApprovalScreen> {
  List<DiscountApprovalRequestModel> _discounts = [];
  List<DiscountApprovalRequestModel> _cancellations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(orderRepositoryProvider);
      final discounts = await repo.listPendingDiscountRequests();
      final cancellations = await repo.listPendingCancellationRequests();
      setState(() {
        _discounts = discounts;
        _cancellations = cancellations;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _approveDiscount(int id) async {
    await ref.read(orderRepositoryProvider).approveDiscount(id);
    await _load();
  }

  Future<void> _rejectDiscount(int id) async {
    await ref.read(orderRepositoryProvider).rejectDiscount(id);
    await _load();
  }

  Future<void> _approveCancellation(int id) async {
    await ref.read(orderRepositoryProvider).approveCancellation(id);
    await _load();
  }

  Future<void> _rejectCancellation(int id) async {
    await ref.read(orderRepositoryProvider).rejectCancellation(id);
    await _load();
  }

  Widget _list({
    required List<DiscountApprovalRequestModel> items,
    required String emptyMessage,
    required bool isCancellation,
    required void Function(int) onApprove,
    required void Function(int) onReject,
  }) {
    final currency = NumberFormat.currency(symbol: 'SAR ');
    if (items.isEmpty) return EmptyView(message: emptyMessage);
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) {
        final r = items[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('Order #${r.orderId}'),
            subtitle: Text(
              isCancellation
                  ? (r.reason ?? '')
                  : '${currency.format(r.requestedAmount)} · ${r.reason ?? ''}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: AppColors.success(context)),
                  onPressed: () => onApprove(r.id),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.danger(context)),
                  onPressed: () => onReject(r.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Approvals')),
        body: const LoadingView(),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Approvals'),
          bottom: const TabBar(tabs: [Tab(text: 'Discounts'), Tab(text: 'Cancellations')]),
        ),
        body: TabBarView(
          children: [
            _list(
              items: _discounts,
              emptyMessage: 'No pending discount requests',
              isCancellation: false,
              onApprove: _approveDiscount,
              onReject: _rejectDiscount,
            ),
            _list(
              items: _cancellations,
              emptyMessage: 'No pending cancellation requests',
              isCancellation: true,
              onApprove: _approveCancellation,
              onReject: _rejectCancellation,
            ),
          ],
        ),
      ),
    );
  }
}
