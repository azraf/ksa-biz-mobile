import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

class BiometricSettingsTile extends ConsumerWidget {
  const BiometricSettingsTile({
    super.key,
    required this.enabled,
    required this.available,
    required this.onEnable,
    required this.onDisable,
    this.tokenExpiresAt,
  });

  final bool enabled;
  final bool available;
  final Future<bool> Function(String reason) onEnable;
  final Future<void> Function() onDisable;
  final DateTime? tokenExpiresAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!available) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.fingerprint),
          title: Text(l10n.biometricEnableTitle),
          subtitle: Text(l10n.biometricEnableSubtitle),
          value: enabled,
          onChanged: (value) async {
            if (value) {
              final ok = await onEnable(l10n.biometricEnableReason);
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.biometricNotAvailable)),
                );
              }
            } else {
              await onDisable();
            }
          },
        ),
        if (tokenExpiresAt != null)
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(l10n.tokenExpiresAtTitle),
            subtitle: Text(l10n.tokenExpiresAtValue(tokenExpiresAt!.toLocal().toString().split('.').first)),
          ),
      ],
    );
  }
}

class BiometricLoginSection extends StatelessWidget {
  const BiometricLoginSection({
    super.key,
    required this.email,
    required this.isLoading,
    required this.onBiometricLogin,
    required this.onUsePassword,
  });

  final String email;
  final bool isLoading;
  final VoidCallback onBiometricLogin;
  final VoidCallback onUsePassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.biometricSignInAs(email), style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: isLoading ? null : onBiometricLogin,
          icon: const Icon(Icons.fingerprint),
          label: Text(l10n.biometricUnlockButton),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: isLoading ? null : onUsePassword,
          child: Text(l10n.biometricUsePassword),
        ),
      ],
    );
  }
}

Future<bool?> showBiometricOptInDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.biometricEnableTitle),
      content: Text(l10n.biometricOptInMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.commonSkip),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.commonEnable),
        ),
      ],
    ),
  );
}
