import '../api/api_client.dart';
import '../models/paginated_response.dart';
import '../models/watchlist_item.dart';

class WatchlistRepository {
  WatchlistRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<WatchlistItemModel>> list({
    int? salesPersonId,
    String status = 'active',
    String? archivedReason,
    int page = 1,
  }) async {
    final query = <String, String>{
      'page': '$page',
      'per_page': '20',
      'status': status,
    };
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';
    if (archivedReason != null) query['archived_reason'] = archivedReason;

    final response = await _api.get('/watchlist-items', query: query);
    return PaginatedResponse.fromJson(response, WatchlistItemModel.fromJson);
  }

  Future<WatchlistItemModel> get(int id) async {
    final response = await _api.get('/watchlist-items/$id');
    return WatchlistItemModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<WatchlistItemModel> create({
    required String gps,
    required int salesPersonId,
    String? placeName,
    String? noteText,
    String? clientRequestId,
  }) async {
    final response = await _api.post('/watchlist-items', body: {
      'gps': gps,
      'sales_person_id': salesPersonId,
      if (placeName != null) 'place_name': placeName,
      if (noteText != null) 'note_text': noteText,
      if (clientRequestId != null) 'client_request_id': clientRequestId,
    });
    return WatchlistItemModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<WatchlistItemModel> update(int id, Map<String, dynamic> body) async {
    final response = await _api.patch('/watchlist-items/$id', body: body);
    return WatchlistItemModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _api.delete('/watchlist-items/$id');
  }

  Future<void> uploadAttachment(
    int id, {
    required List<int> bytes,
    required String filename,
    required String type,
    int? durationSeconds,
  }) async {
    await _api.uploadMultipart(
      '/watchlist-items/$id/attachments',
      fileField: 'file',
      bytes: bytes,
      filename: filename,
      fields: {
        'type': type,
        if (durationSeconds != null) 'duration_seconds': '$durationSeconds',
      },
    );
  }

  Future<Map<String, dynamic>> convertToShop(
    int id, {
    required String name,
    String? contactMobile,
    String? contactName,
    int? priorityRating,
  }) async {
    final response = await _api.post('/watchlist-items/$id/convert-to-shop', body: {
      'name': name,
      if (contactMobile != null) 'contact_mobile': contactMobile,
      if (contactName != null) 'contact_name': contactName,
      if (priorityRating != null) 'priority_rating': priorityRating,
    });
    return response['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> nearby({
    required double lat,
    required double lng,
    int radiusM = 100,
    int? salesPersonId,
  }) async {
    final query = <String, String>{
      'lat': '$lat',
      'lng': '$lng',
      'radius_m': '$radiusM',
    };
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';
    final response = await _api.get('/watchlist-items/nearby', query: query);
    return response['data'] as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> mapPins({int? salesPersonId}) async {
    final query = <String, String>{};
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';
    final response = await _api.get('/reports/map-watchlist', query: query);
    return (response['data'] as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
