import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';

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
