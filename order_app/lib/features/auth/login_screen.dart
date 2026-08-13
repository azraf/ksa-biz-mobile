import 'package:core/core.dart';
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
  final _emailController = TextEditingController(text: 'customer_shop@example.com');
  final _passwordController = TextEditingController(text: 'password');
  final _apiUrlController = TextEditingController(text: AppConfig.defaultApiBaseUrl);
  bool _showPasswordForm = false;

  @override
  void initState() {
    super.initState();
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
                    icon: Icons.shopping_bag_outlined,
                    title: l10n.orderAppName,
                    subtitle: l10n.orderSignInSubtitle,
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
                      decoration: const InputDecoration(labelText: 'Email or phone'),
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
