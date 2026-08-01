import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

typedef BiometricUnlockCallback = Future<bool> Function(String reason);
typedef AppLockedPredicate = bool Function();

class BiometricUnlockGate extends ConsumerStatefulWidget {
  const BiometricUnlockGate({
    super.key,
    required this.child,
    required this.isAppLocked,
    required this.biometricEnabled,
    required this.isAuthenticated,
    required this.onUnlock,
    this.unlockReason,
  });

  final Widget child;
  final bool isAppLocked;
  final bool biometricEnabled;
  final bool isAuthenticated;
  final BiometricUnlockCallback onUnlock;
  final String? unlockReason;

  @override
  ConsumerState<BiometricUnlockGate> createState() => _BiometricUnlockGateState();
}

class _BiometricUnlockGateState extends ConsumerState<BiometricUnlockGate>
    with WidgetsBindingObserver {
  bool _unlocking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _shouldShowLock) {
      _attemptUnlock();
    }
  }

  bool get _shouldShowLock =>
      widget.isAuthenticated && widget.biometricEnabled && widget.isAppLocked;

  Future<void> _attemptUnlock() async {
    if (_unlocking || !_shouldShowLock) return;
    setState(() => _unlocking = true);
    final l10n = AppLocalizations.of(context);
    final reason = widget.unlockReason ?? l10n.biometricUnlockReason;
    await widget.onUnlock(reason);
    if (mounted) setState(() => _unlocking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShowLock) return widget.child;

    final l10n = AppLocalizations.of(context);
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fingerprint, size: 64, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text(l10n.biometricAppLockedTitle, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(l10n.biometricAppLockedSubtitle, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _unlocking ? null : _attemptUnlock,
                      icon: _unlocking
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.fingerprint),
                      label: Text(l10n.biometricUnlockButton),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BiometricLifecycleObserver extends WidgetsBindingObserver {
  BiometricLifecycleObserver({
    required this.onResumed,
    required this.onPaused,
  });

  final VoidCallback onResumed;
  final VoidCallback onPaused;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) onPaused();
    if (state == AppLifecycleState.resumed) onResumed();
  }
}
