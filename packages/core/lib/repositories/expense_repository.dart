import '../api/api_client.dart';
import '../models/expense_models.dart';
import '../models/paginated_response.dart';

class ExpenseRepository {
  ExpenseRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<ExpenseModel>> list({
    int? categoryId,
    String? status,
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    final query = <String, String>{'page': '$page', 'per_page': '20'};
    if (categoryId != null) query['expense_category_id'] = '$categoryId';
    if (status != null) query['status'] = status;
    if (fromDate != null) query['from_date'] = fromDate;
    if (toDate != null) query['to_date'] = toDate;

    final response = await _api.get('/expenses', query: query);
    return PaginatedResponse.fromJson(response, ExpenseModel.fromJson);
  }

  Future<ExpenseModel> get(int id) async {
    final response = await _api.get('/expenses/$id');
    return ExpenseModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ExpenseModel> create(Map<String, dynamic> body) async {
    final response = await _api.post('/expenses', body: body);
    return ExpenseModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ExpenseModel> update(int id, Map<String, dynamic> body) async {
    final response = await _api.put('/expenses/$id', body: body);
    return ExpenseModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _api.delete('/expenses/$id');
  }

  Future<List<ExpenseCategoryModel>> listCategories({bool withChildren = false}) async {
    final query = withChildren ? {'with_children': '1'} : null;
    final response = await _api.get('/expense-categories', query: query);
    return (response['data'] as List<dynamic>)
        .map((e) => ExpenseCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
