import '../api/api_client.dart';

class SyncRepository {
  SyncRepository(this._api);

  final ApiClient _api;

  Future<List<Map<String, dynamic>>> push(List<Map<String, dynamic>> operations) async {
    final response = await _api.post('/sync/push', body: {'operations': operations});
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
