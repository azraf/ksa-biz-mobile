import '../api/api_client.dart';
import '../models/admin_models.dart';
import '../models/customer.dart';
import '../models/customer_assignment_models.dart';
import '../models/customer_financial_summary.dart';
import '../models/paginated_response.dart';
import '../models/sales_person.dart';
import '../models/user.dart';

class CustomerListQuery {
  const CustomerListQuery({
    this.search,
    this.searchMode,
    this.salesPersonId,
    this.scoped = true,
    this.lastOrderWithinDays,
    this.areaId,
    this.sort = 'name',
    this.lat,
    this.lng,
    this.page = 1,
    this.perPage = 25,
  });

  final String? search;
  final String? searchMode;
  final int? salesPersonId;
  final bool scoped;
  final int? lastOrderWithinDays;
  final int? areaId;
  final String sort;
  final double? lat;
  final double? lng;
  final int page;
  final int perPage;

  Map<String, String> toQuery() {
    final q = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      'sort': sort,
      'scoped': scoped ? '1' : '0',
    };
    if (search != null && search!.isNotEmpty) q['search'] = search!;
    if (searchMode != null) q['search_mode'] = searchMode!;
    if (salesPersonId != null) q['sales_person_id'] = '$salesPersonId';
    if (lastOrderWithinDays != null) q['last_order_within_days'] = '$lastOrderWithinDays';
    if (areaId != null) q['area_id'] = '$areaId';
    if (lat != null) q['lat'] = '$lat';
    if (lng != null) q['lng'] = '$lng';
    return q;
  }
}

class CustomerRepository {
  CustomerRepository(this._api);

  final ApiClient _api;

