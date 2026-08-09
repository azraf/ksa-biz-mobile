import '../api/api_client.dart';
import '../models/admin_models.dart';
import '../models/category.dart';
import '../models/lookup_models.dart';
import '../models/purchase.dart';
import '../models/shipping.dart';
import '../repositories/crud_repository.dart';

class AdminRepositories {
  AdminRepositories(this.api);

  final ApiClient api;

  CrudRepository<TagModel> get tags =>
      CrudRepository(api, '/tags', TagModel.fromJson);

  CrudRepository<BrandModel> get brands =>
      CrudRepository(api, '/brands', BrandModel.fromJson);

  CrudRepository<UnitModel> get units =>
      CrudRepository(api, '/units', UnitModel.fromJson);

  CrudRepository<CountryModel> get countries =>
      CrudRepository(api, '/countries', CountryModel.fromJson);

  CrudRepository<VehicleModel> get vehicles =>
      CrudRepository(api, '/vehicles', VehicleModel.fromJson);

  CrudRepository<CategoryModel> get categories =>
      CrudRepository(api, '/categories', CategoryModel.fromJson);

  CrudRepository<PromotionModel> get promotions =>
      CrudRepository(api, '/promotions', PromotionModel.fromJson, paginated: true);

  CrudRepository<SupplierModel> get suppliers =>
      CrudRepository(api, '/suppliers', SupplierModel.fromJson, paginated: true);

  CrudRepository<ShippingContainerModel> get shippingContainers =>
      CrudRepository(api, '/shipping-containers', ShippingContainerModel.fromJson, paginated: true);

  CrudRepository<ContainerProductModel> get containerProducts =>
      CrudRepository(api, '/container-products', ContainerProductModel.fromJson);

  CrudRepository<PurchaseModel> get purchases =>
      CrudRepository(api, '/purchases', PurchaseModel.fromJson, paginated: true);

  CrudRepository<AdminUserModel> get users =>
      CrudRepository(api, '/users', AdminUserModel.fromJson, paginated: true);

  Future<List<String>> listRoles() async {
    final response = await api.get('/roles');
    return (response['data'] as List<dynamic>).map((e) => e.toString()).toList();
  }

  Future<AdminUserModel> syncUserRoles(int userId, List<String> roles) async {
    final response = await api.put('/users/$userId/roles', body: {'roles': roles});
    return AdminUserModel.fromJson(response['data'] as Map<String, dynamic>);
  }
}
