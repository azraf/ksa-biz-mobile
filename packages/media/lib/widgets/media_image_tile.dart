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
    this.title,
    this.enableViewer = true,
  });

  final String? url;
  final String? localPath;
  final double height;
  final BoxFit fit;
  final String? title;
  final bool enableViewer;

  bool get _hasImage =>
      (localPath != null && File(localPath!).existsSync()) ||
      (url != null && url!.isNotEmpty);

  void _openViewer(BuildContext context) {
    if (!enableViewer || !_hasImage) return;
    showMediaImageViewer(context, url: url, localPath: localPath, title: title);
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildImage();
    if (!enableViewer || !_hasImage) return child;
    return GestureDetector(
      onTap: () => _openViewer(context),
      child: child,
    );
  }

  Widget _buildImage() {
    if (localPath != null && File(localPath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(File(localPath!), height: height, width: double.infinity, fit: fit),
      );
    }
    if (url != null && url!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: url!,
          height: height,
          width: double.infinity,
          fit: fit,
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
    return SizedBox(
      height: height,
      child: const Center(child: Icon(Icons.image_not_supported_outlined)),
    );
  }
}
