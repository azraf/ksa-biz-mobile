import '../api/api_client.dart';
import '../models/paginated_response.dart';
import '../models/visit_schedule.dart';
import '../utils/client_request_id.dart';

class VisitSummaryRow {
  const VisitSummaryRow({
    required this.salesPersonId,
    this.name,
    this.planned = 0,
    this.done = 0,
    this.missed = 0,
    this.cancelled = 0,
    this.total = 0,
  });

  final int salesPersonId;
  final String? name;
  final int planned;
  final int done;
  final int missed;
  final int cancelled;
  final int total;

  factory VisitSummaryRow.fromJson(Map<String, dynamic> json) => VisitSummaryRow(
        salesPersonId: json['sales_person_id'] as int,
        name: json['name'] as String?,
        planned: json['planned'] as int? ?? 0,
        done: json['done'] as int? ?? 0,
        missed: json['missed'] as int? ?? 0,
        cancelled: json['cancelled'] as int? ?? 0,
        total: json['total'] as int? ?? 0,
      );
}

class VisitScheduleRepository {
  VisitScheduleRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<VisitScheduleModel>> list({
    String? from,
    String? to,
    String? purpose,
    String? status,
    int? salesPersonId,
    int page = 1,
    int perPage = 100,
  }) async {
    final response = await _api.get('/visit-schedules', query: {
      if (from != null) 'from': from,
      if (to != null) 'to': to,
      if (purpose != null) 'purpose': purpose,
      if (status != null) 'status': status,
      if (salesPersonId != null) 'sales_person_id': '$salesPersonId',
      'page': '$page',
      'per_page': '$perPage',
    });
    return PaginatedResponse.fromJson(response, VisitScheduleModel.fromJson);
  }

  /// Per-salesperson planned/done/missed counts (admin compliance strip).
  Future<List<VisitSummaryRow>> summary({
    required String from,
    required String to,
    int? salesPersonId,
  }) async {
    final response = await _api.get('/visit-schedules/summary', query: {
      'from': from,
      'to': to,
      if (salesPersonId != null) 'sales_person_id': '$salesPersonId',
    });
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => VisitSummaryRow.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VisitScheduleModel> create(Map<String, dynamic> payload) async {
    payload.putIfAbsent('client_request_id', generateClientRequestId);
    final response = await _api.post('/visit-schedules', body: payload);
    return VisitScheduleModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<VisitScheduleModel> update(int id, Map<String, dynamic> payload) async {
    final response = await _api.patch('/visit-schedules/$id', body: payload);
    return VisitScheduleModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<VisitScheduleModel> complete(int id, {String? outcomeNote}) =>
      _transition(id, 'complete', {'outcome_note': outcomeNote});

  Future<VisitScheduleModel> miss(int id, {String? outcomeNote}) =>
      _transition(id, 'miss', {'outcome_note': outcomeNote});

  Future<VisitScheduleModel> cancel(int id, {String? reason}) =>
      _transition(id, 'cancel', {'reason': reason});

  Future<VisitScheduleModel> _transition(int id, String action, Map<String, dynamic> body) async {
    body.removeWhere((_, v) => v == null);
    final response = await _api.post('/visit-schedules/$id/$action', body: body);
    return VisitScheduleModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<List<CollectionCandidate>> collectionCandidates({int limit = 50}) async {
    final response = await _api.get('/visit-schedules/collection-candidates', query: {
      'limit': '$limit',
    });
    final data = response['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => CollectionCandidate.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
