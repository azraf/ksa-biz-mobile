import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import 'providers/auth_provider.dart';
import 'providers/repositories.dart';
import 'router/app_router.dart';
import 'widgets/offline_banner.dart';

class AdminApp extends ConsumerWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final auth = ref.watch(authProvider);
    final authRepo = ref.watch(authRepositoryProvider);
    final syncService = ref.watch(syncServiceProvider);

    return SyncLifecycle(
      syncService: syncService,
      onSyncComplete: () {
        ref.invalidate(pendingSyncCountProvider);
        ref.invalidate(failedMediaCountProvider);
        ref.invalidate(lastSyncAtProvider);
      },
      child: MaterialApp.router(
        title: 'ARM admin(M)',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ref.watch(themeModeNotifierProvider),
        locale: ref.watch(localeNotifierProvider),
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
            onUnlock: (reason) => ref.read(authProvider.notifier).unlockApp(
                  reason,
                  sessionExpiredMessage: l10n.sessionExpired,
                ),
            child: AppRootBuilder(
              offlineBanner: const OfflineBanner(),
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
