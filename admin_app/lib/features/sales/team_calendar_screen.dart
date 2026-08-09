import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../providers/repositories.dart';

/// Read-only team calendar: every salesperson's visit schedule with a
/// per-salesperson compliance strip (planned/done/missed for the month).
/// Online-only — admins monitor from connectivity, no offline cache.
class TeamCalendarScreen extends ConsumerStatefulWidget {
  const TeamCalendarScreen({super.key});

  @override
  ConsumerState<TeamCalendarScreen> createState() => _TeamCalendarScreenState();
}

class _TeamCalendarScreenState extends ConsumerState<TeamCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<VisitScheduleModel> _visits = [];
  List<VisitSummaryRow> _summary = [];
  List<SalesPersonModel> _salesPersons = [];
  int? _salesPersonFilter;
  String? _purposeFilter;
  String? _statusFilter;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    try {
      final repo = ref.read(visitScheduleRepositoryProvider);
      final visits = await repo.list(
        from: _date(firstDay.subtract(const Duration(days: 7))),
        to: _date(lastDay.add(const Duration(days: 7))),
        salesPersonId: _salesPersonFilter,
      );
      final summary = await repo.summary(
        from: _date(firstDay),
        to: _date(lastDay),
      );
      if (_salesPersons.isEmpty) {
        _salesPersons =
            (await ref.read(customerRepositoryProvider).salesPersons()).items;
      }
      if (!mounted) return;
      setState(() {
        _visits = visits.items;
        _summary = summary;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
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

  void _showVisit(VisitScheduleModel visit) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(visit.customerName ?? visitPurposeLabel(l10n, visit.purpose)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Salesperson: ${visit.salesPersonName ?? '#${visit.salesPersonId}'}'),
            Text('When: ${formatAppDateTime(visit.scheduledAt)}'),
            Text('Purpose: ${visitPurposeLabel(l10n, visit.purpose)}'),
            Text('Status: ${localizedStatusLabel(context, visit.status)}'),
            if (visit.durationMinutes != null)
              Text('Duration: ${visit.durationMinutes} min'),
            if (visit.notes != null && visit.notes!.isNotEmpty)
              Text('Notes: ${visit.notes}'),
            if (visit.outcomeNote != null && visit.outcomeNote!.isNotEmpty)
              Text('Outcome: ${visit.outcomeNote}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dayVisits = _visitsOn(_selectedDay);

    return Scaffold(
      appBar: AppBar(title: const Text('Team calendar')),
      body: _error != null && _visits.isEmpty
          ? ErrorView(message: _error!, onRetry: _load)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsetsDirectional.all(12),
                children: [
                  // Compliance strip — tap a card to focus that salesperson.
                  if (_summary.isNotEmpty)
                    SizedBox(
                      height: 86,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final row in _summary)
                            Padding(
                              padding: const EdgeInsetsDirectional.only(end: 8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  setState(() => _salesPersonFilter =
                                      _salesPersonFilter == row.salesPersonId
                                          ? null
                                          : row.salesPersonId);
                                  _load();
                                },
                                child: Container(
                                  width: 168,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _salesPersonFilter == row.salesPersonId
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.outlineVariant,
                                      width: _salesPersonFilter == row.salesPersonId ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        row.name ?? '#${row.salesPersonId}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${row.planned} planned · ${row.done} done'
                                        '${row.missed > 0 ? ' · ${row.missed} missed' : ''}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Salesperson dropdown (all + individual).
                  DropdownButtonFormField<int?>(
                    initialValue: _salesPersonFilter,
                    decoration: const InputDecoration(
                      labelText: 'Salesperson',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem<int?>(child: Text('All salespersons')),
                      for (final sp in _salesPersons)
                        DropdownMenuItem<int?>(value: sp.id, child: Text(sp.name)),
                    ],
                    onChanged: (value) {
                      setState(() => _salesPersonFilter = value);
                      _load();
                    },
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final purpose in VisitScheduleModel.purposes)
                        FilterChip(
                          avatar: Icon(Icons.circle,
                              size: 10, color: visitPurposeColor(context, purpose)),
                          label: Text(visitPurposeLabel(l10n, purpose)),
                          selected: _purposeFilter == purpose,
                          onSelected: (on) =>
                              setState(() => _purposeFilter = on ? purpose : null),
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
                          onSelected: (on) =>
                              setState(() => _statusFilter = on ? status : null),
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
                                      size: 6,
                                      color: visitPurposeColor(context, visit.purpose)),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  if (_loading) const LinearProgressIndicator(),
                  const SizedBox(height: 8),

                  SectionHeader(title: formatAppDate(_selectedDay.toIso8601String())),
                  if (dayVisits.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('No visits on this day')),
                    ),
                  for (final visit in dayVisits)
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.circle,
                            size: 12, color: visitPurposeColor(context, visit.purpose)),
                        title: Text(
                          visit.customerName ?? visitPurposeLabel(l10n, visit.purpose),
                        ),
                        subtitle: Text(
                          '${_timeOf(visit.scheduledAt)} · ${visit.salesPersonName ?? ''}'
                          ' · ${visitPurposeLabel(l10n, visit.purpose)}',
                        ),
                        trailing: StatusChip(label: visit.status),
                        onTap: () => _showVisit(visit),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
