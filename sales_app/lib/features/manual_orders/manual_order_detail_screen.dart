import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_ui/maps_ui.dart';
import 'package:media/media.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
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

  Future<void> _claim() async {
    final salesPersonId = requireSalesPersonId(ref.read(authProvider));
    if (salesPersonId == null) return;
    setState(() => _working = true);
    try {
      final updated = await ref.read(manualOrderRepositoryProvider).claim(widget.id, salesPersonId);
      setState(() {
        _request = updated;
        _working = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesManualClaimed)));
      }
    } catch (e) {
      setState(() => _working = false);
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _persistShopGps(String? gps) async {
    final shop = _request?.customerShop;
    if (shop == null) return;

    try {
      final repo = ref.read(customerRepositoryProvider);
      if (gps == null) {
        await repo.clearShopGps(shop.id);
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesManualGpsCleared)));
        }
      } else {
        await repo.updateShopGps(shop.id, gps);
        if (mounted) {
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesManualGpsUpdated(gps))));
        }
      }
      await _load();
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    }
  }

  Future<void> _takeShopPhoto() async {
    final shop = _request?.customerShop;
    if (shop == null) return;
    if (!await AppPermissions.requestCamera()) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.commonCameraPermission)),
      );
      return;
    }
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null || !mounted) return;
    setState(() => _working = true);
    try {
      await ref.read(mediaCaptureFacadeProvider).attachShopPhoto(File(photo.path), shop.id);
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.salesManualShopPhotoUploaded)),
        );
      }
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _pickAndUploadRecording() async {
    if (!await AppPermissions.requestPhotos()) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.commonRecordingPermission)),
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
      setState(() => _isRecording = false);
      if (path != null) {
        await _uploadFile(File(path), 'recording.m4a', recordingType: 'recording_audio');
      }
      return;
    }

    if (!await AppPermissions.requestMicrophone()) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.commonMicrophonePermission)),
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
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.commonOrdersLinked)),
      );
      await _load();
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
            filename: filename.endsWith('.webp') ? filename : p.basename(compressed.localPath),
            recordingType: recordingType,
          );
      setState(() {
        _request = updated;
        _working = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.commonRecordingUploaded)));
      }
    } catch (e) {
      setState(() => _working = false);
      if (mounted) {
        showAppErrorSnackBar(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    final request = _request!;
    final shopPhone = shopContactPhone(request.customerShop);
    final shop = request.customerShop;

    return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(
              request.customerName ?? l10n.commonShopFallback(request.customerShopId ?? request.id),
            ),
            subtitle: Text(l10n.commonSourceLabel(request.source)),
            trailing: StatusChip(label: request.status),
          ),
          if (shopPhone != null) ...[
            const SizedBox(height: 8),
            ContactActionButtons(phoneNumber: shopPhone),
          ],
          if (request.notes != null) ListTile(title: Text(l10n.commonNotes), subtitle: Text(request.notes!)),
          if (request.manualReference != null)
            ListTile(title: Text(l10n.commonReference), subtitle: Text(request.manualReference!)),
          if (request.callReference != null)
            ListTile(title: Text(l10n.commonCallReference), subtitle: Text(request.callReference!)),
          if (request.allMedia.isNotEmpty) ...[
            const SizedBox(height: 8),
            MediaGallerySection(remoteItems: request.allMedia, title: l10n.commonRecordings),
          ],
          if (request.linkedOrders.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(l10n.orderManualLinkedOrders, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: request.linkedOrders
                  .map((o) => ActionChip(
                        avatar: const Icon(Icons.receipt_long_outlined, size: 18),
                        label: Text('#${o.id} · ${localizedStatusLabel(context, o.status)}'),
                        onPressed: () => context.push('/orders/${o.id}'),
                      ))
                  .toList(),
            ),
          ],
          const SizedBox(height: 12),
          if (shop != null) ...[
            GpsLocationRow(
              gps: shop.gps,
              notCapturedLabel: l10n.commonGpsNotCaptured,
              trailing: GpsCaptureActions(
                gps: shop.gps,
                captureLabel: l10n.commonGpsCapture,
                locationRequiredMessage: l10n.commonGpsLocationRequired,
                onGpsChanged: (_) {},
                onImmediatePersist: _persistShopGps,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _takeShopPhoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(l10n.salesManualTakeShopPhoto),
            ),
          ],
          const SizedBox(height: 12),
          Text(l10n.commonAddRecording, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
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
              OutlinedButton.icon(
                onPressed: _working ? null : _pickAndUploadRecording,
                icon: const Icon(Icons.attach_file),
                label: Text(l10n.commonPickVideo),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (request.isEditable && request.status != 'in_review')
            FilledButton(
              onPressed: _working ? null : _claim,
              child: _working ? const CircularProgressIndicator() : Text(l10n.salesManualClaimRequest),
            ),
          if (request.isEditable && (request.status == 'in_review' || request.claimedBySalesPersonId != null))
            FilledButton(
              onPressed: () => context.push('/manual-orders/${request.id}/convert'),
              child: Text(l10n.salesManualConvertOrder),
            ),
          if (request.status != 'cancelled') ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _working ? null : _linkOrders,
              icon: const Icon(Icons.link),
              label: Text(l10n.commonLinkToOrders),
            ),
          ],
          if (request.convertedOrderId != null)
            OutlinedButton(
              onPressed: () => context.push('/orders/${request.convertedOrderId}'),
              child: Text(l10n.salesManualViewConverted),
            ),
        ],
    );
  }
}
