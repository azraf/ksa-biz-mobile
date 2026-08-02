import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:l10n/l10n.dart';

import 'package:maps_ui/maps_ui.dart';
import 'package:media/media.dart';

import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/repositories.dart';

class WatchlistListScreen extends ConsumerStatefulWidget {
  const WatchlistListScreen({super.key});

  @override
  ConsumerState<WatchlistListScreen> createState() => _WatchlistListScreenState();
}

class _WatchlistListScreenState extends ConsumerState<WatchlistListScreen> {
  bool _loading = true;
  String? _error;
  bool _missingSalesPerson = false;
  List<WatchlistItemModel> _items = [];
  String _status = 'active';
  bool _sortByDistance = false;
  Position? _position;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final spId = requireSalesPersonId(ref.read(authProvider));
    if (spId == null) {
      setState(() {
        _loading = false;
        _missingSalesPerson = true;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _missingSalesPerson = false;
    });
    try {
      final items = await ref.read(offlineWatchlistRepositoryProvider).listLocalAndRemote(
            salesPersonId: spId,
            status: _status,
          );
      Position? pos;
      if (_sortByDistance && await AppPermissions.requestLocation()) {
        try {
          pos = await Geolocator.getCurrentPosition();
        } catch (_) {}
      }
      if (_sortByDistance && pos != null) {
        items.sort((a, b) {
          final da = GpsParser.distanceMeters(pos!.latitude, pos.longitude, a.gps) ?? double.infinity;
          final db = GpsParser.distanceMeters(pos.latitude, pos.longitude, b.gps) ?? double.infinity;
          return da.compareTo(db);
        });
      }
      setState(() {
        _items = items;
        _position = pos;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _openMap() {
    final l10n = AppLocalizations.of(context);
    final pins = _items.map(MapPin.tryFromWatchlistItem).whereType<MapPin>().toList();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LocationMapScreen(
          title: l10n.salesWatchlistMap,
          pins: pins,
          initialFilter: MapLayerFilter.watchlist,
          onPinTap: (pin) => context.push('/watchlist/${pin.id}'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/watchlist/create'),
        icon: const Icon(Icons.add_location_alt),
        label: Text(l10n.salesWatchlistAddLocation),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: Row(
              children: [
                if (_items.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.map_outlined),
                    tooltip: l10n.salesWatchlistViewMap,
                    onPressed: _openMap,
                  ),
                IconButton(
                  icon: Icon(_sortByDistance ? Icons.near_me : Icons.near_me_outlined),
                  tooltip: l10n.salesWatchlistSortDistance,
                  onPressed: () {
                    setState(() => _sortByDistance = !_sortByDistance);
                    _load();
                  },
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  initialValue: _status,
                  onSelected: (v) {
                    setState(() => _status = v);
                    _load();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'active', child: Text(l10n.salesWatchlistActive)),
                    PopupMenuItem(value: 'archived', child: Text(l10n.salesWatchlistArchived)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? LoadingView(message: l10n.salesWatchlistLoading)
                : _missingSalesPerson
                    ? ErrorView(message: l10n.salesSelectSalespersonFirst, onRetry: _load)
                    : _error != null
                        ? ErrorView(message: _error!, onRetry: _load)
                        : _items.isEmpty
                            ? EmptyView(message: l10n.salesWatchlistEmpty)
                            : RefreshIndicator(
                                onRefresh: _load,
                                child: ListView.builder(
                                  padding: fabScrollPadding(context, extendedFab: true),
                                  itemCount: _items.length,
                                  itemBuilder: (_, i) {
                                    final item = _items[i];
                                    final dist = _position != null
                                        ? GpsParser.distanceMeters(
                                            _position!.latitude, _position!.longitude, item.gps)
                                        : null;
                                    return ListTile(
                                      leading: item.isLocalOnly
                                          ? const Icon(Icons.cloud_off, color: Colors.orange)
                                          : const Icon(Icons.place),
                                      title: Text(item.displayTitle),
                                      subtitle: Text(
                                        [
                                          if (dist != null) '${(dist / 1000).toStringAsFixed(1)} km',
                                          item.noteText ?? item.gps,
                                        ].where((s) => s.isNotEmpty).join(' · '),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (item.images.length + item.recordings.length > 0)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 4),
                                              child: Icon(
                                                Icons.perm_media,
                                                size: 18,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                          const Icon(Icons.chevron_right),
                                        ],
                                      ),
                                      onTap: () => context.push('/watchlist/${item.id}'),
                                    );
                                  },
                                ),
                              ),
          ),
        ],
      ),
    );
  }
}

class WatchlistCreateScreen extends ConsumerStatefulWidget {
  const WatchlistCreateScreen({super.key});

  @override
  ConsumerState<WatchlistCreateScreen> createState() => _WatchlistCreateScreenState();
}

class _WatchlistCreateScreenState extends ConsumerState<WatchlistCreateScreen> {
  final _noteController = TextEditingController();
  final _placeController = TextEditingController();
  final _recorder = AudioRecorder();
  final _picker = ImagePicker();
  String? _gps;
  bool _working = false;
  bool _isRecording = false;
  DateTime? _recordStartedAt;
  final List<File> _pendingPhotos = [];
  File? _pendingAudio;

  @override
  void initState() {
    super.initState();
    _captureGps();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _placeController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _captureGps() async {
    if (!await AppPermissions.requestLocation()) return;
    if (!await Geolocator.isLocationServiceEnabled()) return;
    final pos = await Geolocator.getCurrentPosition();
    final gps = '${pos.latitude},${pos.longitude}';
    setState(() => _gps = gps);
    if (ref.read(onlineStatusProvider)) {
      final name = await reverseGeocode(pos.latitude, pos.longitude);
      if (name != null && mounted) _placeController.text = name;
    }
  }

  Future<void> _attachPendingMedia(WatchlistItemModel item) async {
    final facade = ref.read(mediaCaptureFacadeProvider);
    final localId = item.isLocalOnly ? item.id : null;
    for (final photo in _pendingPhotos) {
      await facade.attachWatchlistGallery(photo, item.id, localId: localId);
    }
    if (_pendingAudio != null) {
      final duration = _recordStartedAt != null
          ? DateTime.now().difference(_recordStartedAt!).inSeconds.clamp(1, 180)
          : 1;
      await facade.attachWatchlistAudio(
        _pendingAudio!,
        item.id,
        localId: localId,
        durationSeconds: duration,
      );
    }
  }

  Future<void> _save() async {
    final spId = requireSalesPersonId(ref.read(authProvider));
    if (spId == null || _gps == null) return;
    setState(() => _working = true);
    try {
      final repo = ref.read(offlineWatchlistRepositoryProvider);
      final item = await repo.create(
        gps: _gps!,
        salesPersonId: spId,
        placeName: _placeController.text.trim().isEmpty ? null : _placeController.text.trim(),
        noteText: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );
      if (_pendingPhotos.isNotEmpty || _pendingAudio != null) {
        await _attachPendingMedia(item);
      }
      AppHaptics.success();
      if (mounted) context.go('/watchlist/${item.id}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppErrorMapper.localize(context, e))),
        );
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _toggleRecord() async {
    if (_isRecording) {
      final started = _recordStartedAt;
      final path = await _recorder.stop();
      setState(() => _isRecording = false);
      if (path == null) return;
      setState(() {
        _pendingAudio = File(path);
        _recordStartedAt = started;
      });
      return;
    }
    if (!await AppPermissions.requestMicrophone()) return;
    _recordStartedAt = DateTime.now();
    await _recorder.start(
      const RecordConfig(),
      path: '${Directory.systemTemp.path}/wl_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    setState(() => _isRecording = true);
  }

  Future<void> _pickPhoto() async {
    if (!await AppPermissions.requestCamera()) return;
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    setState(() => _pendingPhotos.add(File(photo.path)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GpsLocationRow(
          gps: _gps,
          notCapturedLabel: l10n.commonGpsCapturing,
          trailing: GpsCaptureActions(
            gps: _gps,
            captureLabel: l10n.commonGpsRefresh,
            onGpsChanged: (value) async {
              setState(() => _gps = value);
              if (value != null) {
                final parsed = GpsParser.parseGps(value);
                if (parsed != null && ref.read(onlineStatusProvider)) {
                  final name = await reverseGeocode(parsed.lat, parsed.lng);
                  if (name != null && mounted) _placeController.text = name;
                }
              }
            },
          ),
        ),
        TextField(
          controller: _placeController,
          decoration: InputDecoration(labelText: l10n.salesWatchlistPlaceName, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _noteController,
          maxLines: 3,
          decoration: InputDecoration(labelText: l10n.salesWatchlistNoteOptional, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _toggleRecord,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? l10n.commonStop : l10n.commonVoice),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _pickPhoto,
              icon: const Icon(Icons.photo_camera),
              label: Text(l10n.commonPhoto),
            ),
          ],
        ),
        if (_pendingAudio != null || _pendingPhotos.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (_pendingAudio != null)
                Chip(
                  avatar: const Icon(Icons.mic, size: 18),
                  label: Text(l10n.salesWatchlistVoiceNotes),
                  onDeleted: () => setState(() {
                    _pendingAudio = null;
                    _recordStartedAt = null;
                  }),
                ),
              ..._pendingPhotos.asMap().entries.map(
                    (e) => Chip(
                      avatar: const Icon(Icons.photo, size: 18),
                      label: Text('${l10n.commonPhoto} ${e.key + 1}'),
                      onDeleted: () => setState(() => _pendingPhotos.removeAt(e.key)),
                    ),
                  ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _working || _gps == null ? null : _save,
          child: _working
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.salesWatchlistSaveLocation),
        ),
      ],
    );
  }
}

class WatchlistDetailScreen extends ConsumerStatefulWidget {
  const WatchlistDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<WatchlistDetailScreen> createState() => _WatchlistDetailScreenState();
}

class _WatchlistDetailScreenState extends ConsumerState<WatchlistDetailScreen> {
  WatchlistItemModel? _item;
  List<LocalMediaAttachment> _pendingMedia = const [];
  bool _loading = true;
  String? _error;
  bool _working = false;
  bool _isRecording = false;
  DateTime? _recordStartedAt;
  final _recorder = AudioRecorder();
  final _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int? _priorityRating;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      WatchlistItemModel item;
      if (widget.id < 0) {
        item = await ref.read(offlineWatchlistRepositoryProvider).get(widget.id) ??
            (throw Exception('Not found'));
      } else {
        item = await ref.read(offlineWatchlistRepositoryProvider).get(widget.id) ??
            await ref.read(watchlistRepositoryProvider).get(widget.id);
      }
      final pending = await loadWatchlistPendingMedia(
        ref.read(offlineStoresProvider).media,
        item,
      );
      _nameController.text = item.placeName ?? '';
      setState(() {
        _item = item;
        _pendingMedia = pending;
        _loading = false;
      });
      _checkProximity(item);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _checkProximity(WatchlistItemModel item) async {
    if (!item.isActive || !ref.read(onlineStatusProvider)) return;
    try {
      if (!await AppPermissions.requestLocation()) return;
      final pos = await Geolocator.getCurrentPosition();
      final dist = GpsParser.distanceMeters(pos.latitude, pos.longitude, item.gps);
      if (dist == null) return;
      if (dist <= 200 && mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("You're at this location — convert to shop?"),
            action: SnackBarAction(label: l10n.commonConvert, onPressed: _convert),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _activate() async {
    if (_item == null) return;
    setState(() => _working = true);
    try {
      await ref.read(offlineWatchlistRepositoryProvider).update(_item!.id, {
        'status': 'active',
        'archived_reason': null,
      });
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).salesWatchlistActivated)),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _archive(String reason) async {
    if (_item == null) return;
    setState(() => _working = true);
    try {
      await ref.read(offlineWatchlistRepositoryProvider).update(_item!.id, {
        'status': 'archived',
        'archived_reason': reason,
      });
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _delete() async {
    if (_item == null) return;
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.salesWatchlistDeleteTitle),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.commonDelete)),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(offlineWatchlistRepositoryProvider).delete(_item!.id);
    if (mounted) context.pop();
  }

  Future<void> _convert() async {
    if (_item == null || _item!.id < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).salesWatchlistSyncBeforeConvert)),
      );
      return;
    }
    final l10n = AppLocalizations.of(context);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.salesWatchlistConvertTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.salesWatchlistShopName)),
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: l10n.commonPhone)),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _priorityRating,
              decoration: InputDecoration(labelText: l10n.salesWatchlistPriorityRating),
              items: List.generate(5, (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1} stars'))),
              onChanged: (v) => setState(() => _priorityRating = v),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, _nameController.text.trim()),
            child: Text(l10n.commonConvert),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    setState(() => _working = true);
    try {
      await ref.read(watchlistRepositoryProvider).convertToShop(
            _item!.id,
            name: name,
            contactMobile: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
            priorityRating: _priorityRating,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesWatchlistShopCreated)));
        context.pop();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _uploadVoice() async {
    if (_item == null) return;
    if (_isRecording) {
      final started = _recordStartedAt;
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _recordStartedAt = null;
      });
      if (path == null) return;
      final duration = DateTime.now().difference(started ?? DateTime.now()).inSeconds.clamp(1, 180);
      await ref.read(mediaCaptureFacadeProvider).attachWatchlistAudio(
            File(path),
            _item!.id,
            localId: _item!.isLocalOnly ? _item!.id : null,
            durationSeconds: duration,
          );
      await _load();
      return;
    }
    if (!await AppPermissions.requestMicrophone()) return;
    _recordStartedAt = DateTime.now();
    await _recorder.start(const RecordConfig(), path: '${Directory.systemTemp.path}/wl_${DateTime.now().millisecondsSinceEpoch}.m4a');
    setState(() => _isRecording = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).salesWatchlistRecordingHint)),
      );
    }
  }

  Future<void> _uploadPhoto() async {
    if (_item == null) return;
    if (!await AppPermissions.requestCamera()) return;
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    await ref.read(mediaCaptureFacadeProvider).attachWatchlistGallery(
          File(photo.path),
          _item!.id,
          localId: _item!.isLocalOnly ? _item!.id : null,
        );
    await _load();
  }

  Future<void> _openMaps() async {
    final item = _item;
    if (item == null) return;
    await MapsLauncher.openDirectionsFromGps(item.gps, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) return LoadingView(message: l10n.commonLoading);
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);
    final item = _item!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _openMaps,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Directions'),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'delete') {
                  _delete();
                } else {
                  _archive(v);
                }
              },
              itemBuilder: (_) => [
                if (item.isActive) ...[
                  PopupMenuItem(value: 'visited', child: Text(l10n.salesWatchlistMarkVisited)),
                  PopupMenuItem(value: 'dismissed', child: Text(l10n.salesWatchlistDismiss)),
                ],
                PopupMenuItem(value: 'delete', child: Text(l10n.commonDelete)),
              ],
            ),
          ],
        ),
        if (item.isLocalOnly)
          Card(child: ListTile(leading: const Icon(Icons.cloud_off), title: Text(l10n.salesWatchlistPendingSync))),
        if (!item.isActive)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Chip(
              avatar: const Icon(Icons.archive_outlined, size: 18),
              label: Text(
                item.archivedReason != null
                    ? l10n.salesWatchlistArchivedReason(item.archivedReason!)
                    : l10n.salesWatchlistArchived,
              ),
            ),
          ),
        GpsLocationRow(gps: item.gps),
        if (item.noteText != null) ...[
          const SizedBox(height: 12),
          Text(item.noteText!),
        ],
        const SizedBox(height: 12),
        MediaGallerySection(
          remoteItems: [...item.images, ...item.recordings],
          localItems: _pendingMedia,
          title: l10n.salesWatchlistPhotos,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _working ? null : _uploadVoice,
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? l10n.commonStop : l10n.commonVoice),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _working ? null : _uploadPhoto,
              icon: const Icon(Icons.photo_camera),
              label: Text(l10n.commonPhoto),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (item.isActive)
          FilledButton(onPressed: _working ? null : _convert, child: Text(l10n.salesWatchlistConvertBtn))
        else ...[
          FilledButton(
            onPressed: _working ? null : _activate,
            child: Text(l10n.salesWatchlistActivateAgain),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _working ? null : _delete,
            style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: Text(l10n.salesWatchlistRemove),
          ),
        ],
      ],
    );
  }
}

