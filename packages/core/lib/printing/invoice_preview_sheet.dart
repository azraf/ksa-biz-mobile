import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../models/order.dart';
import '../models/zatca_config.dart';
import 'invoice_printer.dart';
import 'invoice_receipt_widget.dart';
import 'printer_settings.dart';

/// Preview bottom sheet: shows the rendered receipt with Print and Share
/// actions. [onPrinted] fires after a successful physical print (used to bump
/// the server-side print count that drives the COPY label).
Future<void> showInvoicePreviewSheet(
  BuildContext context,
  WidgetRef ref, {
  required OrderModel order,
  required ZatcaConfig config,
  Future<void> Function()? onPrinted,
  VoidCallback? onOpenPrinterSettings,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) => _InvoicePreviewSheet(
      order: order,
      config: config,
      settings: ref.read(printerSettingsProvider),
      onPrinted: onPrinted,
      onOpenPrinterSettings: onOpenPrinterSettings,
    ),
  );
}

class _InvoicePreviewSheet extends StatefulWidget {
  const _InvoicePreviewSheet({
    required this.order,
    required this.config,
    required this.settings,
    this.onPrinted,
    this.onOpenPrinterSettings,
  });

  final OrderModel order;
  final ZatcaConfig config;
  final PrinterSettings settings;
  final Future<void> Function()? onPrinted;
  final VoidCallback? onOpenPrinterSettings;

  @override
  State<_InvoicePreviewSheet> createState() => _InvoicePreviewSheetState();
}

class _InvoicePreviewSheetState extends State<_InvoicePreviewSheet> {
  static const _printer = InvoicePrinter();

  bool _busy = false;

  Widget _receipt() => InvoiceReceiptWidget(
        order: widget.order,
        config: widget.config,
        widthDots: widget.settings.dotsWidth.toDouble(),
        isCopy: (widget.order.zatca?.printCount ?? 0) > 0,
      );

  Future<Uint8List> _render(BuildContext context) => _printer.renderWidget(
        _receipt(),
        widthDots: widget.settings.dotsWidth.toDouble(),
        context: context,
        // Share looks better at 2x; the printer resizes back down anyway.
        pixelRatio: 2.0,
      );

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } on PrinterException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast('Failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _print() => _run(() async {
        if (!widget.settings.isConfigured) {
          _toast('No printer configured.');
          widget.onOpenPrinterSettings?.call();
          return;
        }
        final png = await _render(context);
        await _printer.printImage(png, widget.settings);
        await widget.onPrinted?.call();
        _toast('Invoice sent to printer.');
      });

  Future<void> _share() => _run(() async {
        final png = await _render(context);
        final name = widget.order.invoiceNumber ?? 'order-${widget.order.id}';
        await Share.shareXFiles(
          [XFile.fromData(png, name: 'invoice-$name.png', mimeType: 'image/png')],
          text: 'Invoice $name',
        );
      });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _receipt(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _print,
                      icon: _busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.print_outlined),
                      label: const Text('Print'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _busy ? null : _share,
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
