import 'package:equatable/equatable.dart';

import '../support/json_parse.dart';

class SalesReport extends Equatable {
  const SalesReport({
    this.fromDate,
    this.toDate,
    this.ordersCount = 0,
    this.totalBill = 0,
    this.byProduct = const [],
  });

  final String? fromDate;
  final String? toDate;
  final int ordersCount;
  final double totalBill;
  final List<ProductSalesRow> byProduct;

  factory SalesReport.fromJson(Map<String, dynamic> json) => SalesReport(
        fromDate: json['from_date']?.toString(),
        toDate: json['to_date']?.toString(),
        ordersCount: parseJsonInt(json['orders_count']),
        totalBill: _toDouble(json['total_bill']),
        byProduct: (json['by_product'] as List<dynamic>? ?? [])
            .map((e) => ProductSalesRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [ordersCount, totalBill];
}

class ProductSalesRow extends Equatable {
  const ProductSalesRow({this.productId, this.qty = 0, this.revenue = 0});

  final int? productId;
  final int qty;
  final double revenue;

  factory ProductSalesRow.fromJson(Map<String, dynamic> json) =>
      ProductSalesRow(
        productId: parseJsonIntOrNull(json['product_id']),
        qty: parseJsonInt(json['qty']),
        revenue: SalesReport._toDouble(json['revenue']),
      );

  @override
  List<Object?> get props => [productId, qty, revenue];
}

class ProfitReport extends Equatable {
  const ProfitReport({this.revenue = 0, this.cost = 0, this.profit = 0});

  final double revenue;
  final double cost;
  final double profit;

  factory ProfitReport.fromJson(Map<String, dynamic> json) => ProfitReport(
        revenue: SalesReport._toDouble(json['revenue']),
        cost: SalesReport._toDouble(json['cost']),
        profit: SalesReport._toDouble(json['profit']),
      );

  @override
  List<Object?> get props => [revenue, cost, profit];
}

class ExpenseReport extends Equatable {
  const ExpenseReport({
    this.fromDate,
    this.toDate,
    this.totalAmount = 0,
    this.byCategory = const [],
  });

  final String? fromDate;
  final String? toDate;
  final double totalAmount;
  final List<ExpenseCategoryRow> byCategory;

  factory ExpenseReport.fromJson(Map<String, dynamic> json) => ExpenseReport(
        fromDate: json['from_date']?.toString(),
        toDate: json['to_date']?.toString(),
        totalAmount: SalesReport._toDouble(json['total_amount']),
        byCategory: (json['by_category'] as List<dynamic>? ?? [])
            .map((e) => ExpenseCategoryRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [totalAmount];
}

class ExpenseCategoryRow extends Equatable {
  const ExpenseCategoryRow({
    this.expenseCategoryId,
    this.categoryName,
    this.total = 0,
    this.count = 0,
  });

  final int? expenseCategoryId;
  final String? categoryName;
  final double total;
  final int count;

  factory ExpenseCategoryRow.fromJson(Map<String, dynamic> json) =>
      ExpenseCategoryRow(
        expenseCategoryId: parseJsonIntOrNull(json['expense_category_id']),
        categoryName: json['category_name'] as String?,
        total: SalesReport._toDouble(json['total']),
        count: parseJsonInt(json['count']),
      );

  @override
  List<Object?> get props => [expenseCategoryId, total];
}

class ExpenseSummaryReport extends Equatable {
  const ExpenseSummaryReport({
    this.period,
    this.fromDate,
    this.toDate,
    this.grandTotal = 0,
    this.byPeriod = const [],
  });

  final String? period;
  final String? fromDate;
  final String? toDate;
  final double grandTotal;
  final List<PeriodExpenseRow> byPeriod;

  factory ExpenseSummaryReport.fromJson(Map<String, dynamic> json) =>
      ExpenseSummaryReport(
        period: json['period'] as String?,
        fromDate: json['from_date']?.toString(),
        toDate: json['to_date']?.toString(),
        grandTotal: SalesReport._toDouble(json['grand_total']),
        byPeriod: (json['by_period'] as List<dynamic>? ?? [])
            .map((e) => PeriodExpenseRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [grandTotal];
}

class PeriodExpenseRow extends Equatable {
  const PeriodExpenseRow({this.periodKey, this.total = 0});

  final String? periodKey;
  final double total;

  factory PeriodExpenseRow.fromJson(Map<String, dynamic> json) =>
      PeriodExpenseRow(
        periodKey: json['period_key'] as String?,
        total: SalesReport._toDouble(json['total']),
      );

  @override
  List<Object?> get props => [periodKey, total];
}

class SalesPersonPerformanceRow extends Equatable {
  const SalesPersonPerformanceRow({
    required this.id,
    required this.name,
    this.orders = 0,
    this.orderValue = 0,
    this.averageOrderValue = 0,
    this.shopsServed = 0,
    this.totalCartons = 0,
    this.collected = 0,
    this.collectionRate,
    this.outstanding = 0,
    this.newShops = 0,
    this.prospects = 0,
    this.prospectsConverted = 0,
  });

  final int id;
  final String name;
  final int orders;
  final double orderValue;
  final double averageOrderValue;
  final int shopsServed;
  final double totalCartons;
  final double collected;
  final double? collectionRate;
  final double outstanding;
  final int newShops;
  final int prospects;
  final int prospectsConverted;

  factory SalesPersonPerformanceRow.fromJson(Map<String, dynamic> json) =>
      SalesPersonPerformanceRow(
        id: parseJsonInt(json['id']),
        name: json['name']?.toString() ?? '',
        orders: parseJsonInt(json['orders']),
        orderValue: parseJsonDouble(json['order_value']),
        averageOrderValue: parseJsonDouble(json['average_order_value']),
        shopsServed: parseJsonInt(json['shops_served']),
        totalCartons: parseJsonDouble(json['total_cartons']),
        collected: parseJsonDouble(json['collected']),
        collectionRate: json['collection_rate'] == null
            ? null
            : parseJsonDouble(json['collection_rate']),
        outstanding: parseJsonDouble(json['outstanding']),
        newShops: parseJsonInt(json['new_shops']),
        prospects: parseJsonInt(json['prospects']),
        prospectsConverted: parseJsonInt(json['prospects_converted']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'orders': orders,
        'order_value': orderValue,
        'average_order_value': averageOrderValue,
        'shops_served': shopsServed,
        'total_cartons': totalCartons,
        'collected': collected,
        'collection_rate': collectionRate,
        'outstanding': outstanding,
        'new_shops': newShops,
        'prospects': prospects,
        'prospects_converted': prospectsConverted,
      };

  @override
  List<Object?> get props =>
      [id, orders, orderValue, totalCartons, outstanding];
}

class ProductPerformanceRow extends Equatable {
  const ProductPerformanceRow({
    required this.salesPersonId,
    required this.productId,
    required this.productName,
    this.cartons = 0,
    this.revenue = 0,
  });

  final int salesPersonId;
  final int productId;
  final String productName;
  final double cartons;
  final double revenue;

  factory ProductPerformanceRow.fromJson(Map<String, dynamic> json) =>
      ProductPerformanceRow(
        salesPersonId: parseJsonInt(json['sales_person_id']),
        productId: parseJsonInt(json['product_id']),
        productName: json['product_name']?.toString() ?? '',
        cartons: parseJsonDouble(json['cartons']),
        revenue: parseJsonDouble(json['revenue']),
      );

  Map<String, dynamic> toJson() => {
        'sales_person_id': salesPersonId,
        'product_id': productId,
        'product_name': productName,
        'cartons': cartons,
        'revenue': revenue,
      };

  @override
  List<Object?> get props => [salesPersonId, productId, cartons, revenue];
}

class SalesPerformanceReport extends Equatable {
  const SalesPerformanceReport({this.rows = const [], this.items});

  final List<SalesPersonPerformanceRow> rows;
  final List<ProductPerformanceRow>? items;

  factory SalesPerformanceReport.fromJson(Map<String, dynamic> json) =>
      SalesPerformanceReport(
        rows: (json['rows'] as List<dynamic>? ?? [])
            .map((e) =>
                SalesPersonPerformanceRow.fromJson(e as Map<String, dynamic>))
            .toList(),
        items: (json['items'] as List<dynamic>?)
            ?.map((e) =>
                ProductPerformanceRow.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'rows': rows.map((r) => r.toJson()).toList(),
        'items': items?.map((i) => i.toJson()).toList(),
      };

  @override
  List<Object?> get props => [rows, items];
}

class ReportResult<T> {
  const ReportResult({
    required this.data,
    this.fetchedAt,
    this.isCached = false,
    this.isStale = false,
  });

  final T data;
  final String? fetchedAt;
  final bool isCached;
  final bool isStale;
}
