import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';
import '../../services/visit_reminder_service.dart';
import '../../widgets/customer_picker_sheet.dart';

/// Prefill for the "schedule visit" entry points (customer detail, dues rows,
/// watchlist items, collection candidates).
class VisitPrefill {
  const VisitPrefill({
    this.customerType,
    this.customerId,
    this.customerName,
    this.watchlistItemId,
    this.purpose,
    this.scheduledAt,
  });

  final String? customerType;
  final int? customerId;
  final String? customerName;
  final int? watchlistItemId;
  final String? purpose;
  final DateTime? scheduledAt;
}

/// Returns true when a visit was saved.
Future<bool?> showVisitFormSheet(
  BuildContext context,
  WidgetRef ref, {
  VisitScheduleModel? existing,
  VisitPrefill? prefill,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _VisitFormSheet(existing: existing, prefill: prefill),
    ),
  );
}

class _VisitFormSheet extends ConsumerStatefulWidget {
  const _VisitFormSheet({this.existing, this.prefill});

  final VisitScheduleModel? existing;
  final VisitPrefill? prefill;

  @override
  ConsumerState<_VisitFormSheet> createState() => _VisitFormSheetState();
}

class _VisitFormSheetState extends ConsumerState<_VisitFormSheet> {
  late String _purpose;
  late DateTime _when;
  String? _customerType;
  int? _customerId;
  String? _customerName;
  int? _watchlistItemId;
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();
  bool _saving = false;

  bool get _isEdit => widget.existing != null;

  /// Editing only reschedules — the target and purpose are fixed once created,
  /// matching the server's reschedule semantics.
  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    final prefill = widget.prefill;

    _purpose = existing?.purpose ?? prefill?.purpose ?? 'regular_visit';
    _when = existing?.scheduledDate ??
        prefill?.scheduledAt ??
        DateTime.now().add(const Duration(days: 1)).copyWith(hour: 9, minute: 0);
    _customerType = existing?.customerType ?? prefill?.customerType;
    _customerId = existing?.customerId ?? prefill?.customerId;
    _customerName = existing?.customerName ?? prefill?.customerName;
    _watchlistItemId = existing?.watchlistItemId ?? prefill?.watchlistItemId;
    _notesController.text = existing?.notes ?? '';
    if (existing?.durationMinutes != null) {
      _durationController.text = '${existing!.durationMinutes}';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  bool get _hasTarget =>
      _customerId != null || _watchlistItemId != null || _purpose == 'new_client_search';

  Future<void> _pickCustomer() async {
    final result = await showCustomerPickerSheet(
      context: context,
      ref: ref,
      customerType: 'customer_shop',
      salesPersonId: ref.read(authProvider).effectiveSalesPersonId,
    );
    if (result == null) return;
    setState(() {
      _customerType = result.typeName;
      _customerId = (result.customer as dynamic).id as int;
      _customerName = (result.customer as dynamic).name as String?;
      _watchlistItemId = null;
    });
  }

  Future<void> _pickWatchlistItem() async {
    final l10n = AppLocalizations.of(context);
    final spId = ref.read(authProvider).effectiveSalesPersonId;
    List<WatchlistItemModel> items = const [];
    try {
      items = await ref
          .read(offlineWatchlistRepositoryProvider)
          .listLocalAndRemote(salesPersonId: spId ?? 0);
    } catch (_) {}
    if (!mounted) return;

    final selected = await showModalBottomSheet<WatchlistItemModel>(
      context: context,
      builder: (ctx) => ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(l10n.planPickWatchlist, style: Theme.of(ctx).textTheme.titleMedium),
          ),
          // Local-only prospects can't anchor a visit until they sync.
          for (final item in items.where((i) => !i.isLocalOnly))
            ListTile(
              leading: const Icon(Icons.explore_outlined),
              title: Text(item.placeName ?? '#${item.id}'),
              subtitle: Text(item.gps),
              onTap: () => Navigator.pop(ctx, item),
            ),
        ],
      ),
    );
    if (selected == null) return;
    setState(() {
      _watchlistItemId = selected.id;
      _customerName = selected.placeName;
      _customerType = null;
      _customerId = null;
    });
  }

  Future<void> _pickWhen() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (time == null) return;
    setState(() => _when = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _saving = true);
    try {
      final repo = ref.read(offlineVisitRepositoryProvider);
      if (_isEdit) {
        await repo.update(
          widget.existing!,
          scheduledAt: _when.toIso8601String(),
          durationMinutes: int.tryParse(_durationController.text),
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      } else {
        await VisitReminderService.instance.requestPermissionIfNeeded();
        await repo.create(VisitScheduleModel(
          id: 0,
          salesPersonId: ref.read(authProvider).effectiveSalesPersonId,
          customerType: _customerType,
          customerShopId: _customerType == 'customer_shop' ? _customerId : null,
          customerVanId: _customerType == 'customer_van' ? _customerId : null,
          customerImporterId: _customerType == 'customer_importer' ? _customerId : null,
          watchlistItemId: _watchlistItemId,
          customerName: _customerName,
          scheduledAt: _when.toIso8601String(),
          durationMinutes: int.tryParse(_durationController.text),
          purpose: _purpose,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        ));
      }
      if (!mounted) return;
      await refreshVisitReminders(context, ref);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.planVisitSaved)));
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lockedTarget = _isEdit || widget.prefill?.customerId != null || widget.prefill?.watchlistItemId != null;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEdit ? l10n.planEditVisit : l10n.planNewVisit,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            if (!_isEdit) ...[
              DropdownButtonFormField<String>(
                initialValue: _purpose,
                decoration: InputDecoration(labelText: l10n.planPurposeField),
                items: [
                  for (final purpose in VisitScheduleModel.purposes)
                    DropdownMenuItem(
                      value: purpose,
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: visitPurposeColor(context, purpose)),
                          const SizedBox(width: 8),
                          Text(visitPurposeLabel(l10n, purpose)),
                        ],
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _purpose = v ?? _purpose),
              ),
              const SizedBox(height: 12),

              // Target: locked when the entry point supplied one.
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  _watchlistItemId != null ? Icons.explore_outlined : Icons.storefront_outlined,
                ),
                title: Text(_customerName ??
                    (_purpose == 'new_client_search' ? l10n.planPurposeNewClientSearch : l10n.planPickCustomer)),
                trailing: lockedTarget
                    ? null
                    : Wrap(
                        spacing: 4,
                        children: [
                          TextButton(onPressed: _pickCustomer, child: Text(l10n.planPickCustomer)),
                          if (_purpose == 'new_client_search')
                            TextButton(onPressed: _pickWatchlistItem, child: Text(l10n.planPickWatchlist)),
                        ],
                      ),
              ),
            ],

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: Text(formatAppDateTime(_when.toIso8601String())),
              trailing: TextButton(onPressed: _pickWhen, child: Text(l10n.commonEdit)),
            ),

            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.planDuration),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.commonNotesOptional),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving || !_hasTarget ? null : _save,
              icon: const Icon(Icons.check),
              label: Text(l10n.commonSave),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
