import '../support/json_parse.dart';

/// GET /customer-shops/{id}/summary — lifetime money totals plus the derived
/// next payment (oldest open order's due date and remaining balance).
class CustomerFinancialSummary {
  const CustomerFinancialSummary({
    required this.ordersCount,
    required this.purchasedTotal,
    required this.paidTotal,
    required this.discountTotal,
    required this.due,
    required this.overdue,
    this.oldestDueDate,
    this.nextPaymentAmount,
    this.nextPaymentDate,
    this.nextPaymentOrderId,
    this.lastPaymentAt,
  });

  final int ordersCount;
  final double purchasedTotal;
  final double paidTotal;
  final double discountTotal;
  final double due;
  final double overdue;
  final String? oldestDueDate;
  final double? nextPaymentAmount;
  final String? nextPaymentDate;
  final int? nextPaymentOrderId;
  final String? lastPaymentAt;

  factory CustomerFinancialSummary.fromJson(Map<String, dynamic> json) {
    return CustomerFinancialSummary(
      ordersCount: parseJsonInt(json['orders_count']),
      purchasedTotal: parseJsonDouble(json['purchased_total']),
      paidTotal: parseJsonDouble(json['paid_total']),
      discountTotal: parseJsonDouble(json['discount_total']),
      due: parseJsonDouble(json['due']),
      overdue: parseJsonDouble(json['overdue']),
      oldestDueDate: json['oldest_due_date']?.toString(),
      nextPaymentAmount: json['next_payment_amount'] == null
          ? null
          : parseJsonDouble(json['next_payment_amount']),
      nextPaymentDate: json['next_payment_date']?.toString(),
      nextPaymentOrderId: parseJsonIntOrNull(json['next_payment_order_id']),
      lastPaymentAt: json['last_payment_at']?.toString(),
    );
  }
}
