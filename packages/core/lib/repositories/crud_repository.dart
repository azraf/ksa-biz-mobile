import '../api/api_client.dart';
import '../models/paginated_response.dart';

typedef JsonMapper<T> = T Function(Map<String, dynamic> json);

class CrudRepository<T> {
  CrudRepository(
    this._api,
    this._path,
    this._fromJson, {
    this.paginated = false,
  });

  final ApiClient _api;
  final String _path;
  final JsonMapper<T> _fromJson;
  final bool paginated;

  Future<List<T>> list({Map<String, String>? query}) async {
    final response = await _api.get(_path, query: query);
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PaginatedResponse<T>> listPaginated({
    Map<String, String>? query,
    int page = 1,
    int perPage = 20,
  }) async {
    final q = {...?query, 'page': '$page', 'per_page': '$perPage'};
    final response = await _api.get(_path, query: q);
    return PaginatedResponse.fromJson(response, _fromJson);
  }

  Future<T> get(int id) async {
    final response = await _api.get('$_path/$id');
    return _fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<T> create(Map<String, dynamic> body) async {
    final response = await _api.post(_path, body: body);
    return _fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<T> update(int id, Map<String, dynamic> body) async {
    final response = await _api.put('$_path/$id', body: body);
    return _fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _api.delete('$_path/$id');
  }
}
