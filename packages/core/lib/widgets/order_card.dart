import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../models/order.dart';
import '../theme/app_colors.dart';
import '../utils/format_helpers.dart';
import 'common_widgets.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.currency,
    this.subtitle,
    this.showDue = false,
  });

  final OrderModel order;
  final VoidCallback onTap;
  final NumberFormat? currency;
  final String? subtitle;

  /// Show the outstanding due amount when the order has one. Off by default
  /// so existing callers (sales_app) are unaffected.
  final bool showDue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = currency ?? NumberFormat.currency(symbol: 'SAR ');
    final pending = order.id < 0;
    final dateLabel = order.createdAt != null ? formatAppDateWithRelative(order.createdAt) : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerShopName ?? l10n.commonOrderNumber(order.id.abs()),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.id >= 0
                          ? l10n.commonOrderNumber(order.id)
                          : 'Order #${formatOrderId(order.id)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                    if (dateLabel != null && dateLabel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(dateLabel, style: Theme.of(context).textTheme.bodySmall),
                    ],
                    if (showDue && order.outstandingDue > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${money.format(order.outstandingDue)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.danger(context),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        StatusChip(label: order.paymentStatus),
                        StatusChip(label: order.status),
                        if (pending)
                          Chip(
                            label: Text(l10n.salesPendingSync),
                            backgroundColor: Colors.blue.shade100,
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                money.format(order.totalBill),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.seed,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatOrderId(int id) => id < 0 ? 'L${id.abs()}' : '$id';

bool isPendingSyncOrder(int id) => id < 0;
