import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:l10n/l10n.dart';
import 'package:media/media.dart';
import 'package:record/record.dart';

import '../../providers/repositories.dart';

class ManualOrderDetailScreen extends ConsumerStatefulWidget {
  const ManualOrderDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<ManualOrderDetailScreen> createState() => _ManualOrderDetailScreenState();
}

class _ManualOrderDetailScreenState extends ConsumerState<ManualOrderDetailScreen> {
  ManualOrderRequestModel? _request;
  bool _loading = true;
  String? _error;
  bool _working = false;
  final _recorder = AudioRecorder();
  final _picker = ImagePicker();
  bool _isRecording = false;

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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final request = await ref.read(manualOrderRepositoryProvider).get(widget.id);
      setState(() {
        _request = request;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _attach(Future<void> Function(MediaCaptureFacade facade) action) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _working = true);
    try {
      await action(ref.read(mediaCaptureFacadeProvider));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.commonRecordingUploaded)),
        );
      }
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _addPhoto(ImageSource source) async {
    if (source == ImageSource.camera && !await AppPermissions.requestCamera()) return;
    final image = await _picker.pickImage(source: source);
    if (image == null) return;
    await _attach((f) => f.attachManualOrderPhoto(File(image.path), widget.id));
  }

  Future<void> _toggleAudioRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        await _attach((f) => f.attachManualOrderMedia(File(path), widget.id));
      }
      return;
    }
    if (!await AppPermissions.requestMicrophone()) return;
    final path =
        '${Directory.systemTemp.path}/order_manual_${widget.id}_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000), path: path);
    setState(() => _isRecording = true);
  }

  Future<void> _recordVideo() async {
    if (!await AppPermissions.requestCamera()) return;
    if (!await AppPermissions.requestMicrophone()) return;
    final video = await _picker.pickVideo(source: ImageSource.camera);
    if (video == null) return;
    await _attach((f) => f.attachManualOrderMedia(File(video.path), widget.id, isVideo: true));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final request = _request!;
    final media = request.allMedia;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text(
            request.customerName ?? l10n.commonShopFallback(request.customerShopId ?? request.id),
          ),
          subtitle: Text(
            '${l10n.commonRequestNumber(request.id)} · ${localizedStatusLabel(context, request.status)}',
          ),
          trailing: StatusChip(label: request.status),
        ),
        if (request.notes != null && request.notes!.isNotEmpty)
          ListTile(title: Text(l10n.commonNotes), subtitle: Text(request.notes!)),
        if (request.linkedOrders.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(l10n.orderManualLinkedOrders, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: request.linkedOrders
                .map((o) => Chip(
                      avatar: const Icon(Icons.receipt_long_outlined, size: 18),
                      label: Text('#${o.id} · ${localizedStatusLabel(context, o.status)}'),
                    ))
                .toList(),
          ),
        ],
        if (media.isNotEmpty) ...[
          const SizedBox(height: 8),
          MediaGallerySection(remoteItems: media, title: l10n.commonRecordings),
        ],
        if (request.isEditable) ...[
          const SizedBox(height: 12),
          Text(l10n.commonAddRecording, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _working ? null : () => _addPhoto(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(l10n.commonPhoto),
              ),
              OutlinedButton.icon(
                onPressed: _working ? null : () => _addPhoto(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(l10n.orderManualGallery),
              ),
              OutlinedButton.icon(
                onPressed: _working ? null : _toggleAudioRecording,
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                label: Text(_isRecording ? l10n.commonStopAndUpload : l10n.commonRecordAudio),
              ),
              OutlinedButton.icon(
                onPressed: _working ? null : _recordVideo,
                icon: const Icon(Icons.videocam_outlined),
                label: Text(l10n.commonRecordVideo),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
