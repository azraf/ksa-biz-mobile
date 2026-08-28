import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import 'invoice_printer.dart';
import 'printer_settings.dart';

/// Pick a paired Bluetooth thermal printer, choose the paper width, and run a
/// test print. Pairing itself happens in the phone's Bluetooth settings —
/// classic SPP printers can't be paired from inside the app.
class PrinterSetupScreen extends ConsumerStatefulWidget {
  const PrinterSetupScreen({super.key});

  @override
  ConsumerState<PrinterSetupScreen> createState() => _PrinterSetupScreenState();
}

class _PrinterSetupScreenState extends ConsumerState<PrinterSetupScreen> {
  List<BluetoothInfo> _devices = const [];
  bool _loading = false;
  bool _testing = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    setState(() => _loading = true);
    try {
      await [Permission.bluetoothConnect, Permission.bluetoothScan].request();
      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!enabled) {
        _toast('Bluetooth is off. Turn it on to list paired printers.');
        setState(() => _devices = const []);
        return;
      }
      final devices = await PrintBluetoothThermal.pairedBluetooths;
      setState(() => _devices = devices);
    } catch (e) {
      _toast('Could not list Bluetooth devices: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _testPrint() async {
    final settings = ref.read(printerSettingsProvider);
    if (!settings.isConfigured) {
      _toast('Select a printer first.');
      return;
    }
    setState(() => _testing = true);
    try {
      const printer = InvoicePrinter();
      final png = await printer.renderWidget(
        _TestReceipt(widthDots: settings.dotsWidth.toDouble()),
        widthDots: settings.dotsWidth.toDouble(),
      );
      await printer.printImage(png, settings);
      _toast('Test print sent.');
    } on PrinterException catch (e) {
      _toast(e.message);
    } catch (e) {
      _toast('Test print failed: $e');
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(printerSettingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Settings'),
        actions: [
          IconButton(
            onPressed: _loading ? null : _loadDevices,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload paired devices',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (settings.isConfigured)
            Card(
              child: ListTile(
                leading: Icon(Icons.print, color: theme.colorScheme.primary),
                title: Text(settings.name ?? settings.mac!),
                subtitle: Text('${settings.mac} · ${settings.paperWidthMm}mm paper'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Forget printer',
                  onPressed: () => ref.read(printerSettingsProvider.notifier).clearDevice(),
                ),
              ),
            )
          else
            Card(
              child: ListTile(
                leading: Icon(Icons.info_outline, color: theme.colorScheme.tertiary),
                title: const Text('No printer selected'),
                subtitle: const Text(
                  'Pair the printer in the phone\'s Bluetooth settings first, then pick it below.',
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text('Paper width', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 58, label: Text('58 mm')),
              ButtonSegment(value: 80, label: Text('80 mm')),
            ],
            selected: {settings.paperWidthMm},
            onSelectionChanged: (selection) =>
                ref.read(printerSettingsProvider.notifier).savePaperWidth(selection.first),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _testing ? null : _testPrint,
            icon: _testing
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.print_outlined),
            label: const Text('Test print'),
          ),
          const SizedBox(height: 24),
          Text('Paired Bluetooth devices', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          if (_loading)
            const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
          else if (_devices.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No paired devices found. Pair the printer in Bluetooth settings, then reload.'),
            )
          else
            for (final device in _devices)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(device.name.isEmpty ? device.macAdress : device.name),
                  subtitle: Text(device.macAdress),
                  trailing: settings.mac == device.macAdress
                      ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                      : null,
                  onTap: () => ref
                      .read(printerSettingsProvider.notifier)
                      .saveDevice(device.macAdress, device.name),
                ),
              ),
        ],
      ),
    );
  }
}

/// Small fixed test slip — proves connection, width and Arabic rendering.
class _TestReceipt extends StatelessWidget {
  const _TestReceipt({required this.widthDots});

  final double widthDots;

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF000000);
    return Container(
      width: widthDots,
      color: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.all(12),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('KSA Biz — Test Print',
              style: TextStyle(color: black, fontSize: 24, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('اختبار الطباعة بالعربية',
              textDirection: TextDirection.rtl,
              style: TextStyle(color: black, fontSize: 24)),
          SizedBox(height: 8),
          Text('0123456789 SAR 99.99', style: TextStyle(color: black, fontSize: 20)),
        ],
      ),
    );
  }
}
