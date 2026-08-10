import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/customer_context_provider.dart';
import '../../providers/repositories.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    final customer = ref.watch(customerContextProvider);

    return ListView(
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
        if (customer.isLoading)
          ListTile(
            title: Text(l10n.orderProfileCustomer),
            subtitle: Text(l10n.commonLoading),
          )
        else if (customer.error != null)
          ListTile(
            title: Text(l10n.orderProfileCustomer),
            subtitle: Text(l10n.orderContextError),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(customerContextProvider.notifier).load(),
            ),
          )
        else if (customer.profile != null) ...[
          ListTile(
            title: Text(l10n.commonActingAs),
            subtitle: Text(
              '${customer.profile!.displayName}\n${customer.profile!.role.replaceAll('_', ' ')}',
            ),
          ),
          if (customer.profile!.mobile != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ContactActionButtons(phoneNumber: customer.profile!.mobile),
            ),
          if (customer.profile!.shop != null && customer.profile!.shop!.contacts.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(l10n.orderProfileShopContacts, style: Theme.of(context).textTheme.titleSmall),
            ...customer.profile!.shop!.contacts.map(
              (c) => ListTile(
                dense: true,
                title: Text(c.contactName),
                subtitle: Text(c.contactMobile ?? c.contactEmail ?? ''),
              ),
            ),
          ],
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
    );
  }
}
