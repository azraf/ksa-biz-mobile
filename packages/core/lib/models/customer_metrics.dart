import 'package:equatable/equatable.dart';

import '../support/json_parse.dart';

class CustomerMetricsFields extends Equatable {
  const CustomerMetricsFields({
    this.priorityRating,
    this.paymentReliability,
    this.paymentReliabilityOverride,
    this.paymentReliabilityEffective,
    this.orderCount = 0,
    this.ordersLast90Days = 0,
    this.avgDaysBetweenOrders,
    this.frequencyBand = 'never',
  });

  final int? priorityRating;
  final String? paymentReliability;
  final String? paymentReliabilityOverride;
  final String? paymentReliabilityEffective;
  final int orderCount;
  final int ordersLast90Days;
  final double? avgDaysBetweenOrders;
  final String frequencyBand;

  factory CustomerMetricsFields.fromJson(Map<String, dynamic> json) {
    return CustomerMetricsFields(
      priorityRating: json['priority_rating'] as int?,
      paymentReliability: json['payment_reliability'] as String?,
      paymentReliabilityOverride: json['payment_reliability_override'] as String?,
      paymentReliabilityEffective: json['payment_reliability_effective'] as String?,
      orderCount: json['order_count'] as int? ?? 0,
      ordersLast90Days: json['orders_last_90_days'] as int? ?? 0,
      // decimal columns arrive as strings ("2.58") from Laravel's decimal cast
      avgDaysBetweenOrders: parseJsonDoubleOrNull(json['avg_days_between_orders']),
      frequencyBand: json['frequency_band'] as String? ?? 'never',
    );
  }

  String get frequencyLabel => switch (frequencyBand) {
        'frequent' => 'Frequent',
        'regular' => 'Regular',
        'occasional' => 'Occasional',
        'dormant' => 'Dormant',
        _ => 'Never',
      };

  String get paymentLabel => switch (paymentReliabilityEffective ?? paymentReliability) {
        'good' => 'Good payer',
        'fair' => 'Fair',
        'poor' => 'Poor',
        _ => '—',
      };

  @override
  List<Object?> get props => [priorityRating, frequencyBand, paymentReliabilityEffective];
}
