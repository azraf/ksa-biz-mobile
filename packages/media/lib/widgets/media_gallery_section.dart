import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'media_audio_player.dart';
import 'media_image_tile.dart';
import 'media_video_player.dart';

class MediaGallerySection extends StatelessWidget {
  const MediaGallerySection({
    super.key,
    this.remoteItems = const [],
    this.localItems = const [],
    this.title = 'Media',
  });

  final List<MediaModel> remoteItems;
  final List<LocalMediaAttachment> localItems;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (remoteItems.isEmpty && localItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final images = <Widget>[];
    final players = <Widget>[];

    for (final local in localItems) {
      if (local.kind == MediaKind.image) {
        images.add(MediaImageTile(localPath: local.path, height: 100));
      } else if (local.kind == MediaKind.audio) {
        players.add(ListTile(
          leading: const Icon(Icons.audiotrack),
          title: Text(local.originalName ?? 'Pending audio'),
          subtitle: const Text('Pending upload'),
        ));
      } else if (local.kind == MediaKind.video) {
        players.add(ListTile(
          leading: const Icon(Icons.videocam),
          title: Text(local.originalName ?? 'Pending video'),
          subtitle: const Text('Pending upload'),
        ));
      }
    }

    for (final item in remoteItems) {
      if (item.type == 'gallery' || item.mimeType?.startsWith('image/') == true) {
        images.add(MediaImageTile(url: item.url, height: 100));
      } else if (item.isAudio && item.url != null) {
        players.add(MediaAudioPlayer(url: item.url!, title: item.originalName ?? item.type));
      } else if (item.isVideo && item.url != null) {
        players.add(MediaVideoPlayer(url: item.url!, title: item.originalName));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (images.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: images.map((w) => SizedBox(width: 120, child: w)).toList(),
          ),
        ...players,
      ],
    );
  }
}
