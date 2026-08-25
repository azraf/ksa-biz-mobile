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
    this.salesPersonIds,
    this.status,
    this.paymentStatus,
    this.archived,
    this.customerType,
    this.customerId,
    this.search,
    this.fromDate,
    this.toDate,
    this.sort = 'created_at',
    this.page = 1,
    this.perPage = 20,
  });

  final int? salesPersonId;

  /// Multi-select (admin/monitor) — takes precedence over [salesPersonId]
  /// server-side when both are somehow set, mirrors the map's shop filter.
  final Set<int>? salesPersonIds;
  final String? status;
  final String? paymentStatus;

  /// Fully paid orders auto-archive; null = no filtering by archived state,
  /// true = only archived, false = only active (the admin list's default).
  final bool? archived;

  /// Internal 'customer_shop' style or server short form — mapped in toQuery.
  final String? customerType;
  final int? customerId;

  /// Order number search.
  final String? search;
  final String? fromDate;
  final String? toDate;
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
    if (salesPersonIds != null && salesPersonIds!.isNotEmpty) {
      q['sales_person_ids'] = salesPersonIds!.join(',');
    } else if (salesPersonId != null) {
      q['sales_person_id'] = '$salesPersonId';
    }
    if (status != null) q['status'] = status!;
    if (paymentStatus != null) q['payment_status'] = paymentStatus!;
    if (archived != null) q['archived'] = archived! ? '1' : '0';
    if (customerType != null && customerId != null) {
      // Server accepts the short form; the single place server names live.
      q['customer_type'] = customerType!.replaceFirst('customer_', '');
      q['customer_id'] = '$customerId';
    }
    if (search != null && search!.isNotEmpty) q['search'] = search!;
    if (fromDate != null) q['from_date'] = fromDate!;
    if (toDate != null) q['to_date'] = toDate!;
    return q;
  }
}

class OrderRepository {
  OrderRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<OrderModel>> list({
    OrderListQuery? query,
    int? salesPersonId,
    Set<int>? salesPersonIds,
    String? status,
    String? paymentStatus,
    bool? archived,
    String? search,
    String? fromDate,
    String? toDate,
    String sort = 'created_at',
    int page = 1,
    int perPage = 20,
  }) async {
    final q = query ??
        OrderListQuery(
          salesPersonId: salesPersonId,
          salesPersonIds: salesPersonIds,
          status: status,
          paymentStatus: paymentStatus,
          archived: archived,
          search: search,
          fromDate: fromDate,
          toDate: toDate,
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
    String? clientRequestId,
  }) async {
    final body = <String, dynamic>{
      'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (bankReference != null) 'bank_reference': bankReference,
      if (notes != null) 'notes': notes,
      if (applyCredit) 'apply_credit': true,
      // Server dedupes per order on this key (max 36 chars) — retries and
      // offline replays of the same payment must reuse the same id.
      if (clientRequestId != null) 'client_request_id': clientRequestId,
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

  Future<List<DiscountApprovalRequestModel>> listPendingCancellationRequests() async {
    final response = await _api.get('/cancellation-requests', query: {'status': 'pending'});
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => DiscountApprovalRequestModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<DiscountApprovalRequestModel> approveCancellation(int requestId, {String? reviewNotes}) async {
    final response = await _api.post('/cancellation-requests/$requestId/approve', body: {
      if (reviewNotes != null) 'review_notes': reviewNotes,
    });
    return DiscountApprovalRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<DiscountApprovalRequestModel> rejectCancellation(int requestId, {String? reviewNotes}) async {
    final response = await _api.post('/cancellation-requests/$requestId/reject', body: {
      if (reviewNotes != null) 'review_notes': reviewNotes,
    });
    return DiscountApprovalRequestModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  /// Generate (or fetch, idempotent) the ZATCA e-invoice for an order.
  Future<OrderZatcaModel> generateZatcaInvoice(int orderId) async {
    final response = await _api.post('/orders/$orderId/zatca-invoice', body: {});
    return OrderZatcaModel.fromJson(response['data'] as Map<String, dynamic>?);
  }

  /// Record a successful print (drives the COPY label on reprints).
  Future<OrderZatcaModel> markZatcaInvoicePrinted(int orderId) async {
    final response = await _api.post('/orders/$orderId/zatca-invoice/printed', body: {});
    return OrderZatcaModel.fromJson(response['data'] as Map<String, dynamic>?);
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