  Future<List<CustomerTypeModel>> customerTypes() async {
    final response = await _api.get('/customer-types');
    final list = response['data'] as List<dynamic>;
    return list.map((e) => CustomerTypeModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PaginatedResponse<CustomerShopModel>> shops({
    CustomerListQuery? query,
    String? search,
    int page = 1,
    int perPage = 25,
  }) async {
    final q = query ?? CustomerListQuery(search: search, page: page, perPage: perPage);
    final response = await _api.get('/customer-shops', query: q.toQuery());
    return PaginatedResponse.fromJson(response, CustomerShopModel.fromJson);
  }

  Future<PaginatedResponse<CustomerVanModel>> vans({
    CustomerListQuery? query,
    String? search,
    int page = 1,
    int perPage = 25,
  }) async {
    final q = query ?? CustomerListQuery(search: search, page: page, perPage: perPage);
    final response = await _api.get('/customer-vans', query: q.toQuery());
    return PaginatedResponse.fromJson(response, CustomerVanModel.fromJson);
  }

  Future<PaginatedResponse<CustomerImporterModel>> importers({
    CustomerListQuery? query,
    String? search,
    int page = 1,
    int perPage = 25,
  }) async {
    final q = query ?? CustomerListQuery(search: search, page: page, perPage: perPage);
    final response = await _api.get('/customer-importers', query: q.toQuery());
    return PaginatedResponse.fromJson(response, CustomerImporterModel.fromJson);
  }

  Future<PaginatedResponse<SalesCustomerRow>> salesCustomers({
    required String search,
    String searchMode = 'phone',
    String? customerType,
    int page = 1,
    int perPage = 25,
  }) async {
    final query = <String, String>{
      'search': search,
      'search_mode': searchMode,
      'page': '$page',
      'per_page': '$perPage',
    };
    if (customerType != null) query['customer_type'] = customerType;
    final response = await _api.get('/sales-customers', query: query);
    return PaginatedResponse.fromJson(response, SalesCustomerRow.fromJson);
  }

  Future<CustomerFinancialSummary> shopSummary(int shopId) async {
    final response = await _api.get('/customer-shops/$shopId/summary');
    return CustomerFinancialSummary.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerShopModel> createShop({
    required String name,
    String? gps,
    int? areaId,
    int? salesPersonId,
    bool createUser = false,
    String? userEmail,
    String? userPhone,
    String? userPassword,
    String? userPasswordConfirmation,
  }) async {
    final body = <String, dynamic>{'name': name};
    if (gps != null) body['gps'] = gps;
    if (areaId != null) body['area_id'] = areaId;
    if (salesPersonId != null) body['sales_person_id'] = salesPersonId;
    body.addAll(buildCreateUserPayload(
          createUser: createUser,
          email: userEmail,
          phone: userPhone,
          password: userPassword,
          passwordConfirmation: userPasswordConfirmation,
        ) ??
        {});
    final response = await _api.post('/customer-shops', body: body);
    return CustomerShopModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerShopContactModel> createShopContact({
    required int shopId,
    required String contactName,
    String? contactMobile,
  }) async {
    final response = await _api.post('/customer-shop-contacts', body: {
      'customer_shop_id': shopId,
      'contact_name': contactName,
      if (contactMobile != null) 'contact_mobile': contactMobile,
      'active': true,
    });
    return CustomerShopContactModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerVanModel> createVan({
    required String name,
    String? mobile,
    String? iqamaNumber,
    String? email,
    String? address,
    String? city,
    int? areaId,
    int? salesPersonId,
    bool createUser = false,
    String? userEmail,
    String? userPhone,
    String? userPassword,
    String? userPasswordConfirmation,
  }) async {
    final body = <String, dynamic>{'name': name};
    if (mobile != null) body['mobile'] = mobile;
    if (iqamaNumber != null) body['iqama_number'] = iqamaNumber;
    if (email != null) body['email'] = email;
    if (address != null) body['address'] = address;
    if (city != null) body['city'] = city;
    if (areaId != null) body['area_id'] = areaId;
    if (salesPersonId != null) body['sales_person_id'] = salesPersonId;
    body.addAll(buildCreateUserPayload(
          createUser: createUser,
          email: userEmail,
          phone: userPhone,
          password: userPassword,
          passwordConfirmation: userPasswordConfirmation,
        ) ??
        {});
    final response = await _api.post('/customer-vans', body: body);
    return CustomerVanModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerImporterModel> createImporter({
    required String name,
    String? mobile,
    String? email,
    String? address,
    String? city,
    int? areaId,
    int? salesPersonId,
    bool createUser = false,
    String? userEmail,
    String? userPhone,
    String? userPassword,
    String? userPasswordConfirmation,
  }) async {
    final body = <String, dynamic>{'name': name};
    if (mobile != null) body['mobile'] = mobile;
    if (email != null) body['email'] = email;
    if (address != null) body['address'] = address;
    if (city != null) body['city'] = city;
    if (areaId != null) body['area_id'] = areaId;
    if (salesPersonId != null) body['sales_person_id'] = salesPersonId;
    body.addAll(buildCreateUserPayload(
          createUser: createUser,
          email: userEmail,
          phone: userPhone,
          password: userPassword,
          passwordConfirmation: userPasswordConfirmation,
        ) ??
        {});
    final response = await _api.post('/customer-importers', body: body);
    return CustomerImporterModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerShopModel> createShopUser({
    required int shopId,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post('/customer-shops/$shopId/create-user', body: {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return CustomerShopModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerVanModel> createVanUser({
    required int vanId,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post('/customer-vans/$vanId/create-user', body: {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return CustomerVanModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerImporterModel> createImporterUser({
    required int importerId,
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post('/customer-importers/$importerId/create-user', body: {
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return CustomerImporterModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerShopModel> resetShopUserPassword({
    required int shopId,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post('/customer-shops/$shopId/reset-user-password', body: {
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return CustomerShopModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerVanModel> resetVanUserPassword({
    required int vanId,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post('/customer-vans/$vanId/reset-user-password', body: {
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return CustomerVanModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerImporterModel> resetImporterUserPassword({
    required int importerId,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _api.post('/customer-importers/$importerId/reset-user-password', body: {
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
    return CustomerImporterModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerShopModel> getShop(int id) async {
    final response = await _api.get('/customer-shops/$id');
    return CustomerShopModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerVanModel> getVan(int id) async {
    final response = await _api.get('/customer-vans/$id');
    return CustomerVanModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerImporterModel> getImporter(int id) async {
    final response = await _api.get('/customer-importers/$id');
    return CustomerImporterModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  /// Admin only: allow/deny salesperson login creation for one customer.
  Future<void> setAllowUserAccountCreation({
    required String customerType,
    required int customerId,
    required bool allow,
  }) async {
    final path = switch (customerType) {
      'customer_van' => '/customer-vans/$customerId',
      'customer_importer' => '/customer-importers/$customerId',
      _ => '/customer-shops/$customerId',
    };
    await _api.patch(path, body: {'allow_user_account_creation': allow});
  }

  Future<CustomerShopModel> updateShopGps(int shopId, String gps) async {
    final response = await _api.patch('/customer-shops/$shopId', body: {'gps': gps});
    return CustomerShopModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<CustomerShopModel> clearShopGps(int shopId) async {
    final response = await _api.patch('/customer-shops/$shopId', body: {'gps': null});
    return CustomerShopModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<PaginatedResponse<SalesPersonModel>> salesPersons({int page = 1}) async {
    final response = await _api.get('/sales-persons', query: {'page': '$page', 'per_page': '50'});
    return PaginatedResponse.fromJson(response, SalesPersonModel.fromJson);
  }

  /// Mark on leave (temporary) or resigned (permanent) — hands the whole
  /// book over to [replacementSalesPersonId] in the same transaction.
  Future<void> leaveSalesPerson(
    int salesPersonId, {
    required String status,
    required int replacementSalesPersonId,
    String? reason,
    DateTime? endsAt,
  }) async {
    await _api.patch('/sales-persons/$salesPersonId/leave', body: {
      'status': status,
      'replacement_sales_person_id': replacementSalesPersonId,
      if (reason != null) 'reason': reason,
      if (endsAt != null) 'ends_at': endsAt.toIso8601String(),
    });
  }

  Future<void> rehireSalesPerson(int salesPersonId) async {
    await _api.patch('/sales-persons/$salesPersonId/rehire', body: {});
  }

  Future<int?> walkInShopId() async {
    final response = await _api.get('/config/mobile');
    final data = response['data'] as Map<String, dynamic>?;
    final id = data?['walk_in_shop_id'];
    return id is int ? id : int.tryParse('$id');
  }

  Future<CustomerShopModel?> walkInShop() async {
    final id = await walkInShopId();
    if (id == null) return null;
    final response = await _api.get('/customer-shops/$id');
    return CustomerShopModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> uploadShopImage(int shopId, List<int> bytes, String filename) async {
    await _api.uploadMultipart(
      '/customer-shops/$shopId/images',
      fileField: 'attachment',
      bytes: bytes,
      filename: filename,
    );
  }

  Future<void> uploadVanImage(int vanId, List<int> bytes, String filename) async {
    await _api.uploadMultipart(
      '/customer-vans/$vanId/images',
      fileField: 'attachment',
      bytes: bytes,
      filename: filename,
    );
  }

  Future<List<AreaModel>> areas({String? search}) async {
    final query = <String, String>{'per_page': '100'};
    if (search != null && search.isNotEmpty) query['search'] = search;
    final response = await _api.get('/areas', query: query);
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => AreaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AreaModel> createArea({required String name, String? code, int? parentId}) async {
    final response = await _api.post('/areas', body: {
      'name': name,
      if (code != null) 'code': code,
      if (parentId != null) 'parent_id': parentId,
      'active': true,
    });
    return AreaModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<PaginatedResponse<CustomerAssignmentModel>> assignments({
    int? salesPersonId,
    String? assignmentKind,
    int page = 1,
  }) async {
    final query = <String, String>{'page': '$page', 'per_page': '25'};
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';
    if (assignmentKind != null) query['assignment_kind'] = assignmentKind;
    final response = await _api.get('/customer-assignments', query: query);
    return PaginatedResponse.fromJson(response, CustomerAssignmentModel.fromJson);
  }

  Future<CustomerAssignmentModel> createAssignment(Map<String, dynamic> body) async {
    final response = await _api.post('/customer-assignments', body: body);
    return CustomerAssignmentModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  /// Temporary cover, permanent transfer, or whole-book reassignment — see
  /// CustomerAssignmentController::transfer.
  Future<int> transferAssignment(Map<String, dynamic> body) async {
    final response = await _api.post('/customer-assignments/transfer', body: body);
    return response['count'] as int? ?? 0;
  }

  Future<List<Map<String, dynamic>>> mapShops({
    int? areaId,
    String? frequencyBand,
    int? priorityRatingMin,
    String? paymentReliability,
    int? inactiveDays,
    String? search,
    bool? hasDue,
    Set<int>? salesPersonIds,
  }) async {
    final query = <String, String>{};
    if (areaId != null) query['area_id'] = '$areaId';
    if (frequencyBand != null) query['frequency_band'] = frequencyBand;
    if (priorityRatingMin != null) query['priority_rating_min'] = '$priorityRatingMin';
    if (paymentReliability != null) query['payment_reliability'] = paymentReliability;
    if (inactiveDays != null) query['inactive_days'] = '$inactiveDays';
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (hasDue != null) query['has_due'] = hasDue ? '1' : '0';
    if (salesPersonIds != null && salesPersonIds.isNotEmpty) {
      query['sales_person_ids'] = salesPersonIds.join(',');
    }
    final response = await _api.get('/reports/map-shops', query: query);
    return (response['data'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
  }

  Future<List<CustomerShopModel>> churnRisk({int days = 90}) async {
    final response = await _api.get('/reports/churn-risk', query: {'days': '$days'});
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => CustomerShopModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CustomerAssignmentModel>> assignmentCalendar({int? salesPersonId}) async {
    final query = <String, String>{};
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';
    final response = await _api.get('/reports/assignment-calendar', query: query);
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => CustomerAssignmentModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Map<String, dynamic>>> assignmentLogs({int? salesPersonId}) async {
    final query = <String, String>{'per_page': '100'};
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';
    final response = await _api.get('/reports/assignment-logs', query: query);
    final data = response['data'] as List<dynamic>? ?? [];
    return data.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> salesPersonDashboard({
    required int salesPersonId,
    String customerType = 'customer_shop',
  }) async {
    final response = await _api.get('/reports/sales-person-dashboard', query: {
      'sales_person_id': '$salesPersonId',
      'customer_type': customerType,
    });
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  Future<List<CustomerShopModel>> unassignedCustomers({String customerType = 'customer_shop'}) async {
    final response = await _api.get('/reports/unassigned-customers', query: {
      'customer_type': customerType,
      'per_page': '100',
    });
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => CustomerShopModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<SalesPersonAreaModel>> salesPersonAreas({int? salesPersonId}) async {
    final query = <String, String>{'per_page': '100'};
    if (salesPersonId != null) query['sales_person_id'] = '$salesPersonId';
    final response = await _api.get('/sales-person-areas', query: query);
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => SalesPersonAreaModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> createSalesPersonArea({
    required int salesPersonId,
    required int areaId,
  }) async {
    await _api.post('/sales-person-areas', body: {
      'sales_person_id': salesPersonId,
      'area_id': areaId,
      'active': true,
    });
  }
}
