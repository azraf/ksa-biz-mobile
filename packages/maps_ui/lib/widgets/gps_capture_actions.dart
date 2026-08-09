import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:l10n/l10n.dart';

enum _GpsMenuAction { clear, replace }

/// Best-effort GPS capture with no UI: returns "lat,lng" or null.
/// Never prompts beyond the OS permission dialog; safe to call on sheet open.
Future<String?> captureGpsSilently() async {
  try {
    if (!await AppPermissions.requestLocation()) return null;
    if (!await Geolocator.isLocationServiceEnabled()) return null;
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    return '${position.latitude},${position.longitude}';
  } catch (_) {
    return null;
  }
}

/// GPS capture control: direct capture when empty; menu with clear/replace when set.
class GpsCaptureActions extends StatelessWidget {
  const GpsCaptureActions({
    super.key,
    required this.gps,
    required this.onGpsChanged,
    this.onImmediatePersist,
    this.captureLabel,
    this.locationRequiredMessage,
    this.locationServicesMessage,
  });

  final String? gps;
  final ValueChanged<String?> onGpsChanged;
  final Future<void> Function(String? gps)? onImmediatePersist;
  final String? captureLabel;
  final String? locationRequiredMessage;
  final String? locationServicesMessage;

  bool get _hasValidGps => GpsParser.parseGps(gps) != null;

  Future<String?> _captureCurrentLocation(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (!await AppPermissions.requestLocation()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locationRequiredMessage ?? l10n.gpsPermissionRequired)),
        );
      }
      return null;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locationServicesMessage ?? l10n.gpsEnableServices)),
        );
      }
      return null;
    }
    final position = await Geolocator.getCurrentPosition();
    return '${position.latitude},${position.longitude}';
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String message,
  }) async {
    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _applyGps(BuildContext context, String? value) async {
    onGpsChanged(value);
    await onImmediatePersist?.call(value);
  }

  Future<void> _onCapturePressed(BuildContext context) async {
    final captured = await _captureCurrentLocation(context);
    if (captured == null || !context.mounted) return;
    await _applyGps(context, captured);
  }

  Future<void> _onReplacePressed(BuildContext context) async {
    final confirmed = await _confirm(
      context,
      message: AppLocalizations.of(context).gpsReplaceConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await _onCapturePressed(context);
  }

  Future<void> _onClearPressed(BuildContext context) async {
    final confirmed = await _confirm(
      context,
      message: AppLocalizations.of(context).gpsClearConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await _applyGps(context, null);
  }

  Future<void> _onMenuSelected(BuildContext context, _GpsMenuAction action) async {
    switch (action) {
      case _GpsMenuAction.clear:
        await _onClearPressed(context);
      case _GpsMenuAction.replace:
        await _onReplacePressed(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!_hasValidGps) {
      return OutlinedButton(
        onPressed: () => _onCapturePressed(context),
        child: Text(captureLabel ?? l10n.gpsCapture),
      );
    }

    return IconButton(
      icon: const Icon(Icons.edit_location_alt),
      tooltip: l10n.gpsOptionsTooltip,
      onPressed: () async {
        final action = await showModalBottomSheet<_GpsMenuAction>(
          context: context,
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.clear),
                  title: Text(l10n.gpsClear),
                  onTap: () => Navigator.pop(ctx, _GpsMenuAction.clear),
                ),
                ListTile(
                  leading: const Icon(Icons.my_location),
                  title: Text(l10n.gpsReplace),
                  onTap: () => Navigator.pop(ctx, _GpsMenuAction.replace),
                ),
              ],
            ),
          ),
        );
        if (action != null && context.mounted) {
          await _onMenuSelected(context, action);
        }
      },
    );
  }
}
