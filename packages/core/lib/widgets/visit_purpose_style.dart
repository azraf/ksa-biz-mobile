import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../theme/app_colors.dart';

/// Token-only colours matching the backend's purpose→colour map
/// (danger/accent/success/warning/default). Shared by the sales planner and
/// the admin team calendar.
Color visitPurposeColor(BuildContext context, String purpose) {
  final cs = Theme.of(context).colorScheme;
  return switch (purpose) {
    'due_collection' => AppColors.danger(context),
    'regular_visit' => cs.primary,
    'delivery' => AppColors.pending(context),
    'promotional_visit' => AppColors.warning(context),
    'new_client_search' => AppColors.success(context),
    _ => cs.onSurfaceVariant,
  };
}

String visitPurposeLabel(AppLocalizations l10n, String purpose) {
  return switch (purpose) {
    'due_collection' => l10n.planPurposeDueCollection,
    'regular_visit' => l10n.planPurposeRegularVisit,
    'delivery' => l10n.planPurposeDelivery,
    'promotional_visit' => l10n.planPurposePromotionalVisit,
    'new_client_search' => l10n.planPurposeNewClientSearch,
    _ => l10n.planPurposeOther,
  };
}
