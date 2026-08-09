import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../models/customer_financial_summary.dart';
import '../theme/app_colors.dart';
import '../utils/format_helpers.dart';

/// One card of label/value money rows for the customer detail screens
/// (sales + admin): totals, dues, derived next payment.
class CustomerMoneySummaryCard extends StatelessWidget {
  const CustomerMoneySummaryCard({super.key, required this.summary});

  final CustomerFinancialSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ', decimalDigits: 2);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(l10n.customerMoneyTitle, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                if (summary.overdue > 0)
                  Chip(
                    label: Text(
                      '${l10n.customerMoneyOverdue} ${currency.format(summary.overdue)}',
                      style: TextStyle(color: AppColors.danger(context)),
                    ),
                    backgroundColor: AppColors.dangerContainer(context),
                    side: BorderSide.none,
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            _row(context, l10n.customerMoneyOrders, '${summary.ordersCount}'),
            _row(context, l10n.customerMoneyPurchased, currency.format(summary.purchasedTotal)),
            _row(context, l10n.customerMoneyPaid, currency.format(summary.paidTotal)),
            if (summary.discountTotal > 0)
              _row(context, l10n.customerMoneyDiscounts, currency.format(summary.discountTotal)),
            _row(
              context,
              l10n.customerMoneyDue,
              currency.format(summary.due),
              bold: true,
              color: summary.due > 0 ? AppColors.danger(context) : null,
            ),
            if (summary.nextPaymentAmount != null)
              _row(
                context,
                l10n.customerMoneyNextPayment,
                '${currency.format(summary.nextPaymentAmount)} · ${formatAppDate(summary.nextPaymentDate)}',
              ),
            if (summary.lastPaymentAt != null)
              _row(context, l10n.customerMoneyLastPayment, formatAppDate(summary.lastPaymentAt)),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value,
      {bool bold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
