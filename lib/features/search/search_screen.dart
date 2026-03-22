import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/models/search_result.dart';
import '../../core/utils/error_formatter.dart';
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

// ── Curated content (static) ──────────────────────────────────────────────────

class _CuratedSeries {
  const _CuratedSeries({
    required this.label,
    required this.title,
    required this.description,
    required this.uid,
  });

  final String label;
  final String title;
  final String description;
  final String uid;
}

const _featuredSeries = _CuratedSeries(
  label: 'SPECIAL SERIES',
  title: 'Suttas on Mindfulness',
  description:
      'A curated collection exploring the Satipaṭṭhāna Sutta and practical applications of presence.',
  uid: 'mn10',
);

const _featuredCollections = [
  (icon: Icons.menu_book_outlined, title: 'Wisdom of the Elders', sub: 'THERIGATHA', uid: 'thig'),
  (icon: Icons.waves_outlined, title: 'Calming the Storms', sub: 'VERSES ON PEACE', uid: 'snp'),
];

const _trendingPaths = [
  ('Dependent Origination', 'mn38'),
  ('Five Hindrances', 'dn2'),
  ('The Middle Way', 'mn141'),
  ('Equanimity', 'an4.170'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const _FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(searchFiltersProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md, vertical: AppSizes.sm),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push(Routes.settings),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors.green.withValues(alpha: 0.15),
                      child: const Icon(Icons.person_outline,
                          size: 20, color: AppColors.green),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  const Expanded(
                    child: Text(
                      'THE DIGITAL ALTAR',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, size: 22),
                    onPressed: () => context.push(Routes.settings),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // ── Search bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: AppSizes.md),
                    const Icon(Icons.search, size: 20,
                        color: AppColors.textTertiary),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: context.l10n.searchHint,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14),
                          hintStyle: const TextStyle(
                              color: AppColors.textTertiary, fontSize: 14),
                        ),
                        onChanged: _onQueryChanged,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    if (_query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _query = '');
                        },
                      )
                    else
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.tune_outlined, size: 20),
                            onPressed: () => _showFilterSheet(context),
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
              ),
            ),

            const SizedBox(height: AppSizes.sm),

            // ── Filter chips row ─────────────────────────────────────────────
            _FilterChipsRow(
              filters: filters,
              onShowSheet: () => _showFilterSheet(context),
            ),

            const SizedBox(height: AppSizes.xs),

            // ── Body ─────────────────────────────────────────────────────────
            Expanded(
              child: _query.isEmpty
                  ? _SearchDiscovery(onHistoryTapped: (query) {
                      _controller.text = query;
                      _onQueryChanged(query);
                    })
                  : _SearchResults(query: _query),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Filter chips row ──────────────────────────────────────────────────────────

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow(
      {required this.filters, required this.onShowSheet});

  final SearchFilters filters;
  final VoidCallback onShowSheet;

  @override
  Widget build(BuildContext context) {
    final chips = [
      ('PALI', 'pli'),
      ('ENGLISH', 'en'),
      ('NIKAYAS', null), // opens sheet
      ('VINAYA', null),
    ];

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        children: chips.map((chip) {
          final label = chip.$1;
          final lang = chip.$2;
          final isActive = lang != null && filters.language == lang;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.sm),
            child: GestureDetector(
              onTap: onShowSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.green
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                    color: isActive
                        ? AppColors.green
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Search discovery (empty state) ────────────────────────────────────────────

class _SearchDiscovery extends ConsumerWidget {
  const _SearchDiscovery({this.onHistoryTapped});

  final ValueChanged<String>? onHistoryTapped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(
      StreamProvider.autoDispose((ref) =>
          ref.watch(appDatabaseProvider).searchDao.watchSearchHistory()),
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      children: [
        // ── Curated Discovery ────────────────────────────────────────────
        const _SectionLabel('CURATED DISCOVERY'),
        const SizedBox(height: AppSizes.sm),
        _CuratedHeroCard(series: _featuredSeries),
        const SizedBox(height: AppSizes.md),

        // ── Featured collection cards ────────────────────────────────────
        Row(
          children: _featuredCollections.map((col) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: col == _featuredCollections.first
                      ? AppSizes.sm / 2
                      : 0,
                  left: col == _featuredCollections.last
                      ? AppSizes.sm / 2
                      : 0,
                ),
                child: _FeaturedCollectionCard(
                  icon: col.icon,
                  title: col.title,
                  sub: col.sub,
                  uid: col.uid,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: AppSizes.lg),

        // ── Recent Activity ──────────────────────────────────────────────
        historyAsync.when(
          data: (history) {
            if (history.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                        child: _SectionLabel('RECENT ACTIVITY')),
                    TextButton(
                      onPressed: () => ref
                          .read(appDatabaseProvider)
                          .searchDao
                          .clearSearchHistory(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.green,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text('CLEAR',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xs),
                ...history.take(5).map((item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.history_outlined,
                          size: 18, color: AppColors.textTertiary),
                      title: Text(item.query,
                          style: const TextStyle(fontSize: 14)),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 16,
                            color: AppColors.textTertiary),
                        onPressed: () => ref
                            .read(appDatabaseProvider)
                            .searchDao
                            .deleteSearchTerm(item.id),
                      ),
                      onTap: () => onHistoryTapped?.call(item.query),
                      visualDensity: VisualDensity.compact,
                    )),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        const SizedBox(height: AppSizes.lg),

        // ── Trending Paths ───────────────────────────────────────────────
        const _SectionLabel('TRENDING PATHS'),
        const SizedBox(height: AppSizes.sm),
        Wrap(
          spacing: AppSizes.sm,
          runSpacing: AppSizes.sm,
          children: _trendingPaths.map((path) {
            return GestureDetector(
              onTap: () => context.push(Routes.readerPath(path.$2)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                      color: AppColors.green.withValues(alpha: 0.2)),
                ),
                child: Text(
                  path.$1.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.green,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: AppSizes.xl),
      ],
    );
  }
}

// ── Curated hero card ─────────────────────────────────────────────────────────

class _CuratedHeroCard extends StatelessWidget {
  const _CuratedHeroCard({required this.series});

  final _CuratedSeries series;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.readerPath(series.uid)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.spa_outlined,
                      size: 64, color: AppColors.green),
                ),
                Positioned(
                  bottom: AppSizes.md,
                  left: AppSizes.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    color: AppColors.greenDark,
                    child: Text(
                      series.label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            series.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            series.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

// ── Featured collection card ──────────────────────────────────────────────────

class _FeaturedCollectionCard extends StatelessWidget {
  const _FeaturedCollectionCard({
    required this.icon,
    required this.title,
    required this.sub,
    required this.uid,
  });

  final IconData icon;
  final String title;
  final String sub;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.readerPath(uid)),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.green, size: 28),
            const SizedBox(height: AppSizes.sm),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child:
                Divider(thickness: 0.5, color: AppColors.textTertiary)),
        const SizedBox(width: AppSizes.sm),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: AppSizes.sm),
        const Expanded(
            child:
                Divider(thickness: 0.5, color: AppColors.textTertiary)),
      ],
    );
  }
}

// ── Search results with pagination ───────────────────────────────────────────

class _SearchResults extends ConsumerStatefulWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  ConsumerState<_SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends ConsumerState<_SearchResults> {
  static const _pageSize = 50;

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider(widget.query));

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
                    context.l10n.searchNoResults(widget.query),
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.searchTryDifferent,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        final hasMore = results.length >= _pageSize;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md, vertical: AppSizes.sm),
          itemCount: results.length + (hasMore ? 1 : 0),
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (index < results.length) {
              return _ResultTile(result: results[index]);
            }
            // "Load more" button
            return _LoadMoreButton(
              query: widget.query,
              currentCount: results.length,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(friendlyError(e))),
    );
  }
}

