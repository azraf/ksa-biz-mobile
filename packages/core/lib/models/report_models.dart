import 'package:equatable/equatable.dart';

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
        ordersCount: json['orders_count'] as int? ?? 0,
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

  factory ProductSalesRow.fromJson(Map<String, dynamic> json) => ProductSalesRow(
        productId: json['product_id'] as int?,
        qty: json['qty'] as int? ?? 0,
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
        expenseCategoryId: json['expense_category_id'] as int?,
        categoryName: json['category_name'] as String?,
        total: SalesReport._toDouble(json['total']),
        count: json['count'] as int? ?? 0,
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

  factory PeriodExpenseRow.fromJson(Map<String, dynamic> json) => PeriodExpenseRow(
        periodKey: json['period_key'] as String?,
        total: SalesReport._toDouble(json['total']),
      );

  @override
  List<Object?> get props => [periodKey, total];
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
