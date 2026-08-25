import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  List<InAppNotificationModel> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(notificationRepositoryProvider).list();
      if (!mounted) return;
      setState(() {
        _items = result.items;
        _loading = false;
      });
    } catch (e) {
      // Offline must read as an error, not an empty inbox.
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = AppErrorMapper.localize(context, e);
      });
      if (_items.isNotEmpty) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _open(InAppNotificationModel n) async {
    if (!n.isRead) {
      // Optimistic flip so the row updates immediately; revert on failure.
      final index = _items.indexOf(n);
      if (index != -1) {
        setState(() {
          _items = [..._items]..[index] = InAppNotificationModel(
              id: n.id,
              type: n.type,
              title: n.title,
              body: n.body,
              data: n.data,
              readAt: DateTime.now().toIso8601String(),
              createdAt: n.createdAt,
            );
        });
      }
      try {
        await ref.read(notificationRepositoryProvider).markRead(n.id);
      } catch (_) {
        if (mounted && index != -1) {
          setState(() => _items = [..._items]..[index] = n);
        }
      }
    }
    final orderId = n.data?['order_id'];
    if (orderId != null && mounted) {
      context.push('/orders/$orderId');
    }
  }

  Future<void> _markAllRead() async {
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
      return;
    }
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return Scaffold(body: LoadingView(message: l10n.commonLoading));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.salesNotifications),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: _markAllRead,
          ),
        ],
      ),
      body: _error != null && _items.isEmpty
          ? ErrorView(message: _error!, onRetry: _load)
          : RefreshIndicator(
              onRefresh: _load,
              child: _items.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: EmptyView(message: l10n.salesNotificationsEmpty),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (_, i) {
                        final n = _items[i];
                        return ListTile(
                          leading: Icon(n.isRead
                              ? Icons.notifications_none
                              : Icons.notifications_active),
                          title: Text(n.title),
                          subtitle: Text(n.body ?? ''),
                          onTap: () => _open(n),
                        );
                      },
                    ),
            ),
    );
  }
}
