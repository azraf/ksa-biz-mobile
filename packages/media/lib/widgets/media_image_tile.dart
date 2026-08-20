import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'media_image_viewer.dart';

class MediaImageTile extends StatelessWidget {
  const MediaImageTile({
    super.key,
    this.url,
    this.localPath,
    this.height = 120,
    this.fit = BoxFit.cover,
    this.tapToView = true,
    this.gallery,
    this.galleryIndex = 0,
  });

  final String? url;
  final String? localPath;
  final double height;
  final BoxFit fit;

  /// Tap opens a full-screen viewer. Set false when the tile sits inside an
  /// already-tappable row (e.g. a ListTile leading).
  final bool tapToView;

  /// Sibling images for prev/next navigation in the viewer; falls back to
  /// just this tile's image when null.
  final List<MediaViewerItem>? gallery;
  final int galleryIndex;

  @override
  Widget build(BuildContext context) {
    // Decode at display size (not full camera resolution) — big memory/jank win.
    final decodeHeight = (height * MediaQuery.devicePixelRatioOf(context)).round();
    Widget? tile;
    if (localPath != null && File(localPath!).existsSync()) {
      tile = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(localPath!),
          height: height,
          width: double.infinity,
          fit: fit,
          cacheHeight: decodeHeight,
        ),
      );
    } else if (url != null && url!.isNotEmpty) {
      tile = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: url!,
          height: height,
          width: double.infinity,
          fit: fit,
          memCacheHeight: decodeHeight,
          placeholder: (_, __) => SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (_, __, ___) => SizedBox(
            height: height,
            child: const Center(child: Icon(Icons.broken_image_outlined)),
          ),
        ),
      );
    }
    if (tile == null) {
      return SizedBox(
        height: height,
        child: const Center(child: Icon(Icons.image_not_supported_outlined)),
      );
    }
    if (!tapToView) return tile;
    return GestureDetector(
      onTap: () => MediaImageViewer.open(
        context,
        gallery ?? [MediaViewerItem(url: url, localPath: localPath)],
        initialIndex: gallery != null ? galleryIndex : 0,
      ),
      child: tile,
    );
  }
}
