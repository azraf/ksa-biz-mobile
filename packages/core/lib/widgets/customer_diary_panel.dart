import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../models/customer_diary_note.dart';
import '../utils/contact_launcher.dart';
import '../utils/format_helpers.dart';

/// Builds a widget for a note (in-app audio player, photo/video gallery).
/// Injected because core cannot depend on the media package.
typedef DiaryNoteWidgetBuilder = Widget Function(BuildContext context, CustomerDiaryNoteModel note);

class CustomerDiaryPanel extends StatelessWidget {
  const CustomerDiaryPanel({
    super.key,
    required this.notes,
    required this.loading,
    required this.onAddText,
    this.onAddVoice,
    this.onLoadMore,
    this.hasMore = false,
    this.voicePlayerBuilder,
    this.attachmentsBuilder,
    this.extraActions,
  });

  final List<CustomerDiaryNoteModel> notes;
  final bool loading;
  final VoidCallback onAddText;
  final VoidCallback? onAddVoice;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  /// When set, voice notes expand an inline player instead of launching the
  /// URL in an external browser.
  final DiaryNoteWidgetBuilder? voicePlayerBuilder;

  /// Renders photo/video attachments beneath the note body.
  final DiaryNoteWidgetBuilder? attachmentsBuilder;

  /// Extra header buttons (photo/video capture) supplied by the caller.
  final List<Widget>? extraActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(l10n.commonDiary, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddText,
                  icon: const Icon(Icons.note_add_outlined, size: 18),
                  label: Text(l10n.commonDiaryText),
                ),
                if (onAddVoice != null)
                  TextButton.icon(
                    onPressed: onAddVoice,
                    icon: const Icon(Icons.mic_none, size: 18),
                    label: Text(l10n.commonVoice),
                  ),
                ...?extraActions,
              ],
            ),
            if (loading) const LinearProgressIndicator(),
            if (!loading && notes.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(l10n.commonDiaryEmpty),
              ),
            ...notes.map((n) => _DiaryTile(
                  note: n,
                  voicePlayerBuilder: voicePlayerBuilder,
                  attachmentsBuilder: attachmentsBuilder,
                )),
            if (hasMore && onLoadMore != null)
              TextButton(onPressed: onLoadMore, child: Text(l10n.commonDiaryLoadMore)),
          ],
        ),
      ),
    );
  }
}

class _DiaryTile extends StatefulWidget {
  const _DiaryTile({required this.note, this.voicePlayerBuilder, this.attachmentsBuilder});

  final CustomerDiaryNoteModel note;
  final DiaryNoteWidgetBuilder? voicePlayerBuilder;
  final DiaryNoteWidgetBuilder? attachmentsBuilder;

  @override
  State<_DiaryTile> createState() => _DiaryTileState();
}

class _DiaryTileState extends State<_DiaryTile> {
  // Player mounts on demand so long lists don't open an audio session per note.
  bool _playerVisible = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final note = widget.note;
    final dateLabel = note.createdAt != null ? formatAppDateTime(note.createdAt) : '';

    Widget? voice;
    if (note.isVoice) {
      if (_playerVisible && widget.voicePlayerBuilder != null) {
        voice = widget.voicePlayerBuilder!(context, note);
      } else {
        voice = TextButton.icon(
          onPressed: note.recording?.url == null
              ? null
              : () {
                  if (widget.voicePlayerBuilder != null) {
                    setState(() => _playerVisible = true);
                  } else {
                    // No in-app player supplied — legacy external fallback.
                    ContactLauncher.openUrl(note.recording!.url!);
                  }
                },
          icon: const Icon(Icons.play_arrow),
          label: Text(l10n.commonDiaryPlayVoice),
        );
      }
    }

    final attachments = note.attachments.isNotEmpty && widget.attachmentsBuilder != null
        ? widget.attachmentsBuilder!(context, note)
        : null;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('$dateLabel · ${note.authorName}', style: Theme.of(context).textTheme.bodySmall),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.body != null && note.body!.isNotEmpty) Text(note.body!),
          if (voice != null) voice,
          if (attachments != null) attachments,
        ],
      ),
    );
  }
}
