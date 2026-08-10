import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminProfileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(auth.user?.name ?? l10n.commonUser),
            subtitle: Text(auth.user?.email ?? ''),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sync_problem_outlined),
            title: Text(l10n.salesSyncIssuesTitle),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => SyncStatusScreen(
                    syncService: ref.read(syncServiceProvider),
                    loadItems: () => ref.read(syncServiceProvider).actionableItems(),
                  ),
                ),
              );
            },
          ),
          ref.watch(lastSyncAtProvider).when(
            data: (at) => at == null
                ? const SizedBox.shrink()
                : ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(l10n.salesLastSyncedAt(formatFetchedAt(at.toIso8601String()))),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const Divider(),
          const LanguagePickerTile(),
          const Divider(),
          BiometricSettingsTile(
            enabled: auth.biometricEnabled,
            available: auth.biometricAvailable,
            tokenExpiresAt: auth.tokenExpiresAt,
            onEnable: (reason) => ref.read(authProvider.notifier).enableBiometricLogin(reason),
            onDisable: () => ref.read(authProvider.notifier).disableBiometricLogin(),
          ),
          const Divider(),
          FilledButton.icon(
            onPressed: () async {
              if (!await confirmLogoutWithPendingData(context, ref.read(syncServiceProvider))) {
                return;
              }
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            label: Text(l10n.commonSignOut),
          ),
        ],
      ),
    );
  }
}
