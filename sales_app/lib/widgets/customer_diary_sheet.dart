import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:media/widgets/customer_diary_section.dart' as shared;

import '../providers/auth_provider.dart';
import '../providers/repositories.dart';

Future<void> showCustomerDiarySheet({
  required BuildContext context,
  required WidgetRef ref,
  required String customerType,
  required int customerId,
  required String customerName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) => _CustomerDiarySheet(
        scrollController: controller,
        customerType: customerType,
        customerId: customerId,
        customerName: customerName,
      ),
    ),
  );
}

class _CustomerDiarySheet extends ConsumerWidget {
  const _CustomerDiarySheet({
    required this.scrollController,
    required this.customerType,
    required this.customerId,
    required this.customerName,
  });

  final ScrollController scrollController;
  final String customerType;
  final int customerId;
  final String customerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Material(
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.commonDiaryTitle(customerName), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          shared.CustomerDiarySection(
            customerType: customerType,
            customerId: customerId,
            diaryRepository: ref.watch(offlineDiaryRepositoryProvider),
            mediaCaptureFacade: ref.watch(mediaCaptureFacadeProvider),
            salesPersonId: ref.watch(authProvider).effectiveSalesPersonId,
          ),
        ],
      ),
    );
  }
}

Future<void> promptPostOrderDiaryNote(
  BuildContext context,
  WidgetRef ref, {
  required String customerType,
  required int customerId,
  required String customerName,
}) async {
  final l10n = AppLocalizations.of(context);
  final add = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(l10n.commonAddVisitNoteTitle),
      content: Text(l10n.commonAddVisitNoteBody(customerName)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonSkip)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.commonAddNote)),
      ],
    ),
  );
  if (add == true && context.mounted) {
    await showCustomerDiarySheet(
      context: context,
      ref: ref,
      customerType: customerType,
      customerId: customerId,
      customerName: customerName,
    );
  }
}
