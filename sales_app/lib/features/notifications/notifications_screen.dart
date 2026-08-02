import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(notificationRepositoryProvider).list();
      setState(() {
        _items = result.items;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _open(InAppNotificationModel n) async {
    if (!n.isRead) {
      await ref.read(notificationRepositoryProvider).markRead(n.id);
    }
    final orderId = n.data?['order_id'];
    if (orderId != null && mounted) {
      context.push('/orders/$orderId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all read',
            onPressed: () async {
              await ref.read(notificationRepositoryProvider).markAllRead();
              await _load();
            },
          ),
        ),
        Expanded(
          child: _items.isEmpty
              ? EmptyView(message: l10n.salesNotificationsEmpty)
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (_, i) {
                    final n = _items[i];
                    return ListTile(
                      leading: Icon(n.isRead ? Icons.notifications_none : Icons.notifications_active),
                      title: Text(n.title),
                      subtitle: Text(n.body ?? ''),
                      onTap: () => _open(n),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
