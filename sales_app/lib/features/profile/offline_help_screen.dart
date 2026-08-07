import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

class OfflineHelpScreen extends StatelessWidget {
  const OfflineHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.salesOfflineHelpTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_done_outlined),
            title: Text(l10n.salesOfflineHelpWorks),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.cloud_off_outlined),
            title: Text(l10n.salesOfflineHelpNeedsInternet),
          ),
        ],
      ),
    );
  }
}
