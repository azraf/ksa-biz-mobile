import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:screenshot/screenshot.dart';

import 'printer_settings.dart';

/// Renders a widget to an image and prints it as an ESC/POS raster over
/// Bluetooth. Raster-only on purpose: Arabic/RTL via printer codepages is a
/// lottery across cheap thermal printers; an image always prints right.
class InvoicePrinter {
  const InvoicePrinter();

  /// Widget → PNG bytes at the printer's dot width (also used for sharing).
  Future<Uint8List> renderWidget(
    Widget receipt, {
    required double widthDots,
    BuildContext? context,
    double pixelRatio = 1.0,
  }) {
    return ScreenshotController().captureFromWidget(
      receipt,
      delay: const Duration(milliseconds: 150),
      pixelRatio: pixelRatio,
      context: context,
      targetSize: null,
    );
  }

  /// Print PNG bytes to the saved printer. Throws [PrinterException] with a
  /// human message on every failure path.
  Future<void> printImage(Uint8List pngBytes, PrinterSettings settings) async {
    if (!settings.isConfigured) {
      throw const PrinterException('No printer configured. Set one up in Printer Settings.');
    }
    // Android 12+: BLUETOOTH_CONNECT is a runtime permission.
    final permission = await Permission.bluetoothConnect.request();
    if (permission.isPermanentlyDenied) {
      throw const PrinterException('Bluetooth permission denied. Allow it in app settings.');
    }
    if (!await PrintBluetoothThermal.bluetoothEnabled) {
      throw const PrinterException('Bluetooth is off. Turn it on and try again.');
    }

    final connected = await PrintBluetoothThermal.connectionStatus;
    if (!connected) {
      final ok = await PrintBluetoothThermal.connect(macPrinterAddress: settings.mac!);
      if (!ok) {
        throw PrinterException(
          'Could not connect to ${settings.name ?? settings.mac}. '
          'Make sure the printer is on and paired.',
        );
      }
    }

    final decoded = img.decodeImage(pngBytes);
    if (decoded == null) {
      throw const PrinterException('Could not render the invoice image.');
    }

    // Fit to paper width; grayscale so the raster threshold is clean.
    final resized = decoded.width == settings.dotsWidth
        ? decoded
        : img.copyResize(decoded, width: settings.dotsWidth);
    final grayscale = img.grayscale(resized);

    final profile = await CapabilityProfile.load();
    final generator = Generator(
      settings.paperWidthMm >= 80 ? PaperSize.mm80 : PaperSize.mm58,
      profile,
    );

    final bytes = <int>[
      ...generator.reset(),
      ...generator.imageRaster(grayscale),
      ...generator.feed(3),
    ];

    // Chunked writes: long buffers overrun small printer buffers.
    const chunkSize = 512;
    for (var i = 0; i < bytes.length; i += chunkSize) {
      final chunk = bytes.sublist(i, i + chunkSize > bytes.length ? bytes.length : i + chunkSize);
      final ok = await PrintBluetoothThermal.writeBytes(chunk);
      if (!ok) {
        throw const PrinterException('Printing failed mid-way. Check the printer and retry.');
      }
    }
  }
}

class PrinterException implements Exception {
  const PrinterException(this.message);

  final String message;

  @override
  String toString() => message;
}
