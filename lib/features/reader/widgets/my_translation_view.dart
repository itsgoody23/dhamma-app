import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/providers/database_provider.dart';

/// Provider to watch user translation for a given sutta.
final userTranslationProvider = StreamProvider.autoDispose
    .family<UserTranslation?, String>((ref, suttaUid) {
  final db = ref.watch(appDatabaseProvider);
  return db.userTranslationsDao.watchSuttaTranslation(suttaUid);
});

/// A view that displays the user's personal translation of a sutta,
/// with inline editing support. Shown in the reader when the user
/// toggles "My Translation" mode.
class MyTranslationView extends ConsumerStatefulWidget {
  const MyTranslationView({
    super.key,
    required this.suttaUid,
    required this.fontSize,
    required this.lineSpacing,
  });

  final String suttaUid;
  final double fontSize;
  final double lineSpacing;

  @override
  ConsumerState<MyTranslationView> createState() => _MyTranslationViewState();
}

class _MyTranslationViewState extends ConsumerState<MyTranslationView> {
  final _controller = TextEditingController();
  bool _isEditing = false;
  Timer? _autoSave;
  bool _hasUnsavedChanges = false;

  @override
  void dispose() {
    _saveIfNeeded();
    _autoSave?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _saveIfNeeded() {
    if (!_hasUnsavedChanges) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final db = ref.read(appDatabaseProvider);
    db.userTranslationsDao.upsertTranslation(
      suttaUid: widget.suttaUid,
      content: text,
    );
    _hasUnsavedChanges = false;
  }

  void _startEditing(String? existingContent) {
    _controller.text = existingContent ?? '';
    setState(() => _isEditing = true);
  }

  void _onTextChanged() {
    _hasUnsavedChanges = true;
    _autoSave?.cancel();
    _autoSave = Timer(const Duration(seconds: 3), _saveIfNeeded);
  }

  void _finishEditing() {
    _saveIfNeeded();
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final translationAsync =
        ref.watch(userTranslationProvider(widget.suttaUid));

    return translationAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (translation) {
        if (_isEditing) {
          return _buildEditor(context);
        }

        if (translation == null || translation.content.trim().isEmpty) {
          return _buildEmptyState(context);
        }

        return _buildTranslationDisplay(context, translation);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.edit_note,
            size: 48,
            color: AppColors.green.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'No personal translation yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Write your own translation or interpretation of this sutta.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          FilledButton.icon(
            onPressed: () => _startEditing(null),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Start Writing'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationDisplay(
      BuildContext context, UserTranslation translation) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with edit button
          Row(
            children: [
              Icon(Icons.person_outline,
                  size: 16, color: AppColors.green.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Text(
                'My Translation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green.withValues(alpha: 0.7),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 18),
                onPressed: () => _startEditing(translation.content),
                tooltip: 'Edit translation',
                visualDensity: VisualDensity.compact,
                color: AppColors.green,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          // Translation content
          SelectableText(
            translation.content,
            style: TextStyle(
              fontSize: widget.fontSize,
              height: widget.lineSpacing,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit,
                  size: 16, color: AppColors.green.withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Text(
                'Editing Translation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green.withValues(alpha: 0.7),
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _finishEditing,
                child: const Text('Done'),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          TextField(
            controller: _controller,
            maxLines: null,
            minLines: 8,
            autofocus: true,
            onChanged: (_) => _onTextChanged(),
            style: TextStyle(
              fontSize: widget.fontSize,
              height: widget.lineSpacing,
            ),
            decoration: InputDecoration(
              hintText:
                  'Write your translation here...\n\nYou can translate the full sutta or just key passages.',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: AppColors.green.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.green),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Auto-saves as you type',
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}
