import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../providers/customer_context_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final customer = ref.watch(customerContextProvider);

    return ListView(
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
        if (customer.isLoading)
          const ListTile(
            title: Text('Customer profile'),
            subtitle: Text('Loading...'),
          )
        else if (customer.error != null)
          ListTile(
            title: const Text('Customer profile'),
            subtitle: Text(customer.error!),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.read(customerContextProvider.notifier).load(),
            ),
          )
        else if (customer.profile != null) ...[
          ListTile(
            title: const Text('Acting as'),
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
            Text('Shop contacts', style: Theme.of(context).textTheme.titleSmall),
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
    );
  }
}
