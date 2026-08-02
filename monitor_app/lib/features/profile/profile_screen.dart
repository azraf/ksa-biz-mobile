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
        const LanguagePickerTile(),
        const Divider(),
        BiometricSettingsTile(
          enabled: auth.biometricEnabled,
          available: auth.biometricAvailable,
          tokenExpiresAt: auth.tokenExpiresAt,
          onEnable: (reason) => ref.read(authProvider.notifier).enableBiometricLogin(reason),
          onDisable: () => ref.read(authProvider.notifier).disableBiometricLogin(),
        ),
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
