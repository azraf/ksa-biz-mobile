import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../providers/repositories.dart';
import '../../services/visit_reminder_service.dart';
import 'visit_detail_sheet.dart';
import 'visit_form_sheet.dart';

/// Month calendar + day agenda over the offline visit cache, colour-coded by
/// purpose with client-side purpose/status filters.
class VisitPlannerView extends ConsumerStatefulWidget {
  const VisitPlannerView({super.key});

  @override
  ConsumerState<VisitPlannerView> createState() => VisitPlannerViewState();
}

class VisitPlannerViewState extends ConsumerState<VisitPlannerView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<VisitScheduleModel> _visits = [];
  bool _loading = true;
  String? _purposeFilter;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1)
        .subtract(const Duration(days: 7));
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0)
        .add(const Duration(days: 7));
    try {
      final visits = await ref.read(offlineVisitRepositoryProvider).list(
            from: firstDay,
            to: lastDay,
          );
      if (!mounted) return;
      setState(() {
        _visits = visits;
        _loading = false;
      });
      if (mounted) await refreshVisitReminders(context, ref);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<VisitScheduleModel> get _filtered => _visits
      .where((v) =>
          (_purposeFilter == null || v.purpose == _purposeFilter) &&
          (_statusFilter == null || v.status == _statusFilter))
      .toList();

  List<VisitScheduleModel> _visitsOn(DateTime day) => _filtered.where((v) {
        final when = v.scheduledDate;
        return when != null &&
            when.year == day.year &&
            when.month == day.month &&
            when.day == day.day;
      }).toList();

  static String _timeOf(String iso) {
    final when = DateTime.tryParse(iso);
    if (when == null) return '';
    return '${when.hour.toString().padLeft(2, '0')}:${when.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openVisit(VisitScheduleModel visit) async {
    final changed = await showVisitDetailSheet(context, ref, visit);
    if (changed == true) await _load();
  }

  Future<void> newVisit({VisitPrefill? prefill}) async {
    final saved = await showVisitFormSheet(context, ref,
        prefill: prefill ?? VisitPrefill(scheduledAt: _selectedDay.copyWith(hour: 9, minute: 0)));
    if (saved == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dayVisits = _visitsOn(_selectedDay);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsetsDirectional.all(12),
        children: [
          // Purpose legend doubles as the filter.
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final purpose in VisitScheduleModel.purposes)
                FilterChip(
                  avatar: Icon(Icons.circle, size: 10, color: visitPurposeColor(context, purpose)),
                  label: Text(visitPurposeLabel(l10n, purpose)),
                  selected: _purposeFilter == purpose,
                  onSelected: (on) => setState(() => _purposeFilter = on ? purpose : null),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: [
              for (final status in VisitScheduleModel.statuses)
                FilterChip(
                  label: Text(localizedStatusLabel(context, status)),
                  selected: _statusFilter == status,
                  onSelected: (on) => setState(() => _statusFilter = on ? status : null),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Card(
            child: TableCalendar<VisitScheduleModel>(
              locale: Localizations.localeOf(context).toString(),
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              eventLoader: _visitsOn,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              onDaySelected: (selected, focused) => setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              }),
              onPageChanged: (focused) {
                _focusedDay = focused;
                _load();
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return null;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final visit in events.take(3))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.5),
                          child: Icon(Icons.circle,
                              size: 6, color: visitPurposeColor(context, visit.purpose)),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          const SizedBox(height: 8),

          SectionHeader(
            title: formatAppDate(_selectedDay.toIso8601String()),
            actionLabel: l10n.planNewVisit,
            onAction: newVisit,
          ),
          if (dayVisits.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(child: Text(l10n.planNoVisits)),
            ),
          for (final visit in dayVisits)
            Card(
              child: ListTile(
                leading: Icon(Icons.circle, size: 12, color: visitPurposeColor(context, visit.purpose)),
                title: Text(visit.customerName ?? visitPurposeLabel(l10n, visit.purpose)),
                subtitle: Text(
                  '${_timeOf(visit.scheduledAt)} · ${visitPurposeLabel(l10n, visit.purpose)}',
                ),
                trailing: Wrap(
                  spacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusChip(label: visit.status),
                    if (visit.isLocalOnly) const StatusChip(label: 'pending sync'),
                  ],
                ),
                onTap: () => _openVisit(visit),
              ),
            ),

          const SizedBox(height: 8),
          SectionHeader(
            title: l10n.planCollectionCandidates,
            actionLabel: l10n.commonViewAll,
            onAction: () => context.push('/plan/candidates'),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
