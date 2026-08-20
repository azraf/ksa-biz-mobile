import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaViewerItem {
  const MediaViewerItem({this.url, this.localPath});

  final String? url;
  final String? localPath;
}

/// Full-screen, zoomable image viewer with prev/next arrows and swipe.
class MediaImageViewer extends StatefulWidget {
  const MediaImageViewer({super.key, required this.items, this.initialIndex = 0});

  final List<MediaViewerItem> items;
  final int initialIndex;

  static void open(BuildContext context, List<MediaViewerItem> items,
      {int initialIndex = 0}) {
    if (items.isEmpty) return;
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => MediaImageViewer(items: items, initialIndex: initialIndex),
    ));
  }

  @override
  State<MediaImageViewer> createState() => _MediaImageViewerState();
}

class _MediaImageViewerState extends State<MediaImageViewer> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    _controller.animateToPage(
      _index + delta,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Widget _image(MediaViewerItem item) {
    // Full-resolution decode on purpose — no cacheHeight/memCacheHeight here.
    if (item.localPath != null && File(item.localPath!).existsSync()) {
      return Image.file(File(item.localPath!), fit: BoxFit.contain);
    }
    if (item.url != null && item.url!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: item.url!,
        fit: BoxFit.contain,
        placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        errorWidget: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.white, size: 48),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.image_not_supported_outlined, color: Colors.white, size: 48),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.items.length;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: count > 1 ? Text('${_index + 1} / $count') : null,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) => InteractiveViewer(
              maxScale: 5,
              child: Center(child: _image(widget.items[i])),
            ),
          ),
          if (_index > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 36),
                onPressed: () => _go(-1),
              ),
            ),
          if (_index < count - 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 36),
                onPressed: () => _go(1),
              ),
            ),
        ],
      ),
    );
  }
}
