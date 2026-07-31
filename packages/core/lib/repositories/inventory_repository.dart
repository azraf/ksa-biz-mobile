import '../api/api_client.dart';
import '../models/inventory_models.dart';
import '../models/inventory_stock.dart';
import '../models/purchase.dart';

class InventoryRepository {
  InventoryRepository(this._api);

  final ApiClient _api;

  Future<List<InventoryStockModel>> vanStock(int salesPersonId) async {
    final response = await _api.get('/inventory/van-stock', query: {
      'sales_person_id': '$salesPersonId',
    });
    return (response['data'] as List<dynamic>)
        .map((e) => InventoryStockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<InventoryStockModel>> warehouseStock() async {
    final response = await _api.get('/inventory/warehouse-stock');
    return (response['data'] as List<dynamic>)
        .map((e) => InventoryStockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<InventoryStockModel>> lowStock({int? salesPersonId}) async {
    final response = await _api.get('/inventory/low-stock', query: {
      if (salesPersonId != null) 'sales_person_id': '$salesPersonId',
    });
    return (response['data'] as List<dynamic>)
        .map((e) => InventoryStockModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<StockMovementModel>> movements({
    int? productId,
    String? movementType,
    String? fromDate,
    String? toDate,
  }) async {
    final response = await _api.get('/inventory/movements', query: {
      if (productId != null) 'product_id': '$productId',
      if (movementType != null) 'movement_type': movementType,
      if (fromDate != null) 'from_date': fromDate,
      if (toDate != null) 'to_date': toDate,
    });
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => StockMovementModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<InventoryValuationModel> valuation({int? salesPersonId}) async {
    final response = await _api.get('/inventory/valuation', query: {
      if (salesPersonId != null) 'sales_person_id': '$salesPersonId',
    });
    return InventoryValuationModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> loadVan({
    required int productId,
    required int quantity,
    required int salesPersonId,
  }) async {
    await _api.post('/inventory/load-van', body: {
      'product_id': productId,
      'quantity': quantity,
      'sales_person_id': salesPersonId,
    });
  }

  Future<List<BulkLoadPreviewLine>> bulkLoadVanPreview() async {
    final response = await _api.get('/inventory/bulk-load-van/preview');
    return (response['data'] as List<dynamic>)
        .map((e) => BulkLoadPreviewLine.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<BulkLoadResult> bulkLoadVan({
    required int salesPersonId,
    List<BulkLoadLineDraft>? lines,
    bool loadAll = false,
  }) async {
    final response = await _api.post('/inventory/bulk-load-van', body: {
      'sales_person_id': salesPersonId,
      if (loadAll) 'load_all': true,
      if (!loadAll && lines != null)
        'lines': lines
            .map((line) => {
                  'product_id': line.productId,
                  'quantity': line.quantity,
                  if (line.unitId != null) 'unit_id': line.unitId,
                })
            .toList(),
    });
    return BulkLoadResult.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> unloadVan({
    required int productId,
    required int quantity,
    required int salesPersonId,
  }) async {
    await _api.post('/inventory/unload-van', body: {
      'product_id': productId,
      'quantity': quantity,
      'sales_person_id': salesPersonId,
    });
  }

  Future<void> transfer({
    required int productId,
    required int quantity,
    required int fromSalesPersonId,
    required int toSalesPersonId,
  }) async {
    await _api.post('/inventory/transfer', body: {
      'product_id': productId,
      'quantity': quantity,
      'from_sales_person_id': fromSalesPersonId,
      'to_sales_person_id': toSalesPersonId,
    });
  }

  Future<void> returnStock({
    required int productId,
    required int quantity,
    required int salesPersonId,
    String? notes,
  }) async {
    await _api.post('/inventory/return', body: {
      'product_id': productId,
      'quantity': quantity,
      'sales_person_id': salesPersonId,
      if (notes != null) 'notes': notes,
    });
  }

  Future<DamageReplacementModel> createDamageReplacement({
    required String replacementType,
    required int productId,
    required int quantity,
    int? salesPersonId,
    String? reason,
    int? referenceOrderId,
  }) async {
    final response = await _api.post('/inventory/damage-replacements', body: {
      'replacement_type': replacementType,
      'product_id': productId,
      'quantity': quantity,
      if (salesPersonId != null) 'sales_person_id': salesPersonId,
      if (reason != null) 'reason': reason,
      if (referenceOrderId != null) 'reference_order_id': referenceOrderId,
    });
    return DamageReplacementModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<ProductExchangeModel> createProductExchange({
    required int salesPersonId,
    required String settlementType,
    required int returnProductId,
    required int returnQuantity,
    int? outProductId,
    int? outQuantity,
    double? cashAmount,
    String? reason,
    int? originalOrderId,
  }) async {
    final response = await _api.post('/inventory/product-exchanges', body: {
      'sales_person_id': salesPersonId,
      'settlement_type': settlementType,
      'return_product_id': returnProductId,
      'return_quantity': returnQuantity,
      if (outProductId != null) 'out_product_id': outProductId,
      if (outQuantity != null) 'out_quantity': outQuantity,
      if (cashAmount != null) 'cash_amount': cashAmount,
      if (reason != null) 'reason': reason,
      if (originalOrderId != null) 'original_order_id': originalOrderId,
    });
    return ProductExchangeModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> createAdjustment({
    required int productId,
    required int quantity,
    required String direction,
    int? salesPersonId,
    required String reason,
  }) async {
    await _api.post('/inventory/adjustments', body: {
      'product_id': productId,
      'quantity': quantity,
      'direction': direction,
      if (salesPersonId != null) 'sales_person_id': salesPersonId,
      'reason': reason,
    });
  }
}

class PurchaseRepository {
  PurchaseRepository(this._api);

  final ApiClient _api;

  Future<List<PurchaseModel>> list({String? status, String? purchaseType}) async {
    final response = await _api.get('/purchases', query: {
      if (status != null) 'status': status,
      if (purchaseType != null) 'purchase_type': purchaseType,
      'per_page': '100',
    });
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PurchaseModel> create(Map<String, dynamic> body) async {
    final response = await _api.post('/purchases', body: body);
    return PurchaseModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<PurchaseModel> update(int id, Map<String, dynamic> body) async {
    final response = await _api.put('/purchases/$id', body: body);
    return PurchaseModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<PurchaseModel> post(int id) async {
    final response = await _api.post('/purchases/$id/post');
    return PurchaseModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<PurchaseModel> cancel(int id) async {
    final response = await _api.post('/purchases/$id/cancel');
    return PurchaseModel.fromJson(response['data'] as Map<String, dynamic>);
  }

  Future<void> receiveContainer(int containerId) async {
    await _api.post('/shipping-containers/$containerId/receive');
  }
}
