import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Floating toolbar shown when text is selected in the reader.
/// Presents highlight colour options and an eraser button.
class HighlightToolbar extends StatelessWidget {
  const HighlightToolbar({
    super.key,
    required this.onColorSelected,
    this.onDelete,
    this.onNoteRequested,
    this.onDictionaryRequested,
    this.showDelete = false,
    this.showNote = false,
  });

  final void Function(String hexColor) onColorSelected;
  final VoidCallback? onDelete;
  final VoidCallback? onNoteRequested;
  final VoidCallback? onDictionaryRequested;
  final bool showDelete;
  final bool showNote;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(24),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < AppColors.highlightColors.length; i++)
              _ColorCircle(
                color: AppColors.highlightColors[i],
                onTap: () =>
                    onColorSelected(AppColors.highlightColorHex[i]),
              ),
            if (onDictionaryRequested != null) ...[
              const SizedBox(width: 4),
              _DictionaryButton(onTap: onDictionaryRequested),
            ],
            if (showNote) ...[
              const SizedBox(width: 4),
              _NoteButton(onTap: onNoteRequested),
            ],
            if (showDelete) ...[
              const SizedBox(width: 4),
              _EraserButton(onTap: onDelete),
            ],
          ],
        ),
      ),
    );
  }
}

class _ColorCircle extends StatelessWidget {
  const _ColorCircle({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
          ),
        ),
      ),
    );
  }
}

class _NoteButton extends StatelessWidget {
  const _NoteButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: const Icon(Icons.edit_note, size: 16),
        ),
      ),
    );
  }
}

class _DictionaryButton extends StatelessWidget {
  const _DictionaryButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: const Icon(Icons.menu_book, size: 16),
        ),
      ),
    );
  }
}

class _EraserButton extends StatelessWidget {
  const _EraserButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: const Icon(Icons.delete_outline, size: 16),
        ),
      ),
    );
  }
}
