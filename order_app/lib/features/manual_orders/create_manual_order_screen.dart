import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l10n/l10n.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';

import '../../providers/customer_context_provider.dart';
import '../../providers/repositories.dart';

class _StagedMedia {
  const _StagedMedia(this.file, this.kind, {this.durationSeconds});

  final File file;
  final String kind; // photo | video | audio
  final int? durationSeconds;

  IconData get icon => switch (kind) {
        'photo' => Icons.photo_outlined,
        'video' => Icons.videocam_outlined,
        _ => Icons.mic_outlined,
      };
}

/// Compose screen: note + staged media, submitted together. Works for all
/// customer types (server derives the customer from the login) and offline
/// (request + media ride the sync queue).
class CreateManualOrderScreen extends ConsumerStatefulWidget {
  const CreateManualOrderScreen({super.key});

  @override
  ConsumerState<CreateManualOrderScreen> createState() => _CreateManualOrderScreenState();
}

class _CreateManualOrderScreenState extends ConsumerState<CreateManualOrderScreen> {
  final _notesController = TextEditingController();
  final _picker = ImagePicker();
  final _recorder = AudioRecorder();
  final List<_StagedMedia> _staged = [];
  bool _submitting = false;
  bool _isRecording = false;
  DateTime? _recordingStartedAt;

  @override
  void dispose() {
    _notesController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(ImageSource source) async {
    if (source == ImageSource.camera && !await AppPermissions.requestCamera()) return;
    final image = await _picker.pickImage(source: source);
    if (image == null) return;
    setState(() => _staged.add(_StagedMedia(File(image.path), 'photo')));
  }

  Future<void> _recordVideo() async {
    if (!await AppPermissions.requestCamera()) return;
    if (!await AppPermissions.requestMicrophone()) return;
    final video = await _picker.pickVideo(source: ImageSource.camera);
    if (video == null) return;
    setState(() => _staged.add(_StagedMedia(File(video.path), 'video')));
  }

  Future<void> _toggleAudioRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      final startedAt = _recordingStartedAt;
      setState(() => _isRecording = false);
      if (path != null) {
        final duration = startedAt == null
            ? null
            : DateTime.now().difference(startedAt).inSeconds.clamp(1, 180);
        setState(() => _staged.add(
              _StagedMedia(File(path), 'audio', durationSeconds: duration),
            ));
      }
      return;
    }
    if (!await AppPermissions.requestMicrophone()) return;
    final path =
        '${Directory.systemTemp.path}/order_instruction_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: path,
    );
    setState(() {
      _isRecording = true;
      _recordingStartedAt = DateTime.now();
    });
  }

  Future<void> _attachStaged(int requestId, {int? localId}) async {
    final facade = ref.read(mediaCaptureFacadeProvider);
    for (final item in _staged) {
      if (item.kind == 'photo') {
        await facade.attachManualOrderPhoto(item.file, requestId, localId: localId);
      } else {
        await facade.attachManualOrderMedia(
          item.file,
          requestId,
          localId: localId,
          isVideo: item.kind == 'video',
          durationSeconds: item.durationSeconds,
        );
      }
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final notes = _notesController.text.trim();
    if (notes.isEmpty && _staged.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.orderManualNoteOrMediaRequired)),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      if (ref.read(connectivityServiceProvider).isOnline) {
        final request = await ref.read(manualOrderRepositoryProvider).create(
              notes: notes,
              clientRequestId: generateClientRequestId(),
            );
        await _attachStaged(request.id);
        if (mounted) context.go('/manual-orders/${request.id}');
        return;
      }

      // Offline: queue the request, key media to the local id.
      final localId = -DateTime.now().millisecondsSinceEpoch;
      await ref.read(localDatabaseProvider).enqueue(SyncQueueItem(
            id: 0,
            entityType: 'manual_order',
            operation: 'create',
            localId: localId,
            payload: {
              'notes': notes,
              'client_request_id': generateClientRequestId(),
            },
            status: 'pending',
            retryCount: 0,
            createdAt: DateTime.now().toIso8601String(),
          ));
      await _attachStaged(localId, localId: localId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.orderManualQueuedOffline)),
        );
        context.go('/manual-orders');
      }
    } catch (e) {
      setState(() => _submitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(customerContextProvider).profile;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (profile != null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.storefront),
              title: Text(profile.displayName),
              subtitle: Text(l10n.commonManualOrderRequest),
            ),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          decoration: InputDecoration(
            labelText: l10n.commonOrderNotes,
            hintText: l10n.commonOrderNotesHint,
            alignLabelWithHint: true,
          ),
          maxLines: 6,
        ),
        const SizedBox(height: 16),
        Text(l10n.orderManualAddMedia, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: _submitting ? null : () => _pickPhoto(ImageSource.camera),
              icon: const Icon(Icons.photo_camera_outlined),
              label: Text(l10n.commonPhoto),
            ),
            OutlinedButton.icon(
              onPressed: _submitting ? null : () => _pickPhoto(ImageSource.gallery),
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(l10n.orderManualGallery),
            ),
            OutlinedButton.icon(
              onPressed: _submitting ? null : _recordVideo,
              icon: const Icon(Icons.videocam_outlined),
              label: Text(l10n.commonRecordVideo),
            ),
            OutlinedButton.icon(
              onPressed: _submitting ? null : _toggleAudioRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? l10n.commonStopAndUpload : l10n.commonRecordAudio),
            ),
          ],
        ),
        if (_staged.isNotEmpty) ...[
          const SizedBox(height: 12),
          ..._staged.asMap().entries.map(
                (entry) => ListTile(
                  dense: true,
                  leading: Icon(entry.value.icon),
                  title: Text(p.basename(entry.value.file.path)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _submitting
                        ? null
                        : () => setState(() => _staged.removeAt(entry.key)),
                  ),
                ),
              ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _submitting || _isRecording ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.commonSubmitRequest),
        ),
      ],
    );
  }
}
