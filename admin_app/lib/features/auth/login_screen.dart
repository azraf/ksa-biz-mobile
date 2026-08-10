import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: kDebugMode ? 'admin@example.com' : '');
  final _passwordController = TextEditingController(text: kDebugMode ? 'password' : '');
  final _apiUrlController = TextEditingController(text: AppConfig.defaultApiBaseUrl);
  bool _showPasswordForm = false;
  bool _autoBiometricAttempted = false;

  Future<void> _unlockWithBiometric() async {
    final l10n = AppLocalizations.of(context);
    await ref.read(authProvider.notifier).unlockWithBiometric(
          l10n.biometricUnlockReason,
          sessionExpiredMessage: l10n.sessionExpired,
        );
  }

  Future<void> _signIn() async {
    final notifier = ref.read(authProvider.notifier);
    await notifier.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      apiBaseUrl: AppConfig.showApiBaseUrlField ? _apiUrlController.text.trim() : null,
    );

    if (!mounted) return;
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated || auth.error != null) return;

    final biometricAvailable = await ref.read(biometricAuthServiceProvider).canCheckBiometrics();
    if (!biometricAvailable || auth.biometricEnabled) return;

    final enable = await showBiometricOptInDialog(context);
    if (enable == true && mounted) {
      final l10n = AppLocalizations.of(context);
      await notifier.enableBiometricLogin(l10n.biometricEnableReason);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _apiUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    // Session restore on cold start is async (secure-storage/prefs reads);
    // the initial state always has pendingBiometricUnlock: false, so this
    // must react to the state settling rather than check it once at launch.
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (_autoBiometricAttempted || next.isLoading) return;
      if (next.pendingBiometricUnlock && next.storedUserEmail != null) {
        _autoBiometricAttempted = true;
        _unlockWithBiometric();
      }
    });
    final showBiometricOnly = auth.pendingBiometricUnlock &&
        auth.storedUserEmail != null &&
        !_showPasswordForm &&
        !auth.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHero(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'ARM admin(M)',
                    subtitle: 'Admin-only access. Offline mode supported for orders & expenses.',
                  ),
                  if (showBiometricOnly)
                    BiometricLoginSection(
                      email: auth.storedUserEmail!,
                      isLoading: auth.isLoading,
                      onBiometricLogin: _unlockWithBiometric,
                      onUsePassword: () => setState(() => _showPasswordForm = true),
                    )
                  else ...[
                    if (AppConfig.showApiBaseUrlField) ...[
                      TextField(
                        controller: _apiUrlController,
                        decoration: const InputDecoration(labelText: 'API base URL'),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email or phone'),
                    ),
                    const SizedBox(height: 12),
                    PasswordTextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                  ],
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    NoticeCard(
                      kind: NoticeKind.danger,
                      icon: Icons.error_outline,
                      title: auth.error!,
                      margin: EdgeInsets.zero,
                    ),
                  ],
                  if (!showBiometricOnly) ...[
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: auth.isLoading ? null : _signIn,
                      child: auth.isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(l10n.commonSignIn),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
