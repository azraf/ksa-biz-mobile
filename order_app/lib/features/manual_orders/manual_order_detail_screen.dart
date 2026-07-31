import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media/media.dart';
import 'package:path/path.dart' as p;
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

  Future<void> _uploadFile(File file, String filename, {required String recordingType}) async {
    setState(() => _working = true);
    try {
      final facade = ref.read(mediaCaptureFacadeProvider);
      final compressed = await facade.compressManualOrderRecording(file, recordingType);
      final bytes = await File(compressed.localPath).readAsBytes();
      final updated = await ref.read(manualOrderRepositoryProvider).uploadRecording(
            widget.id,
            bytes: bytes,
            filename: p.basename(compressed.localPath),
            recordingType: recordingType,
          );
      setState(() {
        _request = updated;
        _working = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recording uploaded')));
      }
    } catch (e) {
      setState(() => _working = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _toggleAudioRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() => _isRecording = false);
      if (path != null) {
        await _uploadFile(File(path), 'recording.m4a', recordingType: 'recording_audio');
      }
      return;
    }
    if (!await AppPermissions.requestMicrophone()) return;
    final path = '${Directory.systemTemp.path}/order_manual_${widget.id}_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000), path: path);
    setState(() => _isRecording = true);
  }

  Future<void> _recordVideo() async {
    if (!await AppPermissions.requestCamera()) return;
    if (!await AppPermissions.requestMicrophone()) return;
    final video = await _picker.pickVideo(source: ImageSource.camera);
    if (video == null) return;
    await _uploadFile(File(video.path), video.name, recordingType: 'recording_video');
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final request = _request!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text(request.customerShop?.name ?? 'Shop #${request.customerShopId}'),
          subtitle: Text('Request #${request.id} · ${request.status}'),
          trailing: StatusChip(label: request.status),
        ),
        if (request.notes != null && request.notes!.isNotEmpty)
          ListTile(title: const Text('Notes'), subtitle: Text(request.notes!)),
        if (request.recordings.isNotEmpty) ...[
          const SizedBox(height: 8),
          MediaGallerySection(remoteItems: request.recordings, title: 'Recordings'),
        ],
        const SizedBox(height: 12),
        Text('Add recording', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: _working ? null : _toggleAudioRecording,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? 'Stop & upload' : 'Record audio'),
            ),
            OutlinedButton.icon(
              onPressed: _working ? null : _recordVideo,
              icon: const Icon(Icons.videocam_outlined),
              label: const Text('Record video'),
            ),
          ],
        ),
      ],
    );
  }
}
