import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../dues/dues_screen.dart';
import 'visit_planner_view.dart';

/// The Plan tab: the visit planner plus the dues worklist it grew out of.
/// Dues stays one tap away here (and the dashboard KPI deep-links to it), so
/// swapping the old Dues tab for Plan loses nothing.
class PlanHubScreen extends StatefulWidget {
  const PlanHubScreen({super.key, this.initialTab});

  /// 'dues' opens the dues segment (used by the /dues redirect).
  final String? initialTab;

  @override
  State<PlanHubScreen> createState() => _PlanHubScreenState();
}

class _PlanHubScreenState extends State<PlanHubScreen> {
  late bool _showDues = widget.initialTab == 'dues';

  /// The dues deep link re-uses the mounted hub once the tab was opened;
  /// re-apply the requested segment when the link changes.
  @override
  void didUpdateWidget(PlanHubScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      setState(() => _showDues = widget.initialTab == 'dues');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment(
                value: false,
                icon: const Icon(Icons.event_note_outlined),
                label: Text(l10n.planTabVisits),
              ),
              ButtonSegment(
                value: true,
                icon: const Icon(Icons.payments_outlined),
                label: Text(l10n.planTabDues),
              ),
            ],
            selected: {_showDues},
            onSelectionChanged: (selection) => setState(() => _showDues = selection.first),
          ),
        ),
        Expanded(
          child: _showDues ? const DuesScreen() : const VisitPlannerView(),
        ),
      ],
    );
  }
}
