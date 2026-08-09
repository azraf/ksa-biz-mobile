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

  /// [customerType] is `customer_shop` / `customer_van` / `customer_importer`.
  /// Customer logins can omit both — the server derives identity from the
  /// token and forces `source=customer`.
  Future<ManualOrderRequestModel> create({
    String? customerType,
    int? customerId,
    required String notes,
    String source = 'customer',
    int? assignedSalesPersonId,
    String? clientRequestId,
  }) async {
    final body = <String, dynamic>{
      'source': source,
      'notes': notes,
    };
    if (customerType != null && customerId != null) {
      body['${customerType}_id'] = customerId;
    }
    if (assignedSalesPersonId != null) {
      body['assigned_sales_person_id'] = assignedSalesPersonId;
    }
    if (clientRequestId != null) {
      body['client_request_id'] = clientRequestId;
    }
    final response = await _api.post('/manual-order-requests', body: body);
    return ManualOrderRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ManualOrderRequestModel> linkOrders(int id, List<int> orderIds) async {
    final response = await _api.post('/manual-order-requests/$id/link-orders', body: {
      'order_ids': orderIds,
    });
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
