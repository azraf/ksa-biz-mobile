import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final actingAs = auth.activeSalesPerson;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.salesProfile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(auth.user?.name ?? l10n.commonUser),
            subtitle: Text(auth.user?.email ?? ''),
          ),
          if (auth.roles.isNotEmpty) ...[
            const Divider(),
            ListTile(
              title: Text(l10n.commonRoles),
              subtitle: Text(auth.roles.join(', ')),
            ),
          ],
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
          if (actingAs != null) ...[
            ListTile(
              title: Text(l10n.commonActingAs),
              subtitle: Text('${actingAs.name}\n${actingAs.mobile ?? actingAs.email ?? ''}'),
            ),
            if (actingAs.mobile != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ContactActionButtons(phoneNumber: actingAs.mobile),
              ),
          ] else if (auth.salesPerson != null) ...[
            ListTile(
              title: Text(l10n.salesSalespersonProfile),
              subtitle: Text('${auth.salesPerson!.name}\n${auth.salesPerson!.mobile ?? ''}'),
            ),
            if (auth.salesPerson!.mobile != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ContactActionButtons(phoneNumber: auth.salesPerson!.mobile),
              ),
          ] else
            ListTile(
              title: Text(l10n.salesNoSalespersonSelected),
              subtitle: Text(l10n.salesChooseSalespersonHint),
            ),
          if (auth.canPickSalesPerson) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push('/select-salesperson'),
              icon: const Icon(Icons.swap_horiz),
              label: Text(actingAs == null ? l10n.salesSelectSalespersonBtn : l10n.salesChangeSalespersonBtn),
            ),
          ],
          if (AppConfig.showApiBaseUrlField) ...[
            const Divider(),
            ListTile(
              title: Text(l10n.commonApiUrl),
              subtitle: Text(auth.apiBaseUrl ?? AppConfig.defaultApiBaseUrl),
            ),
          ],
          if (kDebugMode) ...[
            const Divider(),
            ListTile(
              title: const Text('Isar benchmarks'),
              subtitle: const Text('Debug only — logs timings to console'),
              trailing: const Icon(Icons.speed),
              onTap: () async {
                final stores = ref.read(offlineStoresProvider);
                final results = await IsarBenchmarks.runAll(stores);
                if (!context.mounted) return;
                final text = results.map((r) => r.toString()).join('\n');
                debugPrint('Isar benchmarks:\n$text');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(text)),
                );
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sync_problem),
            title: const Text('Sync issues'),
            subtitle: const Text('Review failed or stuck offline uploads'),
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
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
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
