import '../api/api_client.dart';
import '../models/manual_order_request.dart';
import '../models/order.dart';
import '../models/paginated_response.dart';

class ManualOrderRepository {
  ManualOrderRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<ManualOrderRequestModel>> list({
    String? status,
    bool openPool = false,
    int? assignedSalesPersonId,
    int page = 1,
  }) async {
    final query = <String, String>{'page': '$page', 'per_page': '20'};
    if (status != null) query['status'] = status;
    if (openPool) query['open_pool'] = '1';
    if (assignedSalesPersonId != null) {
      query['assigned_sales_person_id'] = '$assignedSalesPersonId';
    }

    final response = await _api.get('/manual-order-requests', query: query);
    return PaginatedResponse.fromJson(response, ManualOrderRequestModel.fromJson);
  }

  Future<ManualOrderRequestModel> get(int id) async {
    final response = await _api.get('/manual-order-requests/$id');
    return ManualOrderRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ManualOrderRequestModel> create({
    required int customerShopId,
    required String notes,
    String source = 'app',
    int? assignedSalesPersonId,
  }) async {
    final body = <String, dynamic>{
      'customer_shop_id': customerShopId,
      'source': source,
      'notes': notes,
    };
    if (assignedSalesPersonId != null) {
      body['assigned_sales_person_id'] = assignedSalesPersonId;
    }
    final response = await _api.post('/manual-order-requests', body: body);
    return ManualOrderRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ManualOrderRequestModel> claim(int id, int salesPersonId) async {
    final response = await _api.post('/manual-order-requests/$id/claim', body: {
      'sales_person_id': salesPersonId,
    });
    return ManualOrderRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ManualOrderRequestModel> uploadRecording(
    int id, {
    required List<int> bytes,
    required String filename,
    String? recordingType,
  }) async {
    final response = await _api.uploadMultipart(
      '/manual-order-requests/$id/recordings',
      fileField: 'file',
      bytes: bytes,
      filename: filename,
      fields: recordingType != null ? {'type': recordingType} : null,
    );
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return ManualOrderRequestModel.fromJson(data);
    }
    return get(id);
  }

  Future<OrderModel> convert(int id, Map<String, dynamic> body) async {
    final response = await _api.post('/manual-order-requests/$id/convert', body: body);
    return OrderModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
