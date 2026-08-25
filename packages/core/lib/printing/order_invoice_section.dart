import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../models/order.dart';
import '../models/zatca_config.dart';
import '../repositories/order_repository.dart';
import '../providers/shared_preferences_provider.dart';
import 'invoice_preview_sheet.dart';
import 'zatca_config_provider.dart';

/// Order-detail block for the e-invoice: Generate Invoice (when ZATCA is on
/// and none exists yet), then Print / Share via the preview sheet. Shared by
/// admin_app and sales_app.
class OrderInvoiceSection extends ConsumerStatefulWidget {
  const OrderInvoiceSection({
    super.key,
    required this.order,
    required this.repository,
    required this.api,
    required this.isOnline,
    this.onChanged,
    this.onOpenPrinterSettings,
  });

  final OrderModel order;
  final OrderRepository repository;
  final ApiClient api;
  final bool isOnline;

  /// Called after the invoice was generated (reload the order).
  final Future<void> Function()? onChanged;
  final VoidCallback? onOpenPrinterSettings;

  @override
  ConsumerState<OrderInvoiceSection> createState() => _OrderInvoiceSectionState();
}

class _OrderInvoiceSectionState extends ConsumerState<OrderInvoiceSection> {
  ZatcaConfig? _config;
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await loadZatcaConfig(ref.read(sharedPreferencesProvider), widget.api);
    if (mounted) setState(() => _config = config);
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _generate() async {
    setState(() => _generating = true);
    try {
      await widget.repository.generateZatcaInvoice(widget.order.id);
      _toast('Invoice generated.');
      await widget.onChanged?.call();
    } catch (e) {
      _toast('Could not generate invoice: $e');
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _openPreview() async {
    final config = _config ?? const ZatcaConfig();
    await showInvoicePreviewSheet(
      context,
      ref,
      order: widget.order,
      config: config,
      onOpenPrinterSettings: widget.onOpenPrinterSettings,
      onPrinted: () async {
        // The print counter drives the COPY label on reprints. Best-effort:
        // an offline print just doesn't bump it.
        if (widget.isOnline && (widget.order.zatca?.invoiceGenerated ?? false)) {
          try {
            await widget.repository.markZatcaInvoicePrinted(widget.order.id);
            await widget.onChanged?.call();
          } catch (_) {}
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    if (config == null) return const SizedBox.shrink();

    final order = widget.order;
    final zatca = order.zatca;
    final hasInvoice = zatca?.invoiceGenerated ?? false;
    final isServerOrder = order.id > 0;
    // ZATCA on but not yet invoiced: only Generate is offered — the printed
    // invoice must carry the server-issued QR/ICV.
    final needsGeneration = config.enabled && !hasInvoice;
    final canPrint = !config.enabled || hasInvoice;
    final theme = Theme.of(context);

    if (order.isCancelled || order.isDraft) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long_outlined, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Invoice', style: theme.textTheme.titleSmall),
                const Spacer(),
                if (hasInvoice)
                  Text(
                    'ICV ${zatca!.icv} · printed ${zatca.printCount}×',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (needsGeneration) ...[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _generating || !widget.isOnline || !isServerOrder ? null : _generate,
                      icon: _generating
                          ? const SizedBox(
                              width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.receipt_long),
                      label: const Text('Generate Invoice'),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: canPrint ? _openPreview : null,
                      icon: const Icon(Icons.print_outlined),
                      label: Text(canPrint && (zatca?.printCount ?? 0) > 0 ? 'Reprint' : 'Print / Share'),
                    ),
                  ),
                ],
              ],
            ),
            if (needsGeneration && !widget.isOnline)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Go online to generate the e-invoice.',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                ),
              ),
            if (needsGeneration && !isServerOrder)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Order not synced yet — sync first, then generate.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
