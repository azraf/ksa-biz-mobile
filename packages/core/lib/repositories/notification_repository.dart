import '../api/api_client.dart';
import '../models/notification.dart';

class NotificationRepository {
  NotificationRepository(this._api);

  final ApiClient _api;

  Future<({List<InAppNotificationModel> items, int unreadCount})> list({bool unreadOnly = false}) async {
    final response = await _api.get('/notifications', query: {
      if (unreadOnly) 'unread_only': '1',
    });
    final items = (response['data'] as List<dynamic>)
        .map((e) => InAppNotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return (items: items, unreadCount: response['unread_count'] as int? ?? 0);
  }

  Future<void> markRead(int id) async {
    await _api.patch('/notifications/$id/read', body: {});
  }

  Future<void> markAllRead() async {
    await _api.patch('/notifications/read-all', body: {});
  }
}
