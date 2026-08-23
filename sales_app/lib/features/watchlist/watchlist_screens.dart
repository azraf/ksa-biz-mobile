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

import '../plan/visit_form_sheet.dart';

import '../../providers/auth_provider.dart';
import '../../providers/connectivity_provider.dart';
import '../../providers/repositories.dart';

class WatchlistListScreen extends ConsumerStatefulWidget {
  const WatchlistListScreen({super.key});

  @override
  ConsumerState<WatchlistListScreen> createState() => _WatchlistListScreenState();
}

class _WatchlistListScreenState extends ConsumerState<WatchlistListScreen> {
  static const _listKey = 'sales_watchlist';

  bool _loading = true;
  String? _error;
  bool _missingSalesPerson = false;
  List<WatchlistItemModel> _items = [];
  String _status = 'active';
  ListSortMode _sortMode = ListSortMode.date;
  Position? _position;
  final _searchController = TextEditingController();
  bool _isFuzzy = false;

  String get _search => _searchController.text.trim();
  bool get _searching => _search.isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final prefs = ListSortPreference(ref.read(sharedPreferencesProvider));
    _sortMode = prefs.read(_listKey, defaultMode: ListSortMode.date);
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
      final apiSort = _sortMode == ListSortMode.distance
          ? 'created_at'
          : _sortMode.watchlistApiSortParam();
      // A search shows both sections (Active, then Archived) unless the
      // status filter was set explicitly to archived.
      final result = await ref.read(offlineWatchlistRepositoryProvider).searchLocalAndRemote(
            salesPersonId: spId,
            status: _searching && _status == 'active' ? 'all' : _status,
            sort: apiSort,
            search: _searching ? _search : null,
          );
      final items = result.items;
      Position? pos;
      if (_sortMode == ListSortMode.distance && await AppPermissions.requestLocation()) {
        try {
          pos = await Geolocator.getCurrentPosition();
        } catch (_) {}
      }
      var sorted = items;
      if (_searching) {
        // Keep the server's active-first order so sections stay contiguous;
        // re-sort by the chosen mode inside each section only.
        List<WatchlistItemModel> within(List<WatchlistItemModel> part) => _sortMode == ListSortMode.distance
            ? (pos == null
                ? part
                : sortByListMode(part, ListSortMode.distance,
                    distanceMeters: (item) =>
                        GpsParser.distanceMeters(pos!.latitude, pos.longitude, item.gps) ?? double.infinity))
            : sortByListMode(part, _sortMode,
                dateIso: (item) => item.createdAt,
                name: (item) => item.displayTitle,
                salesPerson: (item) => item.salesPerson?.name);
        sorted = [
          ...within(items.where((i) => i.isActive).toList()),
          ...within(items.where((i) => !i.isActive).toList()),
        ];
      } else if (_sortMode == ListSortMode.distance && pos != null) {
        sorted = sortByListMode(
          items,
          ListSortMode.distance,
          distanceMeters: (item) =>
              GpsParser.distanceMeters(pos!.latitude, pos.longitude, item.gps) ?? double.infinity,
        );
      } else if (_sortMode != ListSortMode.distance) {
        sorted = sortByListMode(
          items,
          _sortMode,
          dateIso: (item) => item.createdAt,
          name: (item) => item.displayTitle,
          salesPerson: (item) => item.salesPerson?.name,
        );
      }
      setState(() {
        _items = sorted;
        _isFuzzy = result.isFuzzy;
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
      appBar: AppBar(
        title: Text(l10n.salesWatchlist),
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.map_outlined),
              tooltip: l10n.salesWatchlistViewMap,
              onPressed: _openMap,
            ),
          FiltersDrawerButton(active: _searching || _status != 'active'),
        ],
      ),
      // Search / status / sort live in the drawer so the list gets the full
      // height; the shell's bottom nav is untouched.
      endDrawer: ListFiltersDrawer(
        searchController: _searchController,
        onSearchChanged: (_) => _load(),
        searchHint: l10n.searchWatchlistHint,
        statusOptions: [
          MapEntry('active', l10n.salesWatchlistActive),
          MapEntry('archived', l10n.salesWatchlistArchived),
        ],
        status: _status,
        onStatusChanged: (v) {
          setState(() => _status = v ?? 'active');
          _load();
        },
        sortModes: const [ListSortMode.distance, ListSortMode.date, ListSortMode.name],
        sort: _sortMode,
        onSortChanged: (mode) async {
          _sortMode = mode;
          await ListSortPreference(ref.read(sharedPreferencesProvider)).write(_listKey, mode);
          await _load();
        },
        onClear: () {
          _searchController.clear();
          setState(() => _status = 'active');
          _load();
        },
      ),
      floatingActionButton: TranslucentFab(
        onOpen: () => context.push('/watchlist/create'),
        icon: const Icon(Icons.add_location_alt),
        label: l10n.salesWatchlistAddLocation,
      ),
      body: _loading
          ? LoadingView(message: l10n.salesWatchlistLoading)
          : _missingSalesPerson
              ? ErrorView(message: l10n.salesSelectSalespersonFirst, onRetry: _load)
              : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _items.isEmpty
                  ? EmptyView(
                      message: l10n.salesWatchlistEmpty,
                      actionLabel: l10n.commonAddWatchlistPlace,
                      onAction: () => context.push('/watchlist/create'),
                    )
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: ListView(
                        padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.fabClearance),
                        children: sectionedChildren<WatchlistItemModel>(
                          _items,
                          banner: _searching && _isFuzzy ? FuzzyMatchBanner(query: _search) : null,
                          sectionOf: (item) => _searching
                              ? (item.isActive ? l10n.salesWatchlistActive : l10n.salesWatchlistArchived)
                              : null,
                          itemBuilder: (item) => ListTile(
                            leading: item.isLocalOnly
                                ? Icon(Icons.cloud_off, color: AppColors.warning(context))
                                : const Icon(Icons.place),
                            title: HighlightText(item.displayTitle, query: _searching ? _search : null),
                            subtitle: HighlightText(
                              [
                                if (item.createdAt != null) formatAppDateTime(item.createdAt),
                                if (_position != null && _sortMode == ListSortMode.distance)
                                  '${((GpsParser.distanceMeters(_position!.latitude, _position!.longitude, item.gps) ?? 0) / 1000).toStringAsFixed(1)} km',
                                item.noteText ?? item.gps,
                              ].where((s) => s.isNotEmpty).join(' · '),
                              query: _searching ? _search : null,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push('/watchlist/${item.id}'),
                          ),
                        ),
                      ),
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
  final _phoneController = TextEditingController();
  final _recorder = AudioRecorder();
  final _picker = ImagePicker();
  String? _gps;
  bool _working = false;
  bool _isRecording = false;
  DateTime? _recordStartedAt;

  /// Media captured before saving — uploaded right after create() returns
  /// (queued against the local id when offline).
  final List<({String path, int seconds})> _voices = [];
  final List<XFile> _photos = [];

  @override
  void initState() {
    super.initState();
    _captureGps();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _placeController.dispose();
    _phoneController.dispose();
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
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      );
      final facade = ref.read(mediaCaptureFacadeProvider);
      final localId = item.isLocalOnly ? item.id : null;
      var mediaFailed = false;
      for (final voice in _voices) {
        try {
          await facade.attachWatchlistAudio(
            File(voice.path),
            item.id,
            localId: localId,
            durationSeconds: voice.seconds,
          );
        } catch (_) {
          mediaFailed = true;
        }
      }
      for (final photo in _photos) {
        try {
          await facade.attachWatchlistGallery(File(photo.path), item.id, localId: localId);
        } catch (_) {
          mediaFailed = true;
        }
      }
      if (mediaFailed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).salesWatchlistMediaPartial)),
        );
      }
      if (mounted) context.go('/watchlist/${item.id}');
    } catch (e) {
      if (mounted) showAppErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _toggleRecord() async {
    if (_isRecording) {
      final started = _recordStartedAt;
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        _recordStartedAt = null;
      });
      if (path == null) return;
      final seconds =
          DateTime.now().difference(started ?? DateTime.now()).inSeconds.clamp(1, 180);
      setState(() => _voices.add((path: path, seconds: seconds)));
      return;
    }
    if (!await AppPermissions.requestMicrophone()) return;
    _recordStartedAt = DateTime.now();
    await _recorder.start(const RecordConfig(), path: '${Directory.systemTemp.path}/wl_${DateTime.now().millisecondsSinceEpoch}.m4a');
    setState(() => _isRecording = true);
  }

  Future<void> _takePhoto() async {
    if (!await AppPermissions.requestCamera()) return;
    final photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    setState(() => _photos.add(photo));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.salesWatchlistSaveTitle)),
      body: ListView(
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
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: l10n.commonPhone, border: const OutlineInputBorder()),
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
                onPressed: _takePhoto,
                icon: const Icon(Icons.photo_camera),
                label: Text(l10n.commonPhoto),
              ),
            ],
          ),
          if (_voices.isNotEmpty || _photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var i = 0; i < _voices.length; i++)
                  InputChip(
                    avatar: const Icon(Icons.mic, size: 18),
                    label: Text('${l10n.commonVoice} · ${_voices[i].seconds}s'),
                    onDeleted: () => setState(() => _voices.removeAt(i)),
                  ),
                for (var i = 0; i < _photos.length; i++)
                  InputChip(
                    avatar: const Icon(Icons.photo, size: 18),
                    label: Text('${l10n.commonPhoto} ${i + 1}'),
                    onDeleted: () => setState(() => _photos.removeAt(i)),
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
      ),
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
        final cached = await ref.read(localDatabaseProvider).getCachedEntity('watchlist', widget.id);
        if (cached == null) throw Exception('Not found');
        item = WatchlistItemModel.fromJson(cached);
      } else {
        item = await ref.read(watchlistRepositoryProvider).get(widget.id);
      }
      _nameController.text = item.placeName ?? '';
      _phoneController.text = item.phone ?? '';
      setState(() {
        _item = item;
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
      if (mounted) showAppErrorSnackBar(context, e);
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
      if (mounted) showAppErrorSnackBar(context, e);
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
              initialValue: _priorityRating,
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
      // Drain queued photos/recordings first: conversion copies what is on the
      // server, so anything still in the upload queue would otherwise arrive
      // afterwards. (The server forwards late arrivals too, but flushing here
      // means the new shop's diary is complete the moment it opens.)
      try {
        await ref.read(mediaUploadRepositoryProvider).uploadPendingBlobs();
      } catch (_) {
        // Offline or a flaky upload: convert anyway, the server forwards later.
      }
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
      if (mounted) showAppErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _uploadVoice() async {
    if (_item == null || _item!.id < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).salesWatchlistSyncBeforeUpload)),
      );
      return;
    }
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
    if (_item == null || _item!.id < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).salesWatchlistSyncBeforeUpload)),
      );
      return;
    }
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

    if (_loading) return Scaffold(body: LoadingView(message: l10n.commonLoading));
    if (_error != null) return Scaffold(body: ErrorView(message: _error!, onRetry: _load));
    final item = _item!;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.displayTitle),
        actions: [
          IconButton(icon: const Icon(Icons.map_outlined), onPressed: _openMaps),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
          if (item.phone?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: SelectableText(item.phone!)),
                ContactActionButtons(phoneNumber: item.phone!, compact: true),
              ],
            ),
          ],
          if (item.createdAt != null) ...[
            const SizedBox(height: 8),
            Text(
              formatAppDateTime(item.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (item.noteText != null) ...[
            const SizedBox(height: 12),
            Text(item.noteText!),
          ],
          if (item.recordings.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l10n.salesWatchlistVoiceNotes, style: const TextStyle(fontWeight: FontWeight.bold)),
            ...item.recordings.map(
              (r) => ListTile(
                leading: const Icon(Icons.audiotrack),
                title: Text(r.originalName ?? l10n.commonRecording),
                onTap: r.url != null ? () => ContactLauncher.openUrl(r.url!) : null,
              ),
            ),
          ],
          if (item.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(l10n.salesWatchlistPhotos, style: const TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: item.images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final img = item.images[i];
                  if (img.url == null) return const SizedBox.shrink();
                  final gallery = [
                    for (final m in item.images)
                      if (m.url != null) MediaViewerItem(url: m.url),
                  ];
                  return SizedBox(
                    width: 100,
                    child: MediaImageTile(
                      url: img.url,
                      height: 100,
                      gallery: gallery,
                      galleryIndex: gallery.indexWhere((g) => g.url == img.url),
                    ),
                  );
                },
              ),
            ),
          ],
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
          const SizedBox(height: 8),
          // Prospecting round anchored to this watch-list item; local-only
          // items must sync first (no server id to attach the visit to).
          OutlinedButton.icon(
            onPressed: _working || item.isLocalOnly
                ? null
                : () => showVisitFormSheet(
                      context,
                      ref,
                      prefill: VisitPrefill(
                        watchlistItemId: item.id,
                        customerName: item.placeName,
                        purpose: 'new_client_search',
                      ),
                    ),
            icon: const Icon(Icons.event_outlined),
            label: Text(l10n.planScheduleVisit),
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
      ),
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
