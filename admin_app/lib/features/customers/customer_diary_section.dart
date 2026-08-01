import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';

class CustomerDiarySection extends ConsumerStatefulWidget {
  const CustomerDiarySection({
    super.key,
    required this.customerType,
    required this.customerId,
  });

  final String customerType;
  final int customerId;

  @override
  ConsumerState<CustomerDiarySection> createState() => _CustomerDiarySectionState();
}

class _CustomerDiarySectionState extends ConsumerState<CustomerDiarySection> {
  List<CustomerDiaryNoteModel> _notes = [];
  bool _loading = true;
  Object? _error;

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
      final notes = await ref.read(offlineDiaryRepositoryProvider).list(
            customerType: widget.customerType,
            customerId: widget.customerId,
          );
      setState(() {
        _notes = notes;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  Future<void> _addText() async {
    final controller = TextEditingController();
    final body = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add diary note'),
        content: TextField(controller: controller, maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (body == null || body.isEmpty) return;
    try {
      await ref.read(offlineDiaryRepositoryProvider).createText(
            customerType: widget.customerType,
            customerId: widget.customerId,
            body: body,
          );
      ref.invalidate(pendingSyncCountProvider);
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null && !_loading && _notes.isEmpty) {
      return ErrorView(
        message: AppErrorMapper.localize(context, _error!),
        error: _error,
        onRetry: _load,
      );
    }

    return CustomerDiaryPanel(
      notes: _notes,
      loading: _loading,
      onAddText: _addText,
    );
  }
}

class CustomerRatingSection extends StatelessWidget {
  const CustomerRatingSection({
    super.key,
    required this.priorityRating,
    required this.paymentOverride,
    required this.metrics,
    required this.onPriorityChanged,
    required this.onPaymentOverrideChanged,
  });

  final int? priorityRating;
  final String? paymentOverride;
  final CustomerMetricsFields metrics;
  final ValueChanged<int?> onPriorityChanged;
  final ValueChanged<String?> onPaymentOverrideChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rating & frequency', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (i) {
                final star = i + 1;
                return IconButton(
                  icon: Icon(star <= (priorityRating ?? 0) ? Icons.star : Icons.star_border),
                  color: Colors.amber.shade700,
                  onPressed: () => onPriorityChanged(star),
                );
              }),
            ),
            CustomerMetricsBadges(metrics: metrics),
            const SizedBox(height: 8),
            DropdownButtonFormField<String?>(
              value: paymentOverride,
              decoration: const InputDecoration(labelText: 'Payment reliability override'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Auto')),
                DropdownMenuItem(value: 'good', child: Text('Good')),
                DropdownMenuItem(value: 'fair', child: Text('Fair')),
                DropdownMenuItem(value: 'poor', child: Text('Poor')),
              ],
              onChanged: onPaymentOverrideChanged,
            ),
          ],
        ),
      ),
    );
  }
}
