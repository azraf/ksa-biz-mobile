import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import 'router/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/repositories.dart';
import 'providers/screen_providers.dart';
import 'widgets/offline_banner.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeNotifierProvider);
    final sync = ref.watch(syncServiceProvider);
    final auth = ref.watch(authProvider);
    final authRepo = ref.watch(authRepositoryProvider);

    return SyncLifecycle(
      syncService: sync,
      onSyncComplete: () => invalidateAdminScreenProviders(ref),
      child: MaterialApp.router(
        title: 'ARM Admin',
        theme: AppTheme.light(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final l10n = AppLocalizations.of(context);
          return BiometricAppShell(
            auth: auth,
            authRepository: authRepo,
            onAppLocked: () => ref.read(authProvider.notifier).lockApp(),
            onResumed: () => ref.read(authProvider.notifier).refreshBiometricAvailability(),
            onUnlock: (reason) => ref.read(authProvider.notifier).unlockApp(
                  reason,
                  sessionExpiredMessage: l10n.sessionExpired,
                ),
            child: AppRootBuilder(
              offlineBanner: const OfflineBanner(),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
