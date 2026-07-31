import 'package:flutter/material.dart';

class NoteCaptureSheet extends StatefulWidget {
  const NoteCaptureSheet({
    super.key,
    this.initialText,
    this.showImages = false,
    this.onSaveText,
    this.onRecordVoice,
    this.onPickImage,
  });

  final String? initialText;
  final bool showImages;
  final Future<void> Function(String text)? onSaveText;
  final Future<void> Function()? onRecordVoice;
  final Future<void> Function()? onPickImage;

  @override
  State<NoteCaptureSheet> createState() => _NoteCaptureSheetState();
}

class _NoteCaptureSheetState extends State<NoteCaptureSheet> {
  late final _controller = TextEditingController(text: widget.initialText);
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (widget.onSaveText == null) return;
    setState(() => _saving = true);
    try {
      await widget.onSaveText!(_controller.text.trim());
      if (mounted) Navigator.pop(context, true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Add note', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Text note',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.onRecordVoice != null)
                OutlinedButton.icon(
                  onPressed: _saving
                      ? null
                      : () async {
                          setState(() => _saving = true);
                          try {
                            await widget.onRecordVoice!();
                            if (mounted) Navigator.pop(context, true);
                          } finally {
                            if (mounted) setState(() => _saving = false);
                          }
                        },
                  icon: const Icon(Icons.mic),
                  label: const Text('Voice'),
                ),
              if (widget.showImages && widget.onPickImage != null) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _saving ? null : widget.onPickImage,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Photo'),
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: _saving || widget.onSaveText == null ? null : _save,
                child: _saving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<bool?> showNoteCaptureSheet({
  required BuildContext context,
  String? initialText,
  bool showImages = false,
  Future<void> Function(String text)? onSaveText,
  Future<void> Function()? onRecordVoice,
  Future<void> Function()? onPickImage,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => NoteCaptureSheet(
      initialText: initialText,
      showImages: showImages,
      onSaveText: onSaveText,
      onRecordVoice: onRecordVoice,
      onPickImage: onPickImage,
    ),
  );
}
