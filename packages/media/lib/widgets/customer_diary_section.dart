import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l10n/l10n.dart';
import 'package:record/record.dart';

import '../media_capture_facade.dart';
import 'media_audio_player.dart';
import 'media_gallery_section.dart';

/// The one diary section used by customer detail (sales + admin), the diary
/// bottom sheet and order detail. Constructor-injected repositories keep it
/// riverpod-free; it lives in the media package because it records audio,
/// picks photos/video and plays recordings — none of which core may depend on.
///
/// Text notes queue offline; photo/voice/video notes queue offline too — the
/// note row syncs first and its media follows through the media_blobs queue.
class CustomerDiarySection extends StatefulWidget {
  const CustomerDiarySection({
    super.key,
    required this.customerType,
    required this.customerId,
    this.orderId,
    required this.diaryRepository,
    required this.mediaCaptureFacade,
    this.salesPersonId,
    this.maxRecordingSeconds = 180,
    this.videoMaxSizeMb = 50,
  });

  final String customerType;
  final int customerId;

  /// When set, the section shows and creates order-scoped notes.
  final int? orderId;
  final OfflineDiaryRepository diaryRepository;
  final MediaCaptureFacade mediaCaptureFacade;
  final int? salesPersonId;
  final int maxRecordingSeconds;
  final int videoMaxSizeMb;

  @override
  State<CustomerDiarySection> createState() => _CustomerDiarySectionState();
}

class _CustomerDiarySectionState extends State<CustomerDiarySection> {
  List<CustomerDiaryNoteModel> _notes = [];
  bool _loading = true;
  final _recorder = AudioRecorder();
  final _picker = ImagePicker();
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
      final notes = await widget.diaryRepository.list(
        customerType: widget.customerType,
        customerId: widget.customerId,
        orderId: widget.orderId,
      );
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<CustomerDiaryNoteModel> _createNote(String noteType, {String? body}) {
    return widget.diaryRepository.createNote(
      customerType: widget.customerType,
      customerId: widget.customerId,
      noteType: noteType,
      body: body,
      orderId: widget.orderId,
      salesPersonId: widget.salesPersonId,
    );
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
    await _createNote('text', body: body);
    await _load();
  }

  Future<void> _addVoice() async {
    if (!await ensureStorageForCapture(context)) return;
    if (!await AppPermissions.requestMicrophone()) return;
    final path = '${Directory.systemTemp.path}/diary_${DateTime.now().millisecondsSinceEpoch}.m4a';
    _recordStartedAt = DateTime.now();
    await _recorder.start(const RecordConfig(), path: path);
    if (!mounted) return;
    final stop = await showDialog<bool>(
      context: context,
      builder: (ctx) => _RecordingDialog(
        onStop: () => Navigator.pop(ctx, true),
        maxSeconds: widget.maxRecordingSeconds,
        startedAt: _recordStartedAt!,
      ),
    );
    final started = _recordStartedAt;
    _recordStartedAt = null;
    await _recorder.stop();
    if (stop != true) return;
    final duration = DateTime.now()
        .difference(started ?? DateTime.now())
        .inSeconds
        .clamp(1, widget.maxRecordingSeconds);

    final note = await _createNote('voice');
    await widget.mediaCaptureFacade.attachDiaryRecording(
      File(path),
      note.id,
      localId: note.isLocalOnly ? note.id : null,
      durationSeconds: duration,
    );
    await _load();
  }

  Future<void> _addPhoto() async {
    if (!await ensureStorageForCapture(context)) return;
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;

    final note = await _createNote('photo');
    await widget.mediaCaptureFacade.attachDiaryPhoto(
      File(photo.path),
      note.id,
      localId: note.isLocalOnly ? note.id : null,
    );
    await _load();
  }

  Future<void> _addVideo() async {
    if (!await ensureStorageForCapture(context)) return;
    final video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: Duration(seconds: widget.maxRecordingSeconds),
    );
    if (video == null) return;

    final size = await File(video.path).length();
    if (size > widget.videoMaxSizeMb * 1024 * 1024) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context).commonVideoTooLarge(widget.videoMaxSizeMb)),
        ));
      }
      return;
    }

    final note = await _createNote('video');
    await widget.mediaCaptureFacade.attachDiaryRecording(
      File(video.path),
      note.id,
      localId: note.isLocalOnly ? note.id : null,
      isVideo: true,
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CustomerDiaryPanel(
      notes: _notes,
      loading: _loading,
      onAddText: _addText,
      onAddVoice: _addVoice,
      extraActions: [
        IconButton(
          onPressed: _addPhoto,
          icon: const Icon(Icons.photo_camera_outlined, size: 20),
          tooltip: l10n.commonPhoto,
        ),
        IconButton(
          onPressed: _addVideo,
          icon: const Icon(Icons.videocam_outlined, size: 20),
          tooltip: l10n.commonVideo,
        ),
      ],
      voicePlayerBuilder: (context, note) => MediaAudioPlayer(url: note.recording!.url!),
      attachmentsBuilder: (context, note) =>
          MediaGallerySection(remoteItems: note.attachments, title: ''),
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
