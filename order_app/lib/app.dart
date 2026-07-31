import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/connectivity_provider.dart';
import 'router/app_router.dart';

class OrderApp extends ConsumerWidget {
  const OrderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(onlineStatusProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'ARM Orders',
      theme: AppTheme.light(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
