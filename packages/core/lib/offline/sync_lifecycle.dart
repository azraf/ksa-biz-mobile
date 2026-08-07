import 'dart:async';

import 'package:flutter/material.dart';

import 'offline_sync_trigger.dart';
import 'sync_service.dart';

/// Foreground periodic sync + registers [OfflineSyncTrigger] for auto-sync after enqueue.
class SyncLifecycle extends StatefulWidget {
  const SyncLifecycle({
    super.key,
    required this.syncService,
    required this.child,
    this.onSyncComplete,
    this.period = const Duration(seconds: 45),
  });

  final SyncService syncService;
  final Widget child;
  final VoidCallback? onSyncComplete;
  final Duration period;

  @override
  State<SyncLifecycle> createState() => _SyncLifecycleState();
}

class _SyncLifecycleState extends State<SyncLifecycle> with WidgetsBindingObserver {
  Timer? _timer;
  StreamSubscription<void>? _syncSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    OfflineSyncTrigger.onEnqueue = () => widget.syncService.syncIfOnline();
    _syncSub = widget.syncService.onSyncComplete.listen((_) {
      widget.onSyncComplete?.call();
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(widget.period, (_) => widget.syncService.syncIfOnline());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.syncService.syncIfOnline();
      _startTimer();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    OfflineSyncTrigger.onEnqueue = null;
    _timer?.cancel();
    _syncSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
