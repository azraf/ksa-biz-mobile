import 'package:flutter/widgets.dart';
import 'package:l10n/l10n.dart';

/// Maps API status codes to localized UI labels.
String localizedStatusLabel(BuildContext context, String status) {
  final l10n = AppLocalizations.of(context);
  switch (status.toLowerCase()) {
    case 'confirmed':
      return l10n.statusConfirmed;
    case 'modified':
      return l10n.statusModified;
    case 'cancelled':
      return l10n.statusCancelled;
    case 'pending':
      return l10n.statusPending;
    case 'draft':
      return l10n.statusDraft;
    case 'planned':
      return l10n.statusPlanned;
    case 'done':
      return l10n.statusDone;
    case 'missed':
      return l10n.statusMissed;
    case 'partial':
      return l10n.statusPartial;
    case 'paid':
      return l10n.statusPaid;
    case 'assigned':
      return l10n.statusAssigned;
    case 'in_review':
      return l10n.statusInReview;
    case 'converted':
      return l10n.statusConverted;
    case 'active':
      return l10n.statusActive;
    case 'archived':
      return l10n.statusArchived;
    case 'pending sync':
      return l10n.statusPendingSync;
    case 'discount pending approval':
      return l10n.statusDiscountPendingApproval;
    case 'add_item':
      return l10n.statusAddItem;
    case 'update_item':
      return l10n.statusUpdateItem;
    case 'remove_item':
      return l10n.statusRemoveItem;
    case 'return':
      return l10n.statusReturn;
    case 'frequent':
      return l10n.statusFrequent;
    case 'regular':
      return l10n.statusRegular;
    case 'occasional':
      return l10n.statusOccasional;
    case 'dormant':
      return l10n.statusDormant;
    case 'never':
      return l10n.statusNever;
    case 'van':
      return 'Van stock';
    case 'warehouse':
      return 'Warehouse only';
    case 'warehouse_deliver':
      return 'Warehouse + delivery';
    case 'good':
      return l10n.statusGoodPayer;
    case 'fair':
      return l10n.statusFair;
    case 'poor':
      return l10n.statusPoor;
    default:
      return status.replaceAll('_', ' ');
  }
}

String localizedPaymentMethodLabel(BuildContext context, String method) {
  final l10n = AppLocalizations.of(context);
  switch (method.toLowerCase()) {
    case 'cash':
      return l10n.commonCash;
    case 'transfer':
      return l10n.commonBankTransfer;
    case 'cheque':
      return l10n.commonCheque;
    case 'other':
      return l10n.commonOther;
    default:
      return method;
  }
}
