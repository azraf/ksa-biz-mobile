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
    int perPage = 20,

    /// Attach the per-source stock breakdown to every product.
    bool withStock = false,

    /// Inventory sources to count: `warehouse`, `mine`, `other_vans`,
    /// `van:<id>`. Empty means everywhere. The server drops `van:<id>` from a
    /// salesperson, so this can never widen what they see.
    Set<String>? sources,

    /// Only products with a balance above zero across [sources].
    bool inStock = false,

    /// `name` (default), `stock_desc`, `stock_asc`, `price_asc`, `price_desc`.
    String? sort,
  }) async {
    final query = <String, String>{'page': '$page', 'per_page': '$perPage'};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (categoryId != null) query['category_id'] = '$categoryId';
    if (brandId != null) query['brand_id'] = '$brandId';
    if (withStock) query['with_stock'] = '1';
    if (inStock) query['in_stock'] = '1';
    if (sources != null && sources.isNotEmpty) query['sources'] = sources.join(',');
    if (sort != null && sort.isNotEmpty) query['sort'] = sort;

    final response = await _api.get('/products', query: query);
    return PaginatedResponse.fromJson(response, ProductModel.fromJson);
  }

  Future<ProductModel> get(int id, {bool withStock = false}) async {
    final response = await _api.get(
      '/products/$id',
      query: withStock ? {'with_stock': '1'} : null,
    );
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

  Future<void> uploadFeatureImage(int productId, List<int> bytes, String filename) async {
    await _api.uploadMultipart(
      '/products/$productId/feature-image',
      fileField: 'image',
      bytes: bytes,
      filename: filename,
    );
  }

  Future<void> uploadGalleryImage(int productId, List<int> bytes, String filename) async {
    await _api.uploadMultipart(
      '/products/$productId/gallery',
      fileField: 'image',
      bytes: bytes,
      filename: filename,
    );
  }

  Future<void> deleteGalleryImage(int productId, int mediaId) async {
    await _api.delete('/products/$productId/gallery/$mediaId');
  }
}
