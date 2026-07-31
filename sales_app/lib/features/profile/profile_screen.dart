import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final actingAs = auth.activeSalesPerson;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(auth.user?.name ?? 'User'),
            subtitle: Text(auth.user?.email ?? ''),
          ),
          if (auth.roles.isNotEmpty) ...[
            const Divider(),
            ListTile(
              title: const Text('Roles'),
              subtitle: Text(auth.roles.join(', ')),
            ),
          ],
          const Divider(),
          if (actingAs != null) ...[
            ListTile(
              title: const Text('Acting as'),
              subtitle: Text('${actingAs.name}\n${actingAs.mobile ?? actingAs.email ?? ''}'),
            ),
            if (actingAs.mobile != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ContactActionButtons(phoneNumber: actingAs.mobile),
              ),
          ] else if (auth.salesPerson != null) ...[
            ListTile(
              title: const Text('Salesperson profile'),
              subtitle: Text('${auth.salesPerson!.name}\n${auth.salesPerson!.mobile ?? ''}'),
            ),
            if (auth.salesPerson!.mobile != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ContactActionButtons(phoneNumber: auth.salesPerson!.mobile),
              ),
          ] else
            const ListTile(
              title: Text('No salesperson selected'),
              subtitle: Text('Choose a salesperson to perform sales tasks.'),
            ),
          if (auth.canPickSalesPerson) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context.push('/select-salesperson'),
              icon: const Icon(Icons.swap_horiz),
              label: Text(actingAs == null ? 'Select salesperson' : 'Change salesperson'),
            ),
          ],
          if (AppConfig.showApiBaseUrlField) ...[
            const Divider(),
            ListTile(
              title: const Text('API URL'),
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
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
