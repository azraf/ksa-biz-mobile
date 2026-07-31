import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:l10n/l10n.dart';

import 'package:media/media.dart';

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

class _CustomerDiarySheet extends ConsumerStatefulWidget {
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
  ConsumerState<_CustomerDiarySheet> createState() => _CustomerDiarySheetState();
}

class _CustomerDiarySheetState extends ConsumerState<_CustomerDiarySheet> {
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
      final notes = await ref.read(offlineDiaryRepositoryProvider).list(
            customerType: widget.customerType,
            customerId: widget.customerId,
          );
      setState(() {
        _notes = notes;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _addText() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final body = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.commonDiaryNote),
        content: TextField(controller: controller, maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (body == null || body.isEmpty) return;
    final spId = requireSalesPersonId(ref.read(authProvider));
    await ref.read(offlineDiaryRepositoryProvider).createText(
          customerType: widget.customerType,
          customerId: widget.customerId,
          body: body,
          salesPersonId: spId,
        );
    await _load();
  }

  Future<void> _addVoice() async {
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
    final spId = requireSalesPersonId(ref.read(authProvider));
    final note = await ref.read(customerDiaryRepositoryProvider).create(
          customerType: widget.customerType,
          customerId: widget.customerId,
          noteType: 'voice',
          salesPersonId: spId,
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
    final l10n = AppLocalizations.of(context);

    return Material(
      child: ListView(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.commonDiaryTitle(widget.customerName), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          CustomerDiaryPanel(
            notes: _notes,
            loading: _loading,
            onAddText: _addText,
            onAddVoice: _addVoice,
          ),
        ],
      ),
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
