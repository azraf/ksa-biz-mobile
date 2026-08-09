import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';
import '../../services/visit_reminder_service.dart';
import 'visit_form_sheet.dart';

/// Returns true when the visit changed (status or schedule).
Future<bool?> showVisitDetailSheet(
  BuildContext context,
  WidgetRef ref,
  VisitScheduleModel visit,
) {
  return showModalBottomSheet<bool>(
    context: context,
    builder: (_) => _VisitDetailSheet(visit: visit),
  );
}

class _VisitDetailSheet extends ConsumerStatefulWidget {
  const _VisitDetailSheet({required this.visit});

  final VisitScheduleModel visit;

  @override
  ConsumerState<_VisitDetailSheet> createState() => _VisitDetailSheetState();
}

class _VisitDetailSheetState extends ConsumerState<_VisitDetailSheet> {
  bool _busy = false;

  void _openCustomer() {
    final visit = widget.visit;
    final id = visit.customerId;
    if (id == null || id <= 0) return;
    final segment = switch (visit.customerType) {
      'customer_shop' => 'shop',
      'customer_van' => 'van',
      _ => 'importer',
    };
    Navigator.pop(context, false);
    context.push('/customers/$segment/$id');
  }

  Future<void> _transition(String operation) async {
    final l10n = AppLocalizations.of(context);

    // Local-only rows have no server id — sync first (watchlist precedent).
    if (widget.visit.isLocalOnly && operation != 'cancel') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.planSyncFirst)));
      return;
    }

    String? outcome;
    if (operation == 'complete' || operation == 'miss') {
      final controller = TextEditingController();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(operation == 'complete' ? l10n.planMarkDone : l10n.planMarkMissed),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.planOutcomeNote),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSave)),
          ],
        ),
      );
      if (confirmed != true) return;
      outcome = controller.text.trim().isEmpty ? null : controller.text.trim();
    }

    if (!mounted) return;
    setState(() => _busy = true);
    try {
      final repo = ref.read(offlineVisitRepositoryProvider);
      if (widget.visit.isLocalOnly && operation == 'cancel') {
        await repo.deleteLocal(widget.visit);
      } else {
        await repo.transition(widget.visit, operation, outcomeNote: outcome);
      }
      if (!mounted) return;
      await refreshVisitReminders(context, ref);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<void> _reschedule() async {
    final changed = await showVisitFormSheet(context, ref, existing: widget.visit);
    if (changed == true && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final visit = widget.visit;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: visitPurposeColor(context, visit.purpose)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    visit.customerName ?? visitPurposeLabel(l10n, visit.purpose),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                StatusChip(label: visit.status),
                if (visit.isLocalOnly) ...[
                  const SizedBox(width: 4),
                  const StatusChip(label: 'pending sync'),
                ],
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(formatAppDateTime(visit.scheduledAt)),
              subtitle: visit.durationMinutes != null
                  ? Text('${visit.durationMinutes} min · ${visitPurposeLabel(l10n, visit.purpose)}')
                  : Text(visitPurposeLabel(l10n, visit.purpose)),
            ),
            if (visit.customerId != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.storefront_outlined),
                title: Text(visit.customerName ?? '#${visit.customerId}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: _openCustomer,
              ),
            if (visit.gps != null && visit.gps!.isNotEmpty)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: OpenInMapsButton(gps: visit.gps!),
              ),
            if (visit.notes != null && visit.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(visit.notes!),
              ),
            if (visit.outcomeNote != null && visit.outcomeNote!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${l10n.planOutcomeNote}: ${visit.outcomeNote}'),
              ),
            const SizedBox(height: 12),
            if (visit.isPlanned && !_busy) ...[
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _transition('complete'),
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(l10n.planMarkDone),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _transition('miss'),
                      icon: const Icon(Icons.event_busy_outlined),
                      label: Text(l10n.planMarkMissed),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reschedule,
                      icon: const Icon(Icons.edit_calendar_outlined),
                      label: Text(l10n.planEditVisit),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _transition('cancel'),
                      icon: const Icon(Icons.cancel_outlined),
                      label: Text(l10n.planCancelVisit),
                    ),
                  ),
                ],
              ),
            ],
            if (_busy) const Padding(padding: EdgeInsets.all(8), child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
