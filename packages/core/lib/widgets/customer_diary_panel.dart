import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/customer_diary_note.dart';
import '../utils/contact_launcher.dart';

class CustomerDiaryPanel extends StatelessWidget {
  const CustomerDiaryPanel({
    super.key,
    required this.notes,
    required this.loading,
    required this.onAddText,
    this.onAddVoice,
    this.onLoadMore,
    this.hasMore = false,
  });

  final List<CustomerDiaryNoteModel> notes;
  final bool loading;
  final VoidCallback onAddText;
  final VoidCallback? onAddVoice;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Diary', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                TextButton.icon(
                  onPressed: onAddText,
                  icon: const Icon(Icons.note_add_outlined, size: 18),
                  label: const Text('Text'),
                ),
                if (onAddVoice != null)
                  TextButton.icon(
                    onPressed: onAddVoice,
                    icon: const Icon(Icons.mic_none, size: 18),
                    label: const Text('Voice'),
                  ),
              ],
            ),
            if (loading) const LinearProgressIndicator(),
            if (!loading && notes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('No diary entries yet.'),
              ),
            ...notes.map((n) => _DiaryTile(note: n)),
            if (hasMore && onLoadMore != null)
              TextButton(onPressed: onLoadMore, child: const Text('Load more')),
          ],
        ),
      ),
    );
  }
}

class _DiaryTile extends StatelessWidget {
  const _DiaryTile({required this.note});

  final CustomerDiaryNoteModel note;

  @override
  Widget build(BuildContext context) {
    final date = note.createdAt != null ? DateTime.tryParse(note.createdAt!) : null;
    final dateLabel = date != null ? DateFormat('d MMM y, HH:mm').format(date.toLocal()) : '';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('$dateLabel · ${note.authorName}', style: Theme.of(context).textTheme.bodySmall),
      subtitle: note.isVoice
          ? TextButton.icon(
              onPressed: note.recording?.url != null
                  ? () => ContactLauncher.openUrl(note.recording!.url!)
                  : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play voice note'),
            )
          : Text(note.body ?? ''),
    );
  }
}
