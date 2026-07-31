import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../models/customer_metrics.dart';

class CustomerMetricsBadges extends StatelessWidget {
  const CustomerMetricsBadges({
    super.key,
    required this.metrics,
    this.compact = false,
  });

  final CustomerMetricsFields metrics;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final paymentCode = metrics.paymentReliabilityEffective ?? metrics.paymentReliability;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (metrics.priorityRating != null) _stars(metrics.priorityRating!),
        _chip(localizedStatusLabel(context, metrics.frequencyBand), Colors.blue.shade50, Colors.blue.shade800),
        if (paymentCode != null && paymentCode != 'unknown')
          _chip(localizedStatusLabel(context, paymentCode), Colors.green.shade50, Colors.green.shade800),
        if (!compact && metrics.avgDaysBetweenOrders != null)
          Text(
            AppLocalizations.of(context).commonAvgOrderInterval(metrics.avgDaysBetweenOrders!.round()),
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }

  Widget _stars(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 14,
          color: Colors.amber.shade700,
        );
      }),
    );
  }

  Widget _chip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600)),
    );
  }
}

CustomerMetricsFields metricsFromJson(Map<String, dynamic> json) =>
    CustomerMetricsFields.fromJson(json);
