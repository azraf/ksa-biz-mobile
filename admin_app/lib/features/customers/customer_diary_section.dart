import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';
import 'package:media/media.dart';
import 'package:record/record.dart';

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
  final _recorder = AudioRecorder();
  DateTime? _recordStartedAt;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await ref.read(customerDiaryRepositoryProvider).list(
            customerType: widget.customerType,
            customerId: widget.customerId,
          );
      setState(() {
        _notes = result.items;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _addText() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final body = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.commonDiaryNote),
        content: TextField(controller: controller, maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    );
    if (body == null || body.isEmpty) return;
    await ref.read(customerDiaryRepositoryProvider).create(
          customerType: widget.customerType,
          customerId: widget.customerId,
          noteType: 'text',
          body: body,
        );
    await _load();
  }

  Future<void> _addVoice() async {
    if (!await ensureStorageForCapture(context)) return;
    if (!await AppPermissions.requestMicrophone()) return;
    final path = '${Directory.systemTemp.path}/diary_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _recordStartedAt = DateTime.now();
    await _recorder.start(const RecordConfig(), path: path);
    final stop = await showDialog<bool>(
      context: context,
      builder: (ctx) => _RecordingDialog(
        onStop: () => Navigator.pop(ctx, true),
        maxSeconds: 180,
        startedAt: _recordStartedAt!,
      ),
    );
    final started = _recordStartedAt;
    _recordStartedAt = null;
    await _recorder.stop();
    if (stop != true) return;
    final duration = DateTime.now().difference(started ?? DateTime.now()).inSeconds.clamp(1, 180);
    final note = await ref.read(customerDiaryRepositoryProvider).create(
          customerType: widget.customerType,
          customerId: widget.customerId,
          noteType: 'voice',
        );
    final compressed = await MediaCompressionService().finalizeAudio(path, entityType: 'diary');
    final bytes = await File(compressed.localPath).readAsBytes();
    await ref.read(customerDiaryRepositoryProvider).uploadRecording(
          note.id,
          bytes,
          'recording.m4a',
          durationSeconds: duration,
        );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDiaryPanel(
      notes: _notes,
      loading: _loading,
      onAddText: _addText,
      onAddVoice: _addVoice,
    );
  }
}

class _RecordingDialog extends StatefulWidget {
  const _RecordingDialog({
    required this.onStop,
    required this.maxSeconds,
    required this.startedAt,
  });

  final VoidCallback onStop;
  final int maxSeconds;
  final DateTime startedAt;

  @override
  State<_RecordingDialog> createState() => _RecordingDialogState();
}

class _RecordingDialogState extends State<_RecordingDialog> {
  @override
  void initState() {
    super.initState();
    _tick();
  }

  Future<void> _tick() async {
    while (mounted) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      final elapsed = DateTime.now().difference(widget.startedAt).inSeconds;
      if (elapsed >= widget.maxSeconds) {
        widget.onStop();
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final elapsed = DateTime.now().difference(widget.startedAt).inSeconds;
    final remaining = (widget.maxSeconds - elapsed).clamp(0, widget.maxSeconds);
    return AlertDialog(
      title: Text(l10n.commonRecordingTitle),
      content: Text('${remaining}s remaining (max ${widget.maxSeconds ~/ 60} min)'),
      actions: [
        FilledButton(onPressed: widget.onStop, child: Text(l10n.commonStopAndSave)),
      ],
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
              initialValue: paymentOverride,
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
