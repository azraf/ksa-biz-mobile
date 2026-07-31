import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MediaAudioPlayer extends StatefulWidget {
  const MediaAudioPlayer({
    super.key,
    required this.url,
    this.title,
  });

  final String url;
  final String? title;

  @override
  State<MediaAudioPlayer> createState() => _MediaAudioPlayerState();
}

class _MediaAudioPlayerState extends State<MediaAudioPlayer> {
  late final AudioPlayer _player;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.url);
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ListTile(
        leading: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        title: Text('Loading audio…'),
      );
    }
    if (_error != null) {
      return ListTile(
        leading: const Icon(Icons.error_outline),
        title: Text(widget.title ?? 'Audio'),
        subtitle: Text(_error!, maxLines: 2),
      );
    }
    return ListTile(
      leading: StreamBuilder<PlayerState>(
        stream: _player.playerStateStream,
        builder: (context, snapshot) {
          final playing = snapshot.data?.playing ?? false;
          return IconButton(
            icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
            onPressed: () {
              if (playing) {
                _player.pause();
              } else {
                _player.play();
              }
            },
          );
        },
      ),
      title: Text(widget.title ?? 'Audio recording'),
      subtitle: StreamBuilder<Duration?>(
        stream: _player.positionStream,
        builder: (context, snapshot) {
          final pos = snapshot.data ?? Duration.zero;
          final dur = _player.duration ?? Duration.zero;
          return Text('${pos.inMinutes}:${(pos.inSeconds % 60).toString().padLeft(2, '0')} / '
              '${dur.inMinutes}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}');
        },
      ),
    );
  }
}
