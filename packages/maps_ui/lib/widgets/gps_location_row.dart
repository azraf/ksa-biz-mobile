import 'package:core/core.dart';
import 'package:flutter/material.dart';

class GpsLocationRow extends StatelessWidget {
  const GpsLocationRow({
    super.key,
    required this.gps,
    this.title = 'GPS',
    this.notCapturedLabel = 'Not captured',
    this.trailing,
  });

  final String? gps;
  final String title;
  final String notCapturedLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(gps ?? notCapturedLabel),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OpenInMapsButton(gps: gps),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
