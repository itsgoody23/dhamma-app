import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/share_service.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_typography.dart';
import '../../data/database/app_database.dart';
import '../../data/services/pdf_export_service.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/preferences_provider.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/loading_shimmer.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final readerSuttaProvider = FutureProvider.autoDispose
    .family<SuttaText?, (String, String)>((ref, args) async {
  final db = ref.watch(appDatabaseProvider);
  var sutta = await db.textsDao.getSuttaByUid(args.$1, args.$2);
  sutta ??= await db.textsDao.getSuttaByUidAnyLanguage(args.$1);
  return sutta;
});

final readerHighlightsProvider =
    StreamProvider.autoDispose.family<List<UserHighlight>, String>((ref, uid) {
  final db = ref.watch(appDatabaseProvider);
  return db.studyToolsDao.watchHighlightsForUid(uid);
});

final readerIsBookmarkedProvider =
    StreamProvider.autoDispose.family<bool, String>((ref, uid) {
  final db = ref.watch(appDatabaseProvider);
  return db.studyToolsDao.watchIsBookmarked(uid);
});

final readerAvailableLanguagesProvider =
    FutureProvider.autoDispose.family<List<String>, String>((ref, uid) {
  final db = ref.watch(appDatabaseProvider);
  return db.textsDao.getLanguagesForUid(uid);
});

// ── Screen ────────────────────────────────────────────────────────────────────

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({
    super.key,
    required this.uid,
    required this.language,
  });

  final String uid;
  final String language;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _progressDebounce;
  String _activeLanguage = '';

  @override
  void initState() {
    super.initState();
    _activeLanguage = widget.language;
    _restoreScrollPosition();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _progressDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _restoreScrollPosition() async {
    final db = ref.read(appDatabaseProvider);
    final progress = await db.progressDao.getProgressForUid(widget.uid);
    if (progress != null && progress.lastPosition > 0 && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            progress.lastPosition.toDouble().clamp(
                  0,
                  _scrollController.position.maxScrollExtent,
                ),
          );
        }
      });
    }
  }

  void _onScroll() {
    _progressDebounce?.cancel();
    _progressDebounce = Timer(const Duration(milliseconds: 500), () {
      final db = ref.read(appDatabaseProvider);
      final position = _scrollController.offset.toInt();
      final maxExtent = _scrollController.position.maxScrollExtent;
      final completed = maxExtent > 0 && (position / maxExtent) > 0.95;
      db.progressDao.upsertProgress(
        textUid: widget.uid,
        lastPosition: position,
        completed: completed,
      );
    });
  }

  Future<void> _toggleBookmark(SuttaText sutta) async {
    final db = ref.read(appDatabaseProvider);
    await db.studyToolsDao.toggleBookmark(sutta.uid);
  }

  Future<void> _exportPdf(SuttaText sutta) async {
    try {
      await PdfExportService.exportAndShare(sutta);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not export PDF: $e')),
        );
      }
    }
  }

  Future<void> _share(SuttaText sutta) async {
    try {
      await ShareService.sharePassage(sutta);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suttaAsync = ref.watch(
      readerSuttaProvider((
        widget.uid,
        _activeLanguage.isEmpty ? widget.language : _activeLanguage
      )),
    );
    final isBookmarkedAsync = ref.watch(readerIsBookmarkedProvider(widget.uid));
    final fontSize = ref.watch(readerFontSizeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: suttaAsync.when(
          data: (s) =>
              Text(s?.title ?? widget.uid, overflow: TextOverflow.ellipsis),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => Text(widget.uid),
        ),
        actions: [
          // Bookmark toggle
          isBookmarkedAsync.when(
            data: (isBookmarked) => IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? AppColors.green : null,
              ),
              tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
              onPressed: () {
                if (suttaAsync.value != null) {
                  _toggleBookmark(suttaAsync.value!);
                }
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // Overflow menu
          if (suttaAsync.value != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                final sutta = suttaAsync.value!;
                if (value == 'share') _share(sutta);
                if (value == 'pdf') _exportPdf(sutta);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'share', child: Text('Share passage')),
                PopupMenuItem(value: 'pdf', child: Text('Export PDF')),
              ],
            ),
        ],
      ),
      body: suttaAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => ErrorState(message: e.toString()),
        data: (sutta) {
          if (sutta == null) {
            return const ErrorState(
                message: 'Sutta not found.\nDownload the content pack first.');
          }
          return Column(
            children: [
              // Language / font-size toolbar
              _Toolbar(
                uid: widget.uid,
                activeLanguage:
                    _activeLanguage.isEmpty ? widget.language : _activeLanguage,
                onLanguageChanged: (lang) =>
                    setState(() => _activeLanguage = lang),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sutta body
                      sutta.contentHtml != null
                          ? Html(
                              data: sutta.contentHtml!,
                              style: {
                                'body': Style(fontSize: FontSize(fontSize)),
                                'p': Style(
                                  fontSize: FontSize(fontSize),
                                  lineHeight: const LineHeight(1.7),
                                ),
                              },
                            )
                          : Text(
                              sutta.contentPlain ?? '',
                              style: TextStyle(fontSize: fontSize, height: 1.7),
                            ),
                      const SizedBox(height: AppSizes.xl),
                      // Translator attribution (CC-BY requirement)
                      _TranslatorAttribution(
                        translator: sutta.translator,
                        source: sutta.source ?? 'sc',
                        uid: sutta.uid,
                      ),
                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Toolbar ───────────────────────────────────────────────────────────────────

class _Toolbar extends ConsumerWidget {
  const _Toolbar({
    required this.uid,
    required this.activeLanguage,
    required this.onLanguageChanged,
  });

  final String uid;
  final String activeLanguage;
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final langsAsync = ref.watch(readerAvailableLanguagesProvider(uid));
    final fontSize = ref.watch(readerFontSizeProvider);
    const sizes = AppTypography.readerFontSizes;
    const labels = AppTypography.readerFontSizeLabels;
    final idx = sizes.indexOf(fontSize);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        border: Border(
            bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          // Font size stepper
          IconButton(
            icon: const Icon(Icons.text_decrease, size: 18),
            tooltip: 'Smaller',
            onPressed: idx > 0
                ? () => ref.read(readerFontSizeProvider.notifier).decrease()
                : null,
          ),
          Text(
            labels[idx.clamp(0, labels.length - 1)],
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: const Icon(Icons.text_increase, size: 18),
            tooltip: 'Larger',
            onPressed: idx < sizes.length - 1
                ? () => ref.read(readerFontSizeProvider.notifier).increase()
                : null,
          ),
          const Spacer(),
          // Language picker
          langsAsync.when(
            data: (langs) {
              if (langs.length <= 1) return const SizedBox.shrink();
              return DropdownButton<String>(
                value: activeLanguage,
                isDense: true,
                underline: const SizedBox.shrink(),
                items: langs
                    .map((l) => DropdownMenuItem(
                        value: l, child: Text(l.toUpperCase())))
                    .toList(),
                onChanged: (l) {
                  if (l != null) onLanguageChanged(l);
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Translator Attribution ───────────────────────────────────────────────────

class _TranslatorAttribution extends StatelessWidget {
  const _TranslatorAttribution({
    required this.translator,
    required this.source,
    required this.uid,
  });

  final String? translator;
  final String source;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sourceLabel = source == 'sc' ? 'SuttaCentral' : source;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (translator != null)
            Text(
              'Translation by $translator',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 2),
          Text(
            'Source: $sourceLabel · $uid',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'This translation is published under a Creative Commons Attribution licence (CC BY).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
