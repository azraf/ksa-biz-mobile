import '../api/api_client.dart';
import '../models/customer.dart';
import '../models/discount_approval_request.dart';
import '../models/order.dart';
import '../models/paginated_response.dart';
import '../models/payment.dart';
import '../utils/client_request_id.dart';

class OrderListQuery {
  const OrderListQuery({
    this.salesPersonId,
    this.status,
    this.paymentStatus,
    this.sort = 'created_at',
    this.page = 1,
    this.perPage = 20,
  });

  final int? salesPersonId;
  final String? status;
  final String? paymentStatus;
  final String sort;
  final int page;
  final int perPage;

  Map<String, String> toQuery() {
    final q = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      'view': 'list',
      'sort': sort,
    };
    if (salesPersonId != null) q['sales_person_id'] = '$salesPersonId';
    if (status != null) q['status'] = status!;
    if (paymentStatus != null) q['payment_status'] = paymentStatus!;
    return q;
  }
}

class OrderRepository {
  OrderRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<OrderModel>> list({
    OrderListQuery? query,
    int? salesPersonId,
    String? status,
    String? paymentStatus,
    String sort = 'created_at',
    int page = 1,
    int perPage = 20,
  }) async {
    final q = query ??
        OrderListQuery(
          salesPersonId: salesPersonId,
          status: status,
          paymentStatus: paymentStatus,
          sort: sort,
          page: page,
          perPage: perPage,
        );

    final response = await _api.get('/orders', query: q.toQuery());
    return PaginatedResponse.fromJson(response, OrderModel.fromJson);
  }

  Future<OrderModel> get(int id) async {
    final response = await _api.get('/orders/$id');
    return OrderModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<OrderModel> create(Map<String, dynamic> body) async {
    final payload = Map<String, dynamic>.from(body);
    payload.putIfAbsent('client_request_id', () => _clientRequestId());
    final response = await _api.post('/orders', body: payload);
    return OrderModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<OrderModel> recordPayment(
    int orderId, {
    required double amount,
    String? paymentMethod,
    String? bankReference,
    String? notes,
    bool applyCredit = false,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (bankReference != null) 'bank_reference': bankReference,
      if (notes != null) 'notes': notes,
      if (applyCredit) 'apply_credit': true,
    };
    final response = await _api.post('/orders/$orderId/payments', body: body);
    return OrderModel.fromJson(response['order'] as Map<String, dynamic>);
  }

  Future<DiscountApprovalRequestModel> submitDiscountRequest(
    int orderId, {
    required double amount,
    String? reason,
  }) async {
    final response = await _api.post('/orders/$orderId/discount-requests', body: {
      'amount': amount,
      if (reason != null) 'reason': reason,
    });
    return DiscountApprovalRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<List<DiscountApprovalRequestModel>> discountRequests(int orderId) async {
    final response = await _api.get('/orders/$orderId/discount-requests');
    return (response['data'] as List<dynamic>)
        .map((e) => DiscountApprovalRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<DiscountApprovalRequestModel> approveDiscount(int requestId, {String? reviewNotes}) async {
    final response = await _api.post('/discount-requests/$requestId/approve', body: {
      if (reviewNotes != null) 'review_notes': reviewNotes,
    });
    return DiscountApprovalRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<DiscountApprovalRequestModel> rejectDiscount(int requestId, {String? reviewNotes}) async {
    final response = await _api.post('/discount-requests/$requestId/reject', body: {
      if (reviewNotes != null) 'review_notes': reviewNotes,
    });
    return DiscountApprovalRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<List<DiscountApprovalRequestModel>> listPendingDiscountRequests() async {
    final response = await _api.get('/discount-requests', query: {'status': 'pending'});
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => DiscountApprovalRequestModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderModel> addItem(int orderId, Map<String, dynamic> item) async {
    final response = await _api.post('/orders/$orderId/items', body: item);
    return OrderModel.fromJson(response['order'] as Map<String, dynamic>);
  }

  Future<OrderModel> updateItem(int orderId, int itemId, Map<String, dynamic> item) async {
    final response = await _api.patch('/orders/$orderId/items/$itemId', body: item);
    return OrderModel.fromJson(response['order'] as Map<String, dynamic>);
  }

  Future<OrderModel> removeItem(int orderId, int itemId) async {
    final response = await _api.deleteJson('/orders/$orderId/items/$itemId');
    return OrderModel.fromJson(response['order'] as Map<String, dynamic>);
  }

  Future<OrderModel> recordReturn(int orderId, List<Map<String, dynamic>> items) async {
    final response = await _api.post('/orders/$orderId/returns', body: {'items': items});
    return OrderModel.fromJson(response['order'] as Map<String, dynamic>);
  }

  Future<OrderModel> confirmOrder(
    int orderId, {
    int? salesPersonId,
    String? inventorySource,
  }) async {
    final body = <String, dynamic>{
      if (salesPersonId != null) 'sales_person_id': salesPersonId,
      if (inventorySource != null) 'inventory_source': inventorySource,
    };
    final response = await _api.post('/orders/$orderId/confirm', body: body);
    return OrderModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<OrderModel> cancel(int orderId, String reason) async {
    final response = await _api.post('/orders/$orderId/cancel', body: {'reason': reason});
    return OrderModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<PaymentModel> voidPayment(int paymentId, {required String reason}) async {
    final response = await _api.post('/payments/$paymentId/void', body: {'reason': reason});
    return PaymentModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<List<OrderModificationModel>> modifications(int orderId) async {
    final response = await _api.get('/orders/$orderId/modifications');
    return (response['data'] as List<dynamic>)
        .map((e) => OrderModificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String _clientRequestId() => generateClientRequestId();
}
