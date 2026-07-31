import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/customer_context_provider.dart';

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
        const LanguagePickerTile(),
        const Divider(),
        if (customer.isLoading)
          ListTile(
            title: Text(l10n.orderProfileCustomer),
            subtitle: Text(l10n.commonLoading),
          )
        else if (customer.error != null)
          ListTile(
            title: Text(l10n.orderProfileCustomer),
            subtitle: Text(customer.error!),
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
