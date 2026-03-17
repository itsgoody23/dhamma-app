import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/providers/database_provider.dart';

/// Provider that watches the note for a specific sutta UID.
final _noteForUidProvider =
    StreamProvider.autoDispose.family<UserNote?, String>((ref, uid) {
  return ref.watch(appDatabaseProvider).studyToolsDao.watchNoteForUid(uid);
});

/// Modal bottom sheet for viewing / editing the per-sutta note.
class NoteSheet extends ConsumerStatefulWidget {
  const NoteSheet({super.key, required this.textUid});

  final String textUid;

  @override
  ConsumerState<NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends ConsumerState<NoteSheet> {
  final _controller = TextEditingController();
  Timer? _saveDebounce;
  bool _initialized = false;
  int? _existingNoteId;
  late final AppDatabase _db;

  @override
  void initState() {
    super.initState();
    _db = ref.read(appDatabaseProvider);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    // Final save on close — use cached _db reference since ref may be invalid.
    _saveNoteSync();
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 800), _saveNote);
  }

  Future<void> _saveNote() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    await _db.studyToolsDao.upsertNote(widget.textUid, content);
  }

  /// Synchronous fire-and-forget for dispose.
  void _saveNoteSync() {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    _db.studyToolsDao.upsertNote(widget.textUid, content);
  }

  Future<void> _deleteNote() async {
    if (_existingNoteId == null) return;
    await _db.studyToolsDao.deleteNote(_existingNoteId!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final noteAsync = ref.watch(_noteForUidProvider(widget.textUid));

    // Initialize controller from first emission.
    noteAsync.whenData((note) {
      if (!_initialized) {
        _initialized = true;
        _controller.text = note?.content ?? '';
        _existingNoteId = note?.id;
        _controller.addListener(_onTextChanged);
      } else {
        _existingNoteId = note?.id;
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Row(
              children: [
                const Icon(Icons.edit_note, color: AppColors.green),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_existingNoteId != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Delete note',
                    onPressed: _deleteNote,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Text field
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Write your notes here...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
