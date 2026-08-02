import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Full-screen image viewer with pinch-to-zoom.
void showMediaImageViewer(
  BuildContext context, {
  String? url,
  String? localPath,
  String? title,
}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _MediaImageViewerPage(
        url: url,
        localPath: localPath,
        title: title,
      ),
    ),
  );
}

class _MediaImageViewerPage extends StatelessWidget {
  const _MediaImageViewerPage({
    this.url,
    this.localPath,
    this.title,
  });

  final String? url;
  final String? localPath;
  final String? title;

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (localPath != null && File(localPath!).existsSync()) {
      image = Image.file(File(localPath!), fit: BoxFit.contain);
    } else if (url != null && url!.isNotEmpty) {
      image = CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.contain,
        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined, size: 48)),
      );
    } else {
      image = const Center(child: Icon(Icons.image_not_supported_outlined, size: 48));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title ?? 'Photo', style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: image,
        ),
      ),
    );
  }
}
