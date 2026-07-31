import '../api/api_client.dart';
import '../models/customer_diary_note.dart';
import '../models/paginated_response.dart';

class CustomerDiaryRepository {
  CustomerDiaryRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<CustomerDiaryNoteModel>> list({
    required String customerType,
    required int customerId,
    int page = 1,
  }) async {
    final query = <String, String>{
      'customer_type': customerType,
      'page': '$page',
      'per_page': '20',
    };
    switch (customerType) {
      case 'customer_shop':
        query['customer_shop_id'] = '$customerId';
      case 'customer_van':
        query['customer_van_id'] = '$customerId';
      case 'customer_importer':
        query['customer_importer_id'] = '$customerId';
    }

    final response = await _api.get('/customer-diary-notes', query: query);
    return PaginatedResponse.fromJson(response, CustomerDiaryNoteModel.fromJson);
  }

  Future<CustomerDiaryNoteModel> create({
    required String customerType,
    required int customerId,
    required String noteType,
    String? body,
    int? salesPersonId,
  }) async {
    final payload = <String, dynamic>{
      'customer_type': customerType,
      'note_type': noteType,
      if (body != null) 'body': body,
      if (salesPersonId != null) 'sales_person_id': salesPersonId,
    };
    switch (customerType) {
      case 'customer_shop':
        payload['customer_shop_id'] = customerId;
      case 'customer_van':
        payload['customer_van_id'] = customerId;
      case 'customer_importer':
        payload['customer_importer_id'] = customerId;
    }

    final response = await _api.post('/customer-diary-notes', body: payload);
    return CustomerDiaryNoteModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> uploadRecording(int noteId, List<int> bytes, String filename, {int? durationSeconds}) async {
    await _api.uploadMultipart(
      '/customer-diary-notes/$noteId/recording',
      fileField: 'file',
      bytes: bytes,
      filename: filename,
      fields: {
        if (durationSeconds != null) 'duration_seconds': '$durationSeconds',
      },
    );
  }
}
