import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import 'offline_help_screen.dart';

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
          Text(l10n.salesQuickLinks, style: Theme.of(context).textTheme.titleSmall),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: Text(l10n.salesCardCustomers),
            onTap: () => context.push('/customers'),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: Text(l10n.salesCardWatchlist),
            onTap: () => context.push('/watchlist'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.salesNotifications),
            onTap: () => context.push('/notifications'),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_off_outlined),
            title: Text(l10n.salesOfflineHelpTitle),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const OfflineHelpScreen()),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.salesDarkMode),
            value: ref.watch(themeModeNotifierProvider) == ThemeMode.dark,
            onChanged: (v) => ref.read(themeModeNotifierProvider.notifier).setDark(v),
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
            error: (_, __) => const SizedBox.shrink(),
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
