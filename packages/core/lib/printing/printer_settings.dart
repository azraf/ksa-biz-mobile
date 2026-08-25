import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared_preferences_provider.dart';

/// The remembered Bluetooth printer for this device: MAC, display name and
/// paper width (58mm → 384 dots, 80mm → 576 dots at 203 dpi).
class PrinterSettings {
  const PrinterSettings({this.mac, this.name, this.paperWidthMm = 58});

  final String? mac;
  final String? name;
  final int paperWidthMm;

  bool get isConfigured => mac != null && mac!.isNotEmpty;

  /// Printable dot width for ESC/POS raster output.
  int get dotsWidth => paperWidthMm >= 80 ? 576 : 384;

  PrinterSettings copyWith({String? mac, String? name, int? paperWidthMm}) =>
      PrinterSettings(
        mac: mac ?? this.mac,
        name: name ?? this.name,
        paperWidthMm: paperWidthMm ?? this.paperWidthMm,
      );
}

class PrinterSettingsNotifier extends Notifier<PrinterSettings> {
  static const _macKey = 'printer_mac';
  static const _nameKey = 'printer_name';
  static const _widthKey = 'printer_paper_width';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  PrinterSettings build() {
    final prefs = _prefs;
    return PrinterSettings(
      mac: prefs.getString(_macKey),
      name: prefs.getString(_nameKey),
      paperWidthMm: prefs.getInt(_widthKey) ?? 58,
    );
  }

  Future<void> saveDevice(String mac, String name) async {
    await _prefs.setString(_macKey, mac);
    await _prefs.setString(_nameKey, name);
    state = state.copyWith(mac: mac, name: name);
  }

  Future<void> savePaperWidth(int mm) async {
    await _prefs.setInt(_widthKey, mm);
    state = state.copyWith(paperWidthMm: mm);
  }

  Future<void> clearDevice() async {
    await _prefs.remove(_macKey);
    await _prefs.remove(_nameKey);
    state = PrinterSettings(paperWidthMm: state.paperWidthMm);
  }
}

final printerSettingsProvider =
    NotifierProvider<PrinterSettingsNotifier, PrinterSettings>(
  PrinterSettingsNotifier.new,
);
