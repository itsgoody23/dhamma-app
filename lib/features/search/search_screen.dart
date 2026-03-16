import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/models/search_result.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/widgets/nikaya_badge.dart';

part 'search_screen.g.dart';

// ── Filter state ──────────────────────────────────────────────────────────────

class SearchFilters {
  const SearchFilters({this.language, this.nikaya, this.translator});

  final String? language;
  final String? nikaya;
  final String? translator;

  SearchFilters copyWith({
    Object? language = _sentinel,
    Object? nikaya = _sentinel,
    Object? translator = _sentinel,
  }) =>
      SearchFilters(
        language: identical(language, _sentinel)
            ? this.language
            : language as String?,
        nikaya: identical(nikaya, _sentinel) ? this.nikaya : nikaya as String?,
        translator: identical(translator, _sentinel)
            ? this.translator
            : translator as String?,
      );

  bool get hasFilters =>
      language != null || nikaya != null || translator != null;

  static const _sentinel = Object();
}

@riverpod
class SearchFiltersNotifier extends _$SearchFiltersNotifier {
  @override
  SearchFilters build() => const SearchFilters();

  void setLanguage(String? lang) => state = state.copyWith(language: lang);
  void setNikaya(String? nikaya) => state = state.copyWith(nikaya: nikaya);
  void setTranslator(String? translator) =>
      state = state.copyWith(translator: translator);
  void clear() => state = const SearchFilters();
}

// ── Search results provider ───────────────────────────────────────────────────

@riverpod
Future<List<SearchResult>> searchResults(
  Ref ref,
  String query,
) async {
  if (query.trim().isEmpty) return [];

  // Debounce
  await Future<void>.delayed(const Duration(milliseconds: 300));

  final filters = ref.watch(searchFiltersProvider);
  final db = ref.watch(appDatabaseProvider);
  return db.searchDao.search(
    query,
    language: filters.language,
    nikaya: filters.nikaya,
    translator: filters.translator,
  );
}

// ── Screen ────────────────────────────────────────────────────────────────────

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
    if (value.isNotEmpty) {
      _saveHistory(value);
    }
  }

  Future<void> _saveHistory(String query) async {
    if (query.trim().length < 3) return;
    final db = ref.read(appDatabaseProvider);
    await db.searchDao.saveSearchTerm(query.trim());
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Search suttas, keywords, titles…',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                : null,
          ),
          onChanged: _onQueryChanged,
          textInputAction: TextInputAction.search,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.tune_outlined),
                onPressed: () => _showFilterSheet(context),
                tooltip: 'Filter',
              ),
              if (filters.hasFilters)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _query.isEmpty ? _SearchHistory() : _SearchResults(query: _query),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const _FilterSheet(),
    );
  }
}

// ── Search history ────────────────────────────────────────────────────────────

class _SearchHistory extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(
      StreamProvider((ref) =>
          ref.watch(appDatabaseProvider).searchDao.watchSearchHistory()),
    );

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Search the Pali Canon\nby title, keyword, or phrase',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tip: "satipaṭṭhāna" or "satipatthana" both work',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'RECENT SEARCHES',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8),
                    ),
                  ),
                  TextButton(
                    onPressed: () => ref
                        .read(appDatabaseProvider)
                        .searchDao
                        .clearSearchHistory(),
                    child: const Text('Clear', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return ListTile(
                    leading: const Icon(Icons.history, size: 18),
                    title: Text(item.query),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () => ref
                          .read(appDatabaseProvider)
                          .searchDao
                          .deleteSearchTerm(item.id),
                    ),
                    onTap: () {
                      // TODO: populate search bar with this query
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ── Search results ────────────────────────────────────────────────────────────

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider(query));

    return resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No results for "$query"',
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Try a different keyword or download more packs',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md, vertical: AppSizes.sm),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) => _ResultTile(result: results[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Search error: $e')),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result});

  final SearchResult result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
          vertical: AppSizes.xs, horizontal: AppSizes.sm),
      leading: NikayaBadge(nikaya: result.nikaya),
      title: Text(
        result.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.snippet.isNotEmpty) _SnippetText(snippet: result.snippet),
          if (result.translator != null)
            Text(
              result.translator!,
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push(
        '${Routes.readerPath(result.uid)}?lang=${result.language}',
      ),
    );
  }
}

/// Renders FTS5 snippet() output with <b> tags as bold spans.
class _SnippetText extends StatelessWidget {
  const _SnippetText({required this.snippet});

  final String snippet;

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    final regex = RegExp(r'<b>(.*?)</b>');
    int lastEnd = 0;

    for (final match in regex.allMatches(snippet)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: snippet.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < snippet.length) {
      spans.add(TextSpan(text: snippet.substring(lastEnd)));
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        children: spans,
      ),
    );
  }
}

// ── Filter sheet ──────────────────────────────────────────────────────────────

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(searchFiltersProvider);
    final notifier = ref.read(searchFiltersProvider.notifier);

    const nikayas = ['dn', 'mn', 'sn', 'an', 'kn'];
    const languages = ['en', 'pli', 'de', 'fr', 'es'];

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter Results',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              if (filters.hasFilters)
                TextButton(
                  onPressed: () {
                    notifier.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear all'),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          const Text('Nikāya',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.sm,
            children: nikayas
                .map((n) => FilterChip(
                      label: Text(n.toUpperCase()),
                      selected: filters.nikaya == n,
                      onSelected: (_) =>
                          notifier.setNikaya(filters.nikaya == n ? null : n),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSizes.md),
          const Text('Language',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: AppSizes.sm,
            children: languages
                .map((l) => FilterChip(
                      label: Text(l.toUpperCase()),
                      selected: filters.language == l,
                      onSelected: (_) => notifier
                          .setLanguage(filters.language == l ? null : l),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppSizes.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply'),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }
}
