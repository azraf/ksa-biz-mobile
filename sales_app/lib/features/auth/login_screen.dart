import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: kDebugMode ? 'salesperson@example.com' : '');
  final _passwordController = TextEditingController(text: kDebugMode ? 'password' : '');
  final _apiUrlController = TextEditingController(text: AppConfig.defaultApiBaseUrl);
  bool _showPasswordForm = false;

  @override
  void initState() {
    super.initState();
    // Prefill the remembered email (it survives session expiry on purpose)
    // so the user only has to re-enter their password.
    final storedEmail = ref.read(authRepositoryProvider).storedUserEmail;
    if (storedEmail != null && storedEmail.isNotEmpty) {
      _emailController.text = storedEmail;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoBiometric());
  }

  Future<void> _maybeAutoBiometric() async {
    final auth = ref.read(authProvider);
    if (!auth.pendingBiometricUnlock || auth.storedUserEmail == null) return;
    await _unlockWithBiometric();
  }

  Future<void> _unlockWithBiometric() async {
    final l10n = AppLocalizations.of(context);
    await ref.read(authProvider.notifier).unlockWithBiometric(
          l10n.biometricUnlockReason,
          sessionExpiredMessage: l10n.sessionExpired,
        );
  }

  /// True when it is safe to proceed with the login. Logging in as a
  /// different user than the device's last one wipes that user's offline
  /// data (the repository saves a recovery snapshot first), so when unsynced
  /// records are still queued the user must confirm before the login runs.
  Future<bool> _confirmUserSwitchIfNeeded(String email) async {
    if (email.isEmpty) return true;
    final repo = ref.read(authRepositoryProvider);
    final db = ref.read(localDatabaseProvider);
    if (await db.getLastUserId() == null) return true;

    // The entered identifier matching the last user's is the only way to know
    // pre-login that no switch is happening; otherwise stay cautious.
    final lastEmail = repo.storedUserEmail;
    if (lastEmail != null && email.toLowerCase() == lastEmail.toLowerCase()) {
      return true;
    }

    final pending = await db.pendingCount() + await db.pendingMediaCount();
    if (pending <= 0) return true;
    if (!mounted) return false;

    final l10n = AppLocalizations.of(context);
    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.authSwitchUserTitle),
        content: Text(l10n.authSwitchUserBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonContinue),
          ),
        ],
      ),
    );
    return proceed == true;
  }

  Future<void> _signIn() async {
    final notifier = ref.read(authProvider.notifier);
    final email = _emailController.text.trim();

    if (!await _confirmUserSwitchIfNeeded(email)) return;
    if (!mounted) return;

    await notifier.login(
      email: email,
      password: _passwordController.text,
      apiBaseUrl: AppConfig.showApiBaseUrlField ? _apiUrlController.text.trim() : null,
    );

    if (!mounted) return;
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated || auth.error != null) return;

    final biometricAvailable = await ref.read(biometricAuthServiceProvider).canCheckBiometrics();
    if (!mounted) return;
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
    // No !auth.isLoading here: unlockWithBiometric() sets isLoading before
    // the native prompt opens, and hiding this section then would flash the
    // password form underneath the OS biometric dialog. BiometricLoginSection
    // handles the busy state itself.
    final showBiometricOnly = auth.pendingBiometricUnlock &&
        auth.storedUserEmail != null &&
        !_showPasswordForm;

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
                  LoginHero(
                    icon: Icons.storefront_outlined,
                    title: l10n.salesAppName,
                    subtitle: l10n.salesSignInSubtitle,
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
                        decoration: InputDecoration(labelText: l10n.commonApiBaseUrl),
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: l10n.authEmailOrPhone),
                    ),
                    const SizedBox(height: 12),
                    PasswordTextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: l10n.commonPassword),
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
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
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
