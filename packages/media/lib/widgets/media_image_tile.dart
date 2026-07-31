import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaImageTile extends StatelessWidget {
  const MediaImageTile({
    super.key,
    this.url,
    this.localPath,
    this.height = 120,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final String? localPath;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
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
