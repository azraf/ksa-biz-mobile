import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media/media.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';

import '../../providers/repositories.dart';

class AdminManualOrderDetailScreen extends ConsumerStatefulWidget {
  const AdminManualOrderDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<AdminManualOrderDetailScreen> createState() => _AdminManualOrderDetailScreenState();
}

class _AdminManualOrderDetailScreenState extends ConsumerState<AdminManualOrderDetailScreen> {
  ManualOrderRequestModel? _request;
  bool _loading = true;
  String? _error;
  bool _working = false;
  final _recorder = AudioRecorder();
  final _picker = ImagePicker();
  bool _isRecording = false;
  String? _recordingPath;

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

  Future<void> _linkOrders() async {
    final request = _request;
    if (request == null) return;
    final updated = await showLinkOrdersSheet(
      context,
      request: request,
      orderRepository: ref.read(orderRepositoryProvider),
      manualOrderRepository: ref.read(manualOrderRepositoryProvider),
    );
    if (updated != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orders linked')),
      );
      await _load();
    }
  }

  Future<void> _pickAndUploadRecording() async {
    if (!await AppPermissions.requestPhotos()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission required to pick recordings.')),
      );
      return;
    }
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;
    await _uploadFile(File(video.path), video.name, recordingType: 'recording_video');
  }

  Future<void> _toggleAudioRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
      if (path != null) {
        await _uploadFile(File(path), 'recording.m4a', recordingType: 'recording_audio');
      }
      return;
    }

    if (!await AppPermissions.requestMicrophone()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }
    final path = '${Directory.systemTemp.path}/manual_order_${widget.id}_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
    setState(() => _isRecording = true);
  }

  Future<void> _recordVideo() async {
    if (!await AppPermissions.requestCamera()) return;
    if (!await AppPermissions.requestMicrophone()) return;
    final video = await _picker.pickVideo(source: ImageSource.camera);
    if (video == null) return;
    await _uploadFile(File(video.path), video.name, recordingType: 'recording_video');
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('Manual #${widget.id}')),
        body: const LoadingView(),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Manual #${widget.id}')),
        body: ErrorView(message: _error!, onRetry: _load),
      );
    }
    final request = _request!;
    final shopPhone = shopContactPhone(request.customerShop);

    return Scaffold(
      appBar: AppBar(title: Text('Manual #${request.id}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(request.customerName ?? 'Request #${request.id}'),
            subtitle: Text('Source: ${request.source}'),
            trailing: StatusChip(label: request.status),
          ),
          if (shopPhone != null) ...[
            const SizedBox(height: 8),
            ContactActionButtons(phoneNumber: shopPhone),
          ],
          if (request.notes != null) ListTile(title: const Text('Notes'), subtitle: Text(request.notes!)),
          if (request.manualReference != null)
            ListTile(title: const Text('Reference'), subtitle: Text(request.manualReference!)),
          if (request.callReference != null)
            ListTile(title: const Text('Call reference'), subtitle: Text(request.callReference!)),
          if (request.allMedia.isNotEmpty) ...[
            const SizedBox(height: 8),
            MediaGallerySection(remoteItems: request.allMedia, title: 'Attachments'),
          ],
          if (request.linkedOrders.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text('Linked orders', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: request.linkedOrders
                  .map((o) => Chip(
                        avatar: const Icon(Icons.receipt_long_outlined, size: 18),
                        label: Text('#${o.id} · ${o.status}'),
                      ))
                  .toList(),
            ),
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
              OutlinedButton.icon(
                onPressed: _working ? null : _pickAndUploadRecording,
                icon: const Icon(Icons.attach_file),
                label: const Text('Pick video'),
              ),
            ],
          ),
          if (_recordingPath != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Last recording: $_recordingPath', style: Theme.of(context).textTheme.bodySmall),
            ),
          if (request.status != 'cancelled') ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _working ? null : _linkOrders,
              icon: const Icon(Icons.link),
              label: const Text('Link to order(s)'),
            ),
          ],
          if (request.isEditable && request.convertedOrderId == null)
            FilledButton(
              onPressed: _working ? null : () async {
                final salesPersons = (await ref.read(customerRepositoryProvider).salesPersons()).items;
                if (salesPersons.isEmpty) return;
                final spId = salesPersons.first.id;
                try {
                  await ref.read(manualOrderRepositoryProvider).convert(widget.id, {
                    'sales_person_id': spId,
                    'payment_status': 'pending',
                    'items': [
                      {'product_id': 1, 'quantity': 1, 'product_price': 0},
                    ],
                  });
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Converted — review order in Sales > Orders')),
                    );
                    await _load();
                  }
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
              },
              child: const Text('Quick convert (default item)'),
            ),
        ],
      ),
    );
  }
}