/// Quick-save from dashboard.
Future<void> quickSaveWatchlistLocation(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final spId = requireSalesPersonId(ref.read(authProvider));
  if (spId == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.salesSelectSalespersonFirst)));
    return;
  }
  if (!await AppPermissions.requestLocation()) return;
  if (!await Geolocator.isLocationServiceEnabled()) return;
  final pos = await Geolocator.getCurrentPosition();
  String? placeName;
  if (ref.read(onlineStatusProvider)) {
    placeName = await reverseGeocode(pos.latitude, pos.longitude);
    if (context.mounted && placeName != null) {
      final nearby = await ref.read(watchlistRepositoryProvider).nearby(
            lat: pos.latitude,
            lng: pos.longitude,
            salesPersonId: spId,
          );
      final shops = (nearby['shops'] as List?) ?? [];
      final wl = (nearby['watchlist'] as List?) ?? [];
      if (shops.isNotEmpty || wl.isNotEmpty) {
        final msg = shops.isNotEmpty
            ? l10n.salesNearbyShop(shops.first['name'] as String, '${shops.first['distance_m']}')
            : l10n.salesDuplicateWatchlist('${wl.first['distance_m']}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }
  final item = await ref.read(offlineWatchlistRepositoryProvider).create(
        gps: '${pos.latitude},${pos.longitude}',
        salesPersonId: spId,
        placeName: placeName,
      );
  if (!context.mounted) return;
  AppHaptics.success();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.salesLocationSaved),
      action: SnackBarAction(
        label: l10n.salesAddNotesAction,
        onPressed: () => context.push('/watchlist/${item.id}'),
      ),
    ),
  );
}
