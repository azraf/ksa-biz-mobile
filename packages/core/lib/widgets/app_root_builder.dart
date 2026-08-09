import 'package:flutter/material.dart';

/// Wraps the app router with top safe-area inset for global status banners.
///
/// The SafeArea strip physically backs the status bar, so the router subtree
/// below it must NOT re-apply the top inset (every AppBar would otherwise sit
/// a full status-bar height too low — a dead strip on every screen).
class AppRootBuilder extends StatelessWidget {
  const AppRootBuilder({
    super.key,
    required this.offlineBanner,
    required this.child,
  });

  final Widget offlineBanner;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
      child: Column(
        children: [
          SafeArea(bottom: false, child: offlineBanner),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: child ??
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