class _LoadMoreButton extends ConsumerStatefulWidget {
  const _LoadMoreButton({required this.query, required this.currentCount});
  final String query;
  final int currentCount;

  @override
  ConsumerState<_LoadMoreButton> createState() => _LoadMoreButtonState();
}

class _LoadMoreButtonState extends ConsumerState<_LoadMoreButton> {
  bool _loading = false;
  List<SearchResult> _extra = [];

  Future<void> _loadMore() async {
    setState(() => _loading = true);
    final filters = ref.read(searchFiltersProvider);
    final db = ref.read(appDatabaseProvider);
    final more = await db.searchDao.search(
      widget.query,
      language: filters.language,
      nikaya: filters.nikaya,
      translator: filters.translator,
      offset: widget.currentCount + _extra.length,
    );
    setState(() {
      _extra = [..._extra, ...more];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._extra.map((r) => _ResultTile(result: r)),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton.icon(
              onPressed: _loadMore,
              icon: const Icon(Icons.expand_more),
              label: const Text('Load more'),
            ),
          ),
      ],
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
              Text(context.l10n.searchFilterResults,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              if (filters.hasFilters)
                TextButton(
                  onPressed: () {
                    notifier.clear();
                    Navigator.pop(context);
                  },
                  child: Text(context.l10n.searchClearAll),
                ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Text(context.l10n.searchNikaya,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
          Text(context.l10n.searchLanguage,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
              child: Text(context.l10n.searchApply),
            ),
          ),
          const SizedBox(height: AppSizes.sm),
        ],
      ),
    );
  }
}
