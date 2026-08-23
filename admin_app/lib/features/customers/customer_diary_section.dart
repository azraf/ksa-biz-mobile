import 'package:core/core.dart' hide sharedPreferencesProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media/widgets/customer_diary_section.dart' as shared;

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

/// Thin wrapper so existing call sites keep their import; the widget itself is
/// shared with sales and order detail from the media package.
class CustomerDiarySection extends ConsumerWidget {
  const CustomerDiarySection({
    super.key,
    required this.customerType,
    required this.customerId,
    this.orderId,
  });

  final String customerType;
  final int customerId;
  final int? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return shared.CustomerDiarySection(
      customerType: customerType,
      customerId: customerId,
      orderId: orderId,
      diaryRepository: ref.watch(offlineDiaryRepositoryProvider),
      mediaCaptureFacade: ref.watch(mediaCaptureFacadeProvider),
      // Without this admin-authored notes carry no sales_person_id, unlike the
      // identical sales_app wrapper.
      salesPersonId: ref.watch(authProvider).effectiveSalesPersonId,
    );
  }
}

class CustomerRatingSection extends StatelessWidget {
  const CustomerRatingSection({
    super.key,
    required this.priorityRating,
    required this.paymentOverride,
    required this.metrics,
    required this.onPriorityChanged,
    required this.onPaymentOverrideChanged,
  });

  final int? priorityRating;
  final String? paymentOverride;
  final CustomerMetricsFields metrics;
  final ValueChanged<int?> onPriorityChanged;
  final ValueChanged<String?> onPaymentOverrideChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rating & frequency', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                return IconButton(
                  icon: Icon(star <= (priorityRating ?? 0) ? Icons.star : Icons.star_border),
                  color: Colors.amber.shade700,
                  onPressed: () => onPriorityChanged(star),
                );
              }),
            ),
            CustomerMetricsBadges(metrics: metrics),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              initialValue: paymentOverride,
              decoration: const InputDecoration(labelText: 'Payment reliability override'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Auto')),
                DropdownMenuItem(value: 'good', child: Text('Good')),
                DropdownMenuItem(value: 'fair', child: Text('Fair')),
                DropdownMenuItem(value: 'poor', child: Text('Poor')),
              ],
              onChanged: onPaymentOverrideChanged,
            ),
          ],
        ),
      ),
    );
  }
}
