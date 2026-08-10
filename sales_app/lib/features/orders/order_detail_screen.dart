import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';
import '../../widgets/customer_diary_sheet.dart';
import '../customers/customer_diary_section.dart';
import 'collect_payment_screen.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  OrderModel? _order;
  List<OrderModificationModel> _mods = [];
  bool _loading = true;
  String? _error;

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
      final repo = ref.read(offlineOrderRepositoryProvider);
      final order = await repo.get(widget.id);
      final mods = isPendingSyncOrder(widget.id)
          ? <OrderModificationModel>[]
          : await ref.read(orderRepositoryProvider).modifications(widget.id);
      setState(() {
        _order = order;
        _mods = mods;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _confirmOrder() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.statusPending),
        content: const Text('Confirm this order and deduct stock from your van?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm order')),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(orderRepositoryProvider).confirmOrder(widget.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.statusConfirmed)));
        await _load();
      }
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _collectPayment() async {
    final order = _order!;
    final due = order.outstandingDue;
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CollectPaymentScreen(orderId: order.id, amountDue: due),
      ),
    );
    if (ok == true) await _load();
  }

  Future<void> _requestDiscount() async {
    final l10n = AppLocalizations.of(context);
    final amountController = TextEditingController();
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.salesOrderRequestGrandDiscount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.salesOrderDiscountAmount),
            ),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(labelText: l10n.commonReason),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSubmit)),
        ],
      ),
    );
    if (confirmed != true) return;

    final amount = double.tryParse(amountController.text.trim());
    if (amount == null) return;

    try {
      await ref.read(orderRepositoryProvider).submitDiscountRequest(
            widget.id,
            amount: amount,
            reason: reasonController.text.trim().isEmpty ? null : reasonController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesOrderDiscountSubmitted)));
        await _load();
      }
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _voidPayment(PaymentModel payment) async {
    final l10n = AppLocalizations.of(context);
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.paymentVoidPayment),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(labelText: l10n.paymentVoidReason),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.paymentVoidPayment)),
        ],
      ),
    );
    if (confirmed != true || reasonController.text.trim().isEmpty) return;

    try {
      await ref.read(orderRepositoryProvider).voidPayment(payment.id, reason: reasonController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.paymentVoided)));
        await _load();
      }
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _cancel() async {
    final l10n = AppLocalizations.of(context);
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.salesOrderCancelOrder),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(labelText: l10n.commonReason),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonBack)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.salesOrderCancelOrder)),
        ],
      ),
    );
    if (confirmed != true || reasonController.text.trim().isEmpty) return;

    try {
      final updated = await ref.read(offlineOrderRepositoryProvider).cancel(widget.id, reasonController.text.trim());
      ref.invalidate(pendingSyncCountProvider);
      if (mounted) {
        final message = updated.status == 'cancellation_pending'
            ? l10n.salesOrderCancellationPendingApproval
            : l10n.salesOrderCancelled;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        await _load();
      }
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final order = _order!;
    final currency = NumberFormat.currency(symbol: 'SAR ');
    final pending = isPendingSyncOrder(order.id);
    final awaitingApproval = order.isDraft;
    // Drafts are editable now — edits move no stock until confirmation.
    final canEdit = order.isEditable && !pending;
    final canCancel = order.isEditable && !pending;
    final due = order.outstandingDue;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (canEdit)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: l10n.salesOrderEditTooltip,
              onPressed: () => context.push('/orders/${order.id}/edit'),
            ),
          ),
        if (pending)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Chip(
              label: Text(l10n.salesPendingSync),
              backgroundColor: AppColors.pendingContainer(context),
              visualDensity: VisualDensity.compact,
            ),
          ),
        if (awaitingApproval)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Chip(
              label: Text(l10n.statusPending),
              backgroundColor: AppColors.warningContainer(context),
              visualDensity: VisualDensity.compact,
            ),
          ),
        if (order.hasPendingDiscount)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: StatusChip(label: 'in_review'),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.invoiceNumber != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${l10n.commonInvoiceLabel} ${order.invoiceNumber}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.commonTotalLabel, style: Theme.of(context).textTheme.titleMedium),
                    StatusChip(label: order.paymentStatus),
                  ],
                ),
                Text(currency.format(order.totalBill), style: Theme.of(context).textTheme.headlineSmall),
                const Divider(),
                _row(l10n.commonPaid, currency.format(order.amountPaid)),
                _row(l10n.commonDue, currency.format(due), bold: true),
                if (order.grandDiscount > 0) _row(l10n.commonGrandDiscount, currency.format(order.grandDiscount)),
                if (order.createdAt != null) _row('Created', formatAppDateTime(order.createdAt)),
                if (order.dueDate != null) _row(l10n.commonDueDate, formatAppDateTime(order.dueDate)),
                if (order.isOverdue) _row(l10n.commonOverdue, l10n.commonOverdueDays(order.daysOverdue)),
              ],
            ),
          ),
        ),
        if (_customerDiaryTarget(order) != null)
          ListTile(
            title: Text(l10n.commonCustomer),
            subtitle: Text(order.customerShopName ?? l10n.commonDiary),
            onTap: () => _openCustomer(order),
            trailing: IconButton(
              icon: const Icon(Icons.notes_outlined),
              tooltip: l10n.commonDiary,
              onPressed: () => _openDiary(order),
            ),
          ),
        if (order.salesPerson != null || order.salesPersonId != null)
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text(l10n.commonSalesperson),
            subtitle: Text(order.salesPerson?.name ?? '#${order.salesPersonId}'),
          ),
        if (order.manualOrderRequests.isNotEmpty) ...[
          const SizedBox(height: 8),
          SectionHeader(title: l10n.salesTitleManualOrders),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: order.manualOrderRequests
                .map((r) => ActionChip(
                      avatar: const Icon(Icons.assignment_outlined, size: 18),
                      label: Text('${l10n.commonManualOrderRequest} #${r.id}'),
                      onPressed: () => context.push('/manual-orders/${r.id}'),
                    ))
                .toList(),
          ),
        ],
        // Order diary — photos, notes, voice and video pinned to this order.
        // Hidden for pending-sync orders: a diary note can't reference an
        // order id the server hasn't issued yet.
        if (order.id > 0 && _customerDiaryTarget(order) != null) ...[
          const SizedBox(height: 8),
          SectionHeader(title: l10n.orderDiaryTitle),
          CustomerDiarySection(
            customerType: _customerDiaryTarget(order)!.$1,
            customerId: _customerDiaryTarget(order)!.$2,
            orderId: order.id,
          ),
        ],
        if (awaitingApproval) ...[
          FilledButton.icon(
            onPressed: _confirmOrder,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Confirm order'),
          ),
          const SizedBox(height: 16),
        ],
        if (pending && due > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(l10n.salesPaymentSyncFirst, style: Theme.of(context).textTheme.bodySmall),
          ),
        if (canEdit && due > 0 && !pending) ...[
          FilledButton.icon(
            onPressed: _collectPayment,
            icon: const Icon(Icons.payments),
            label: Text(l10n.salesOrderCollectPayment),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _requestDiscount,
            icon: const Icon(Icons.percent),
            label: Text(l10n.salesOrderRequestDiscount),
          ),
          const SizedBox(height: 16),
        ],
        Text(l10n.commonItems, style: Theme.of(context).textTheme.titleMedium),
        for (final item in order.items)
          ListTile(
            title: Text(item.product?.name ?? l10n.commonProductFallback(item.productId)),
            subtitle: Text(l10n.commonQtyLine('${item.quantity}')),
            trailing: Text(currency.format(item.bill)),
          ),
        if (order.payments.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l10n.commonPayments, style: Theme.of(context).textTheme.titleMedium),
          for (final p in order.payments)
            ListTile(
              title: Text(p.paymentReference ?? 'Payment #${p.id}'),
              subtitle: Text(
                [
                  if (p.isVoided) l10n.paymentVoidedLabel,
                  if (p.paymentMethod != null) localizedPaymentMethodLabel(context, p.paymentMethod!),
                  if (p.paidAt != null) formatAppDateTime(p.paidAt),
                ].join(' ').trim(),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currency.format(p.amount),
                    style: p.isVoided ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
                  ),
                  if (canEdit && !p.isVoided) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.undo),
                      tooltip: l10n.paymentVoidPayment,
                      onPressed: () => _voidPayment(p),
                    ),
                  ],
                ],
              ),
            ),
        ],
        if (canCancel)
          OutlinedButton.icon(
            onPressed: _cancel,
            icon: const Icon(Icons.cancel_outlined),
            label: Text(l10n.salesOrderCancelOrder),
          ),
        if (!pending) ...[
          const SizedBox(height: 16),
          for (final mod in _mods)
            ListTile(
              title: Text(localizedStatusLabel(context, mod.action)),
              subtitle: Text(mod.notes ?? formatAppDateTime(mod.createdAt)),
            ),
        ],
      ],
    );
  }

  Future<void> _openDiary(OrderModel order) async {
    final target = _customerDiaryTarget(order);
    if (target == null) return;
    await showCustomerDiarySheet(
      context: context,
      ref: ref,
      customerType: target.$1,
      customerId: target.$2,
      customerName: order.customerShopName ?? AppLocalizations.of(context).commonCustomer,
    );
  }

  (String, int)? _customerDiaryTarget(OrderModel order) {
    if (order.customerShopId != null) return ('customer_shop', order.customerShopId!);
    if (order.customerVanId != null) return ('customer_van', order.customerVanId!);
    if (order.customerImporterId != null) return ('customer_importer', order.customerImporterId!);
    return null;
  }

  void _openCustomer(OrderModel order) {
    final target = _customerDiaryTarget(order);
    // Quick-created offline customers carry negative ids until synced.
    if (target == null || target.$2 <= 0) return;
    final segment = switch (target.$1) {
      'customer_shop' => 'shop',
      'customer_van' => 'van',
      _ => 'importer',
    };
    context.push('/customers/$segment/${target.$2}');
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
