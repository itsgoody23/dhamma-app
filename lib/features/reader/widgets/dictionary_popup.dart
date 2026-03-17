import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../shared/providers/dictionary_provider.dart';

/// Bottom sheet that shows the Pali dictionary definition for a word.
class DictionaryPopup extends ConsumerStatefulWidget {
  const DictionaryPopup({super.key, required this.word});

  final String word;

  @override
  ConsumerState<DictionaryPopup> createState() => _DictionaryPopupState();
}

class _DictionaryPopupState extends ConsumerState<DictionaryPopup> {
  late Future<_DictionaryResult> _lookupFuture;

  @override
  void initState() {
    super.initState();
    _lookupFuture = _lookup(widget.word);
  }

  Future<_DictionaryResult> _lookup(String rawWord) async {
    final dao = ref.read(dictionaryDaoProvider);
    final word = rawWord.trim().toLowerCase();

    // Try exact match first.
    final exact = await dao.lookupWord(word);
    if (exact != null) return _DictionaryResult(entries: [exact]);

    // Fall back to prefix search.
    final prefix = await dao.searchPrefix(word, limit: 10);
    if (prefix.isNotEmpty) return _DictionaryResult(entries: prefix);

    return _DictionaryResult(entries: []);
  }

  void _lookupCrossRef(String ref) {
    setState(() {
      _lookupFuture = _lookup(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.menu_book,
                    size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Pali Dictionary',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: FutureBuilder<_DictionaryResult>(
              future: _lookupFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                final result = snapshot.data;
                if (result == null || result.entries.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No definition found for "${widget.word}"',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: result.entries.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final entry = result.entries[index];
                    return _EntryCard(
                      entry: entry,
                      onCrossRefTap: _lookupCrossRef,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DictionaryResult {
  _DictionaryResult({required this.entries});
  final List<PaliDictionaryEntry> entries;
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.onCrossRefTap});

  final PaliDictionaryEntry entry;
  final void Function(String) onCrossRefTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crossRefs = entry.crossRefs
        ?.split('; ')
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Headword
        Text(
          entry.entry,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        // Grammar
        if (entry.grammar != null && entry.grammar!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            entry.grammar!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        // Definition
        const SizedBox(height: 8),
        Text(
          entry.definition,
          style: theme.textTheme.bodyMedium,
        ),
        // Cross references
        if (crossRefs != null && crossRefs.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Text('See also:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  )),
              for (final xr in crossRefs)
                GestureDetector(
                  onTap: () => onCrossRefTap(xr),
                  child: Text(
                    xr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
