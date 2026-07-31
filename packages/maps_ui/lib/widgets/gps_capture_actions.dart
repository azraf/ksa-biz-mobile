import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum _GpsMenuAction { clear, replace }

/// GPS capture control: direct capture when empty; menu with clear/replace when set.
class GpsCaptureActions extends StatelessWidget {
  const GpsCaptureActions({
    super.key,
    required this.gps,
    required this.onGpsChanged,
    this.onImmediatePersist,
    this.captureLabel = 'Capture',
    this.locationRequiredMessage = 'Location permission is required for GPS.',
    this.locationServicesMessage = 'Please enable location services.',
  });

  final String? gps;
  final ValueChanged<String?> onGpsChanged;
  final Future<void> Function(String? gps)? onImmediatePersist;
  final String captureLabel;
  final String locationRequiredMessage;
  final String locationServicesMessage;

  bool get _hasValidGps => GpsParser.parseGps(gps) != null;

  Future<String?> _captureCurrentLocation(BuildContext context) async {
    if (!await AppPermissions.requestLocation()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locationRequiredMessage)),
        );
      }
      return null;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locationServicesMessage)),
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
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
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
      message: 'Are you sure you want to replace the saved location with current location?',
    );
    if (!confirmed || !context.mounted) return;
    await _onCapturePressed(context);
  }

  Future<void> _onClearPressed(BuildContext context) async {
    final confirmed = await _confirm(
      context,
      message: 'Are you sure you want to clear the saved location?',
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
    if (!_hasValidGps) {
      return OutlinedButton(
        onPressed: () => _onCapturePressed(context),
        child: Text(captureLabel),
      );
    }

    return IconButton(
      icon: const Icon(Icons.edit_location_alt),
      tooltip: 'GPS options',
      onPressed: () async {
        final action = await showModalBottomSheet<_GpsMenuAction>(
          context: context,
          builder: (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.clear),
                  title: const Text('Clear GPS location'),
                  onTap: () => Navigator.pop(ctx, _GpsMenuAction.clear),
                ),
                ListTile(
                  leading: const Icon(Icons.my_location),
                  title: const Text('Replace with current location'),
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
