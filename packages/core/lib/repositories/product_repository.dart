import '../api/api_client.dart';
import '../models/product.dart';
import '../models/product_carton.dart';
import '../models/paginated_response.dart';

class ProductRepository {
  ProductRepository(this._api);

  final ApiClient _api;

  Future<PaginatedResponse<ProductModel>> list({
    String? search,
    int? categoryId,
    int? brandId,
    int page = 1,
  }) async {
    final query = <String, String>{'page': '$page', 'per_page': '20'};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (categoryId != null) query['category_id'] = '$categoryId';
    if (brandId != null) query['brand_id'] = '$brandId';

    final response = await _api.get('/products', query: query);
    return PaginatedResponse.fromJson(response, ProductModel.fromJson);
  }

  Future<ProductModel> get(int id) async {
    final response = await _api.get('/products/$id');
    return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ProductModel> create(Map<String, dynamic> body) async {
    final response = await _api.post('/products', body: body);
    return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ProductModel> update(int id, Map<String, dynamic> body) async {
    final response = await _api.put('/products/$id', body: body);
    return ProductModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await _api.delete('/products/$id');
  }

  Future<List<ProductCartonModel>> listCartons(int productId) async {
    final response = await _api.get('/product-cartons', query: {'product_id': '$productId'});
    return (response['data'] as List<dynamic>)
        .map((e) => ProductCartonModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
