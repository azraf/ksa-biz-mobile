import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:l10n/l10n.dart';

import '../../providers/repositories.dart';
import 'visit_form_sheet.dart';

/// Shops that owe money with no visit already planned — one tap books the
/// collection round. Online-first: the dues tab already covers the offline
/// due list. ponytail: no report_cache pass; add if field feedback asks.
class CollectionCandidatesScreen extends ConsumerStatefulWidget {
  const CollectionCandidatesScreen({super.key});

  @override
  ConsumerState<CollectionCandidatesScreen> createState() => _CollectionCandidatesScreenState();
}

class _CollectionCandidatesScreenState extends ConsumerState<CollectionCandidatesScreen> {
  List<CollectionCandidate> _candidates = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = await ref.read(visitScheduleRepositoryProvider).collectionCandidates();
      if (!mounted) return;
      setState(() {
        _candidates = rows;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _planVisit(CollectionCandidate candidate) async {
    final saved = await showVisitFormSheet(
      context,
      ref,
      prefill: VisitPrefill(
        customerType: 'customer_shop',
        customerId: candidate.shopId,
        customerName: candidate.name,
        purpose: 'due_collection',
        scheduledAt: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 9, minute: 0),
      ),
    );
    if (saved == true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currency = NumberFormat.currency(symbol: 'SAR ', decimalDigits: 0);

    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.planCollectionCandidates)),
      body: _candidates.isEmpty
          ? EmptyView(message: l10n.planNoVisits)
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsetsDirectional.all(12),
                itemCount: _candidates.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final candidate = _candidates[index];
                  return Card(
                    child: ListTile(
                      title: Text(candidate.name),
                      subtitle: Text([
                        if (candidate.area != null) candidate.area!,
                        if (candidate.oldestDueDate != null)
                          '${l10n.commonDueDate}: ${formatAppDate(candidate.oldestDueDate)}',
                      ].join(' · ')),
                      trailing: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            currency.format(candidate.due),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: candidate.overdue > 0 ? AppColors.danger(context) : null,
                            ),
                          ),
                          FilledButton.tonal(
                            onPressed: () => _planVisit(candidate),
                            child: Text(l10n.planPlanVisit),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
