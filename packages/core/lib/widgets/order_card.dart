import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../models/order.dart';
import '../theme/app_colors.dart';
import '../theme/app_colors.dart';
import 'common_widgets.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.currency,
  });

  final OrderModel order;
  final VoidCallback onTap;
  final NumberFormat? currency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = currency ?? NumberFormat.currency(symbol: 'SAR ');
    final pending = order.id < 0;
    final created = order.createdAt;
    final relative = created != null ? _relativeTime(created) : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
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
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      order.id >= 0
                          ? l10n.commonOrderNumber(order.id)
                          : 'Order #${formatOrderId(order.id)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (relative != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(relative, style: Theme.of(context).textTheme.bodySmall),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        StatusChip(label: order.paymentStatus),
                        StatusChip(label: order.status),
                        if (pending)
                          StatusChip(
                            label: 'pending_sync',
                            icon: Icons.cloud_upload_outlined,
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

  String _relativeTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

String formatOrderId(int id) => id < 0 ? 'L${id.abs()}' : '$id';

bool isPendingSyncOrder(int id) => id < 0;
