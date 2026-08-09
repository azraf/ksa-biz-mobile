import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_client.dart';
import '../config/app_config.dart';
import 'v3_building_blocks.dart';

/// Dashboard banner shown when the server reports a newer APK for this app.
///
/// Reads `app_updates.<appKey>` from `/config/mobile` and compares
/// `latest_build` with the build number injected at release-build time.
/// Renders nothing in debug builds (no build number) or when up to date.
class AppUpdateNotice extends StatefulWidget {
  const AppUpdateNotice({super.key, required this.api});

  final ApiClient api;

  @override
  State<AppUpdateNotice> createState() => _AppUpdateNoticeState();
}

class _AppUpdateNoticeState extends State<AppUpdateNotice> {
  String? _apkUrl;
  int _latestBuild = 0;

  @override
  void initState() {
    super.initState();
    if (AppConfig.buildNumber > 0 && AppConfig.appKey.isNotEmpty) {
      _check();
    }
  }

  Future<void> _check() async {
    try {
      final response = await widget.api.get('/config/mobile');
      final data = response['data'] as Map<String, dynamic>?;
      final updates = data?['app_updates'] as Map<String, dynamic>?;
      final entry = updates?[AppConfig.appKey] as Map<String, dynamic>?;
      if (entry == null) return;
      final latest = entry['latest_build'];
      final latestBuild = latest is int ? latest : int.tryParse('$latest') ?? 0;
      final apkUrl = (entry['apk_url'] as String?)?.trim() ?? '';
      if (latestBuild > AppConfig.buildNumber && apkUrl.isNotEmpty && mounted) {
        setState(() {
          _latestBuild = latestBuild;
          _apkUrl = apkUrl;
        });
      }
    } catch (_) {
      // Best-effort: never disturb the dashboard over a failed update check.
    }
  }

  @override
  Widget build(BuildContext context) {
    final apkUrl = _apkUrl;
    if (apkUrl == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return NoticeCard(
      kind: NoticeKind.info,
      icon: Icons.system_update_alt,
      title: l10n.updateAvailableTitle,
      subtitle: l10n.updateAvailableBody(AppConfig.buildNumber, _latestBuild),
      actionLabel: l10n.updateNow,
      onAction: () => launchUrl(Uri.parse(apkUrl), mode: LaunchMode.externalApplication),
    );
  }
}
