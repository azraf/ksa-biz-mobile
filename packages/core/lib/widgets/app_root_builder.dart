import 'package:flutter/material.dart';

/// Wraps the app router with top safe-area inset for global status banners.
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
    return Column(
      children: [
        SafeArea(bottom: false, child: offlineBanner),
        Expanded(
          child: child ??
              const Center(
                child: CircularProgressIndicator(),
              ),
        ),
      ],
    );
  }
}
