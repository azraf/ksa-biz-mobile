import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaVideoPlayer extends StatefulWidget {
  const MediaVideoPlayer({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  State<MediaVideoPlayer> createState() => _MediaVideoPlayerState();
}

class _MediaVideoPlayerState extends State<MediaVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final video = VideoPlayerController.networkUrl(Uri.parse(widget.url));
      await video.initialize();
      final chewie = ChewieController(
        videoPlayerController: video,
        autoInitialize: true,
        autoPlay: false,
        looping: false,
      );
      if (mounted) {
        setState(() {
          _videoController = video;
          _chewieController = chewie;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ListTile(
        leading: const Icon(Icons.videocam_off_outlined),
        title: Text(widget.title ?? 'Video'),
        subtitle: Text(_error!, maxLines: 2),
      );
    }
    if (_chewieController == null) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(widget.title!, style: Theme.of(context).textTheme.titleSmall),
        ),
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
      ],
    );
  }
}
