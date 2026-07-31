import 'package:core/core.dart';

class ProductPriceRepository {
  ProductPriceRepository(this._api);

  final ApiClient _api;

  Future<List<ProductPriceModel>> listByCustomerType(int customerTypeId) async {
    final response = await _api.get(
      '/product-prices-by-customer-type',
      query: {'customer_type_id': '$customerTypeId', 'per_page': '500'},
    );
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => ProductPriceModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
