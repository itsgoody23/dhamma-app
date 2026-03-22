import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/services/share_service.dart';
import '../../data/services/tts_service.dart';
import '../../shared/providers/tts_provider.dart';
import '../../shared/widgets/sutta_share_card.dart';
import 'widgets/parallels_section.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_typography.dart';
import '../../core/routing/routes.dart';
import '../../core/utils/error_formatter.dart';
import '../../core/utils/uid_utils.dart';
import '../../data/database/app_database.dart';
import '../../data/services/pdf_export_service.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/preferences_provider.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../shared/widgets/translator_attribution.dart';
import 'utils/html_parser.dart';
import 'widgets/highlight_toolbar.dart';
import 'widgets/highlighted_text.dart';
import 'widgets/interlinear_reader_view.dart';
import 'widgets/note_sheet.dart';
import 'widgets/paginated_reader_view.dart';
import 'widgets/parallel_comparison_view.dart';
import 'widgets/reader_help_overlay.dart';
import 'widgets/split_reader_view.dart';
import '../collections/add_to_collection_sheet.dart';
import 'widgets/my_translation_view.dart';
import 'widgets/commentary_view.dart';
import 'widgets/dictionary_popup.dart';
import '../../data/services/community_service.dart';
import 'widgets/community_highlights.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../shared/providers/reader_view_prefs_provider.dart';
import '../../shared/providers/tabs_provider.dart';
import 'widgets/sutta_tab_bar.dart';
import 'widgets/view_settings_sheet.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final readerSuttaProvider = FutureProvider.autoDispose
    .family<SuttaText?, (String, String)>((ref, args) async {
  final db = ref.watch(appDatabaseProvider);
  final uid = args.$1;
  final lang = args.$2;

  // Handle range UIDs like 'dhp1-20' by fetching all verses and merging.
  if (isRangeUid(uid)) {
    final expanded = expandRangeUid(uid);
    var verses = await db.textsDao.getSuttasByUidList(expanded, lang);
    if (verses.isEmpty) {
      // Try any language as fallback.
      verses = await db.textsDao.getSuttasByUidList(expanded, 'en');
    }
    if (verses.isEmpty) return null;
    // Merge into a single virtual SuttaText.
    final first = verses.first;
    final mergedHtml = verses
        .map((v) => v.contentHtml ?? '')
        .where((h) => h.isNotEmpty)
        .join('\n');
    final mergedPlain = verses
        .map((v) => v.contentPlain ?? '')
        .where((p) => p.isNotEmpty)
        .join('\n\n');
    return SuttaText(
      id: first.id,
      uid: uid,
      title: first.title,
      collection: first.collection,
      nikaya: first.nikaya,
      book: first.book,
      chapter: first.chapter,
      language: first.language,
      translator: first.translator,
      source: first.source,
      contentHtml: mergedHtml.isNotEmpty ? mergedHtml : null,
      contentPlain: mergedPlain.isNotEmpty ? mergedPlain : null,
      textType: 'root',
    );
  }

  var sutta = await db.textsDao.getSuttaByUid(uid, lang);
  sutta ??= await db.textsDao.getSuttaByUidAnyLanguage(uid);
  return sutta;
});

final readerHighlightsProvider = StreamProvider.autoDispose
    .family<List<UserHighlight>, (String, String)>((ref, args) {
  final db = ref.watch(appDatabaseProvider);
  return db.studyToolsDao.watchHighlightsForUid(args.$1, language: args.$2);
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

final readerNoteProvider =
    StreamProvider.autoDispose.family<UserNote?, String>((ref, uid) {
  final db = ref.watch(appDatabaseProvider);
  return db.studyToolsDao.watchNoteForUid(uid);
});

final readerPaliSuttaProvider =
    FutureProvider.autoDispose.family<SuttaText?, String>((ref, uid) async {
  final db = ref.watch(appDatabaseProvider);
  return db.textsDao.getSuttaByUid(uid, 'pli');
});

final readerAdjacentProvider = FutureProvider.autoDispose
    .family<(String?, String?), (String, String)>((ref, args) async {
  final db = ref.watch(appDatabaseProvider);
  return db.textsDao.getAdjacentUids(args.$1, args.$2);
});

// ── View mode ─────────────────────────────────────────────────────────────────

enum _ReaderViewMode { single, sideBySide, interlinear }

// ── Screen ────────────────────────────────────────────────────────────────────

class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({
    super.key,
    required this.uid,
    required this.language,
    this.scrollTo,
  });

  final String uid;
  final String language;
  final int? scrollTo;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  final _paginatedKey = GlobalKey<PaginatedReaderViewState>();
  final _splitKey = GlobalKey<SplitReaderViewState>();
  final _keyboardFocusNode = FocusNode();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Timer? _progressDebounce;
  String _activeLanguage = '';
  _ReaderViewMode _viewMode = _ReaderViewMode.single;
  bool _showCommentary = false;
  bool _showMyTranslation = false;
  bool _showSearch = false;
  bool _showHelp = false;
  bool _showCompare = false;
  String _searchQuery = '';
  List<({int start, int end})> _searchMatches = [];
  int _currentMatchIndex = -1;
  TextSelection? _currentSelection;
  String _selectionLanguage = '';
  OverlayEntry? _toolbarOverlay;
  int _currentPage = 0;
  int _totalPages = 0;
  int _restoredPage = 0;
  bool _didJumpToScrollTo = false;
  String _currentReadableText = '';
  bool _showCommunityHighlights = false;
  DateTime? _readingStartTime;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _activeLanguage = widget.language;
    _readingStartTime = DateTime.now();
    _restoreScrollPosition();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    _checkFirstRunHelp();
    // Register this sutta as an open tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(tabsProvider.notifier).openTab(widget.uid);
    });
  }

  Future<void> _checkFirstRunHelp() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('reader_help_shown') ?? false;
    if (!shown && mounted) {
      setState(() => _showHelp = true);
      await prefs.setBool('reader_help_shown', true);
    }
  }

  @override
  void dispose() {
    _removeToolbarOverlay();
    _progressDebounce?.cancel();
    _scrollController.dispose();
    _keyboardFocusNode.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    // Record reading time for streak
    if (_readingStartTime != null) {
      final minutes =
          DateTime.now().difference(_readingStartTime!).inMinutes;
      if (minutes > 0) {
        ref.read(appDatabaseProvider).streaksDao.recordReading(
              additionalMinutes: minutes,
              additionalSuttas: 1,
            );
      }
    }
    // Stop TTS if playing
    ref.read(ttsServiceProvider).stop();
    super.dispose();
  }

  Future<void> _restoreScrollPosition() async {
    final db = ref.read(appDatabaseProvider);
    final progress = await db.progressDao.getProgressForUid(widget.uid);
    if (progress != null && progress.lastPosition > 0 && mounted) {
      // For paginated mode, lastPosition stores the page number (negative
      // values encode pages: -1 = page 0, -2 = page 1, etc.)
      // For scroll mode, it stores pixel offset (always >= 0).
      if (progress.lastPosition < 0) {
        _restoredPage = -(progress.lastPosition + 1);
      } else {
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
          SnackBar(content: Text('Could not export PDF: ${friendlyError(e)}')),
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
          SnackBar(content: Text('Could not share: ${friendlyError(e)}')),
        );
      }
    }
  }

  Future<void> _shareAsImage(SuttaText sutta) async {
    // Show style picker
    final style = await showModalBottomSheet<ShareCardStyle>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose card style',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ShareCardStyle.values.map((s) {
                final label = s.name[0].toUpperCase() + s.name.substring(1);
                return ChoiceChip(
                  label: Text(label),
                  selected: false,
                  onSelected: (_) => Navigator.pop(ctx, s),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
    if (style == null) return;

    try {
      if (!mounted) return;
      await ShareService.shareAsImage(context, sutta, style: style);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not share: ${friendlyError(e)}')),
        );
      }
    }
  }

  // ── Highlighting ──────────────────────────────────────────────────────────

  void _onSelectionChanged(
    TextSelection selection,
    SelectionChangedCause? cause, [
    String? language,
  ]) {
    final lang = language ?? _activeLanguage;
    if (selection.isCollapsed) {
      _removeToolbarOverlay();
      setState(() => _currentSelection = null);
      return;
    }
    setState(() {
      _currentSelection = selection;
      _selectionLanguage = lang;
    });
    _showToolbarOverlay();
  }

  void _showToolbarOverlay() {
    _removeToolbarOverlay();
    final overlay = Overlay.of(context);
    final overlapsHighlight = _selectionOverlapsHighlight();
    _toolbarOverlay = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + kToolbarHeight + 60,
        left: 0,
        right: 0,
        child: Center(
          child: HighlightToolbar(
            onColorSelected: _onHighlightColor,
            showDelete: overlapsHighlight,
            showNote: overlapsHighlight,
            onDelete: _onDeleteOverlappingHighlights,
            onNoteRequested: _onNoteRequested,
            onDictionaryRequested: _onDictionaryRequested,
          ),
        ),
      ),
    );
    overlay.insert(_toolbarOverlay!);
  }

  void _removeToolbarOverlay() {
    _toolbarOverlay?.remove();
    _toolbarOverlay = null;
  }

  bool _selectionOverlapsHighlight() {
    if (_currentSelection == null || _currentSelection!.isCollapsed) {
      return false;
    }
    final highlights = ref
        .read(readerHighlightsProvider(
            (widget.uid, _selectionLanguage.isEmpty ? _activeLanguage : _selectionLanguage)))
        .value;
    if (highlights == null) return false;

    final start = _currentSelection!.start;
    final end = _currentSelection!.end;
    return highlights
        .any((h) => h.startOffset < end && h.endOffset > start);
  }

  Future<void> _onHighlightColor(String hexColor) async {
    if (_currentSelection == null || _currentSelection!.isCollapsed) return;
    final db = ref.read(appDatabaseProvider);
    final lang = _selectionLanguage.isEmpty ? _activeLanguage : _selectionLanguage;
    // Expand selection to the smart-selection boundary before saving
    final smartMode = ref.read(readerSmartSelectionModeProvider);
    final expanded = _applySmartSelection(
      _currentSelection!,
      _currentReadableText,
      smartMode,
    );
    await db.studyToolsDao.saveHighlight(
      textUid: widget.uid,
      startOffset: expanded.start,
      endOffset: expanded.end,
      colour: hexColor,
      language: lang,
    );
    _removeToolbarOverlay();
    setState(() => _currentSelection = null);
  }

  Future<void> _onDeleteOverlappingHighlights() async {
    if (_currentSelection == null || _currentSelection!.isCollapsed) return;
    final lang = _selectionLanguage.isEmpty ? _activeLanguage : _selectionLanguage;
    final highlights = ref
        .read(readerHighlightsProvider((widget.uid, lang)))
        .value;
    if (highlights == null) return;

    final start = _currentSelection!.start;
    final end = _currentSelection!.end;
    final db = ref.read(appDatabaseProvider);
    for (final h in highlights) {
      if (h.startOffset < end && h.endOffset > start) {
        await db.studyToolsDao.deleteHighlight(h.id);
      }
    }
    _removeToolbarOverlay();
    setState(() => _currentSelection = null);
  }

  void _onNoteRequested() {
    if (_currentSelection == null || _currentSelection!.isCollapsed) return;
    final lang =
        _selectionLanguage.isEmpty ? _activeLanguage : _selectionLanguage;
    final highlights = ref
        .read(readerHighlightsProvider((widget.uid, lang)))
        .value;
    if (highlights == null) return;

    final start = _currentSelection!.start;
    final end = _currentSelection!.end;
    // Find the first overlapping highlight.
    final highlight = highlights.cast<UserHighlight?>().firstWhere(
          (h) => h!.startOffset < end && h.endOffset > start,
          orElse: () => null,
        );
    if (highlight == null) return;

    _removeToolbarOverlay();
    setState(() => _currentSelection = null);
    _showHighlightNoteDialog(highlight);
  }

  void _onDictionaryRequested() {
    if (_currentSelection == null || _currentSelection!.isCollapsed) return;
    if (_currentReadableText.isEmpty) return;

    final start = _currentSelection!.start;
    final end = _currentSelection!.end;
    final selectedText = _currentReadableText
        .substring(
          start.clamp(0, _currentReadableText.length),
          end.clamp(0, _currentReadableText.length),
        )
        .trim();
    if (selectedText.isEmpty) return;

    // Use the first word if multiple words selected.
    final word = selectedText.split(RegExp(r'\s+')).first;
    _removeToolbarOverlay();
    setState(() => _currentSelection = null);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => DictionaryPopup(word: word),
    );
  }

  void _showHighlightNoteDialog(UserHighlight highlight) {
    final hasNote = highlight.note != null && highlight.note!.isNotEmpty;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _HighlightNoteSheet(
        highlight: highlight,
        isEditing: !hasNote,
        onSave: (text) {
          ref
              .read(appDatabaseProvider)
              .studyToolsDao
              .updateHighlightNote(highlight.id, text);
        },
        onDelete: () {
          ref
              .read(appDatabaseProvider)
              .studyToolsDao
              .updateHighlightNote(highlight.id, '');
        },
      ),
    );
  }

  // ── Pagination ──────────────────────────────────────────────────────────────

  void _onPageChanged(int page, int totalPages) {
    setState(() {
      _currentPage = page;
      _totalPages = totalPages;
    });

    // If navigated with scrollTo (e.g. from highlight tap), jump to the
    // page containing that character offset on the first pagination.
    if (!_didJumpToScrollTo && widget.scrollTo != null) {
      _didJumpToScrollTo = true;
      final targetPage =
          _paginatedKey.currentState?.pageForOffset(widget.scrollTo!) ?? 0;
      if (targetPage != page) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _paginatedKey.currentState?.goToPage(targetPage);
        });
        return; // goToPage will trigger another _onPageChanged
      }
    }

    // Save progress: encode page as negative value to distinguish from scroll.
    final db = ref.read(appDatabaseProvider);
    final isLastPage = page >= totalPages - 1;
    db.progressDao.upsertProgress(
      textUid: widget.uid,
      lastPosition: -(page + 1),
      completed: isLastPage,
    );
  }

  // ── Keyboard navigation ──────────────────────────────────────────────────

  void _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final key = event.logicalKey;
    final ctrl = HardwareKeyboard.instance.isControlPressed;

    if (ctrl && key == LogicalKeyboardKey.keyF) {
      _toggleSearch();
      return;
    }
    if (ctrl && key == LogicalKeyboardKey.keyD) {
      _cycleViewMode();
      return;
    }
    // Tab shortcuts
    if (ctrl && key == LogicalKeyboardKey.keyT) {
      context.push(Routes.library);
      return;
    }
    if (ctrl && key == LogicalKeyboardKey.keyW) {
      _closeCurrentTab();
      return;
    }
    final shift = HardwareKeyboard.instance.isShiftPressed;
    if (ctrl && key == LogicalKeyboardKey.tab) {
      if (shift) {
        ref.read(tabsProvider.notifier).prevTab();
      } else {
        ref.read(tabsProvider.notifier).nextTab();
      }
      final newActive = ref.read(tabsProvider).activeUid;
      if (newActive != null && newActive != widget.uid) {
        context.pushReplacement(Routes.readerPath(newActive));
      }
      return;
    }
    if (key == LogicalKeyboardKey.escape) {
      if (_showSearch) {
        setState(() {
          _showSearch = false;
          _searchMatches = [];
          _currentMatchIndex = -1;
        });
      } else if (_showHelp) {
        setState(() => _showHelp = false);
      }
      return;
    }
    if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.pageDown) {
      _paginatedKey.currentState?.nextPage();
    } else if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.pageUp) {
      _paginatedKey.currentState?.previousPage();
    }
  }

  // ── View mode cycling ─────────────────────────────────────────────────────

  void _cycleViewMode() {
    setState(() {
      switch (_viewMode) {
        case _ReaderViewMode.single:
          _viewMode = _ReaderViewMode.sideBySide;
        case _ReaderViewMode.sideBySide:
          _viewMode = _ReaderViewMode.interlinear;
        case _ReaderViewMode.interlinear:
          _viewMode = _ReaderViewMode.single;
      }
    });
  }

  // ── In-sutta search ───────────────────────────────────────────────────────

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchMatches = [];
        _currentMatchIndex = -1;
        _searchController.clear();
      } else {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => _searchFocusNode.requestFocus());
      }
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query == _searchQuery) return;
    _searchQuery = query;

    if (query.isEmpty || _currentReadableText.isEmpty) {
      setState(() {
        _searchMatches = [];
        _currentMatchIndex = -1;
      });
      return;
    }

    try {
      final pattern = RegExp(RegExp.escape(query), caseSensitive: false);
      final matches = pattern.allMatches(_currentReadableText).map((m) {
        return (start: m.start, end: m.end);
      }).toList();
      setState(() {
        _searchMatches = matches;
        _currentMatchIndex = matches.isEmpty ? -1 : 0;
      });
    } catch (_) {
      setState(() {
        _searchMatches = [];
        _currentMatchIndex = -1;
      });
    }
  }

  void _nextMatch() {
    if (_searchMatches.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex + 1) % _searchMatches.length;
    });
  }

  void _prevMatch() {
    if (_searchMatches.isEmpty) return;
    setState(() {
      _currentMatchIndex =
          (_currentMatchIndex - 1 + _searchMatches.length) %
              _searchMatches.length;
    });
  }

  // ── Notes ──────────────────────────────────────────────────────────────────

  void _showNoteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => NoteSheet(textUid: widget.uid),
    );
  }

  // ── Tab helpers ───────────────────────────────────────────────────────────

  void _closeCurrentTab() {
    ref.read(tabsProvider.notifier).closeTab(widget.uid);
    final tabState = ref.read(tabsProvider);
    if (tabState.activeUid != null && tabState.activeUid != widget.uid) {
      context.pushReplacement(Routes.readerPath(tabState.activeUid!));
    } else if (tabState.tabs.isEmpty) {
      context.pop();
    }
  }

  // ── Smart selection ───────────────────────────────────────────────────────

  /// Expands [selection] to the nearest boundary defined by [mode].
  TextSelection _applySmartSelection(
    TextSelection selection,
    String text,
    String mode,
  ) {
    if (text.isEmpty || selection.isCollapsed) return selection;
    if (mode == SmartSelectionMode.word) return selection;

    int start = selection.start.clamp(0, text.length);
    int end = selection.end.clamp(0, text.length);

    switch (mode) {
      case SmartSelectionMode.phrase:
        while (start > 0 &&
            !',;'.contains(text[start - 1]) &&
            text[start - 1] != '\n') {
          start--;
        }
        while (end < text.length &&
            !',;.!?'.contains(text[end]) &&
            text[end] != '\n') {
          end++;
        }
      case SmartSelectionMode.sentence:
        while (start > 0 &&
            !'.!?'.contains(text[start - 1]) &&
            text[start - 1] != '\n') {
          start--;
        }
        while (end < text.length && !'.!?'.contains(text[end])) {
          end++;
        }
        if (end < text.length) end++; // include the terminating punctuation
      case SmartSelectionMode.paragraph:
        while (start > 0 && text[start - 1] != '\n') {
          start--;
        }
        while (end < text.length && text[end] != '\n') {
          end++;
        }
    }

    return TextSelection(
      baseOffset: start.clamp(0, text.length),
      extentOffset: end.clamp(0, text.length),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _helpOverlay() {
    return Positioned.fill(
      child: ReaderHelpOverlay(
        onDismiss: () => setState(() => _showHelp = false),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  void _navigateToSutta(String uid) {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;
    ref.read(tabsProvider.notifier).replaceTab(widget.uid, uid);
    context.pushReplacement(Routes.readerPath(uid));
  }

  @override
  Widget build(BuildContext context) {
    final lang = _activeLanguage.isEmpty ? widget.language : _activeLanguage;
    final suttaAsync = ref.watch(readerSuttaProvider((widget.uid, lang)));
    final isBookmarkedAsync = ref.watch(readerIsBookmarkedProvider(widget.uid));
    final fontSize = ref.watch(readerFontSizeProvider);
    final lineSpacing = ref.watch(readerLineSpacingProvider);
    final fontFamily = ref.watch(readerFontFamilyProvider);
    final textColorHex = ref.watch(readerTextColorProvider);
    final margin = ref.watch(readerMarginProvider);
    final textColorValue = textColorHex.isEmpty
        ? null
        : Color(int.parse(
            'FF${textColorHex.replaceFirst('#', '')}',
            radix: 16,
          ));
    final bgColorHex = ref.watch(readerBgColorProvider);
    final bgColorValue = bgColorHex.isEmpty
        ? null
        : Color(int.parse(
            'FF${bgColorHex.replaceFirst('#', '')}',
            radix: 16,
          ));
    final highlightsAsync =
        ref.watch(readerHighlightsProvider((widget.uid, lang)));
    final noteAsync = ref.watch(readerNoteProvider(widget.uid));
    final needsPali = _viewMode == _ReaderViewMode.sideBySide ||
        _viewMode == _ReaderViewMode.interlinear;
    final paliAsync =
        needsPali ? ref.watch(readerPaliSuttaProvider(widget.uid)) : null;
    // Only fetch adjacent for non-range UIDs (ranges don't have adjacency).
    final adjacentAsync = !isRangeUid(widget.uid)
        ? ref.watch(readerAdjacentProvider((widget.uid, lang)))
        : null;

    return Scaffold(
      backgroundColor: bgColorValue ?? Theme.of(context).colorScheme.surface,
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
              tooltip: isBookmarked ? context.l10n.readerRemoveBookmark : context.l10n.readerBookmark,
              onPressed: () {
                if (suttaAsync.value != null) {
                  _toggleBookmark(suttaAsync.value!);
                }
              },
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          // TTS button
          Consumer(
            builder: (context, ref, _) {
              final ttsState = ref.watch(ttsStateProvider).value ?? TtsState.stopped;
              return IconButton(
                icon: Icon(
                  ttsState == TtsState.playing
                      ? Icons.stop_circle_outlined
                      : Icons.volume_up_outlined,
                  color: ttsState == TtsState.playing ? AppColors.green : null,
                ),
                tooltip: ttsState == TtsState.playing ? 'Stop reading' : 'Read aloud',
                onPressed: () {
                  final tts = ref.read(ttsServiceProvider);
                  if (ttsState == TtsState.playing) {
                    tts.stop();
                  } else if (suttaAsync.value != null) {
                    final text = suttaAsync.value!.contentPlain ?? '';
                    if (text.isNotEmpty) {
                      tts.speak(text, language: lang);
                    }
                  }
                },
              );
            },
          ),
          // In-sutta search button
          IconButton(
            icon: Icon(
              Icons.search,
              color: _showSearch ? AppColors.green : null,
            ),
            tooltip: 'Search in sutta (Ctrl+F)',
            onPressed: _toggleSearch,
          ),
          // Compare translations button
          IconButton(
            icon: Icon(
              Icons.compare_arrows,
              color: _showCompare ? AppColors.green : null,
            ),
            tooltip: 'Compare translations',
            onPressed: () => setState(() => _showCompare = !_showCompare),
          ),
          // View settings button
          IconButton(
            icon: const Icon(Icons.text_fields_outlined),
            tooltip: 'View settings',
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const ViewSettingsSheet(),
            ),
          ),
          // Help button
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Reader guide',
            onPressed: () => setState(() => _showHelp = true),
          ),
          // Note button
          IconButton(
            icon: Icon(
              noteAsync.value != null
                  ? Icons.note
                  : Icons.note_add_outlined,
              color:
                  noteAsync.value != null ? AppColors.green : null,
            ),
            tooltip: context.l10n.readerNotes,
            onPressed: () => _showNoteSheet(context),
          ),
          // Overflow menu
          if (suttaAsync.value != null)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                final sutta = suttaAsync.value!;
                if (value == 'share') _share(sutta);
                if (value == 'share_image') _shareAsImage(sutta);
                if (value == 'pdf') _exportPdf(sutta);
                if (value == 'commentary') {
                  setState(() => _showCommentary = !_showCommentary);
                }
                if (value == 'collection') {
                  showAddToCollectionSheet(context, ref, widget.uid);
                }
                if (value == 'my_translation') {
                  setState(
                      () => _showMyTranslation = !_showMyTranslation);
                }
                if (value == 'add_annotation') {
                  showAddCommentaryDialog(context, ref, widget.uid);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'share', child: Text(context.l10n.readerSharePassage)),
                const PopupMenuItem(value: 'share_image', child: Text('Share as Image')),
                PopupMenuItem(value: 'pdf', child: Text(context.l10n.readerExportPdf)),
                PopupMenuItem(
                    value: 'collection', child: Text(context.l10n.readerAddToCollection)),
                PopupMenuItem(
                  value: 'my_translation',
                  child: Text(_showMyTranslation
                      ? context.l10n.readerHideMyTranslation
                      : context.l10n.readerMyTranslation),
                ),
                PopupMenuItem(
                    value: 'add_annotation',
                    child: Text(context.l10n.readerAddAnnotation)),
                PopupMenuItem(
                  value: 'commentary',
                  child: Text(_showCommentary
                      ? context.l10n.readerHideCommentary
                      : context.l10n.readerShowCommentary),
                ),
              ],
            ),
        ],
      ),
      body: ColoredBox(
        color: bgColorValue ?? Theme.of(context).colorScheme.surface,
        child: Column(
        children: [
          SuttaTabBar(currentUid: widget.uid),
          Expanded(child: suttaAsync.when(
        loading: () => const LoadingShimmer(),
        error: (e, _) => ErrorState(message: friendlyError(e)),
        data: (sutta) {
          if (sutta == null) {
            return ErrorState(
                message: context.l10n.readerSuttaNotFound);
          }

          final highlights = highlightsAsync.value ?? [];
          final communityHl = _showCommunityHighlights
              ? (ref.watch(communityHighlightsProvider(widget.uid)).value ?? [])
              : <CommunityHighlight>[];

          // Parallel comparison mode (shown as full overlay)
          if (_showCompare) {
            return ParallelComparisonView(
              uid: widget.uid,
              primaryLanguage: lang,
            );
          }

          // Side-by-side or interlinear — require Pali data
          if ((_viewMode == _ReaderViewMode.sideBySide ||
                  _viewMode == _ReaderViewMode.interlinear) &&
              paliAsync != null) {
            final paliSutta = paliAsync.value;
            if (paliSutta != null) {
              if (_viewMode == _ReaderViewMode.interlinear) {
                return Stack(children: [
                  Column(children: [
                    _Toolbar(
                      uid: widget.uid,
                      activeLanguage: lang,
                      onLanguageChanged: (l) =>
                          setState(() => _activeLanguage = l),
                      viewMode: _viewMode,
                      onCycleViewMode: _cycleViewMode,
                      showSplitToggle: true,
                      showCommunityHighlights: _showCommunityHighlights,
                      onToggleCommunityHighlights: () => setState(() =>
                          _showCommunityHighlights = !_showCommunityHighlights),
                    ),
                    Expanded(
                      child: InterlinearReaderView(
                        primarySutta: sutta,
                        paliSutta: paliSutta,
                        fontSize: fontSize,
                        lineSpacing: lineSpacing,
                      ),
                    ),
                  ]),
                  if (_showHelp) _helpOverlay(),
                ]);
              }

              // Side-by-side
              final paliHighlights = ref
                      .watch(readerHighlightsProvider((widget.uid, 'pli')))
                      .value ??
                  [];
              final splitPaginated = ref.watch(readerPaginatedProvider);
              return Stack(children: [
                Column(
                  children: [
                    _Toolbar(
                      uid: widget.uid,
                      activeLanguage: lang,
                      onLanguageChanged: (l) =>
                          setState(() => _activeLanguage = l),
                      viewMode: _viewMode,
                      onCycleViewMode: _cycleViewMode,
                      showSplitToggle: true,
                      showCommunityHighlights: _showCommunityHighlights,
                      onToggleCommunityHighlights: () => setState(() =>
                          _showCommunityHighlights = !_showCommunityHighlights),
                    ),
                    Expanded(
                      child: SplitReaderView(
                        key: _splitKey,
                        primarySutta: sutta,
                        paliSutta: paliSutta,
                        primaryHighlights: highlights,
                        paliHighlights: paliHighlights,
                        fontSize: fontSize,
                        lineSpacing: lineSpacing,
                        activeLanguage: lang,
                        isPaginated: splitPaginated,
                        onSelectionChanged: _onSelectionChanged,
                        onNoteTapped: _showHighlightNoteDialog,
                        onPageChanged: (page, total) {
                          setState(() {
                            _currentPage = page;
                            _totalPages = total;
                          });
                        },
                      ),
                    ),
                    if (splitPaginated)
                      _PageIndicatorBar(
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                        onPrevPage: () =>
                            _splitKey.currentState?.previousPage(),
                        onNextPage: () =>
                            _splitKey.currentState?.nextPage(),
                      ),
                  ],
                ),
                if (_showHelp) _helpOverlay(),
              ]);
            }
          }

          // Single view mode
          final readableText = sutta.contentHtml != null
              ? htmlToReadableText(sutta.contentHtml!)
              : sutta.contentPlain ?? '';
          _currentReadableText = readableText;

          final prevUid = adjacentAsync?.value?.$1;
          final nextUid = adjacentAsync?.value?.$2;
          final isPaginated = ref.watch(readerPaginatedProvider);

          return Stack(
            children: [
              Column(
                children: [
                  _Toolbar(
                    uid: widget.uid,
                    activeLanguage: lang,
                    onLanguageChanged: (l) =>
                        setState(() => _activeLanguage = l),
                    viewMode: _viewMode,
                    onCycleViewMode: _cycleViewMode,
                    showSplitToggle: true,
                    showCommunityHighlights: _showCommunityHighlights,
                    onToggleCommunityHighlights: () => setState(() =>
                        _showCommunityHighlights = !_showCommunityHighlights),
                  ),
                  // In-sutta search bar
                  if (_showSearch) _SearchBar(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    matchCount: _searchMatches.length,
                    currentMatch: _currentMatchIndex,
                    onNext: _nextMatch,
                    onPrev: _prevMatch,
                    onClose: () {
                      setState(() {
                        _showSearch = false;
                        _searchMatches = [];
                        _currentMatchIndex = -1;
                        _searchController.clear();
                      });
                    },
                  ),
                  Expanded(
                    child: isPaginated
                        ? KeyboardListener(
                            focusNode: _keyboardFocusNode,
                            autofocus: true,
                            onKeyEvent: _onKeyEvent,
                            child: PaginatedReaderView(
                              key: _paginatedKey,
                              text: readableText,
                              highlights: highlights,
                              fontSize: fontSize,
                              lineSpacing: lineSpacing,
                              initialPage: _restoredPage,
                              onSelectionChanged: (sel, cause) =>
                                  _onSelectionChanged(sel, cause),
                              onNoteTapped: _showHighlightNoteDialog,
                              onPageChanged: _onPageChanged,
                              onLastPageReached: () {
                                final db = ref.read(appDatabaseProvider);
                                db.progressDao.upsertProgress(
                                  textUid: widget.uid,
                                  lastPosition: -(_totalPages),
                                  completed: true,
                                );
                              },
                            ),
                          )
                        : GestureDetector(
                            onHorizontalDragEnd: (details) {
                              final velocity = details.primaryVelocity ?? 0;
                              if (velocity > 300 && prevUid != null) {
                                _navigateToSutta(prevUid);
                              } else if (velocity < -300 && nextUid != null) {
                                _navigateToSutta(nextUid);
                              }
                            },
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              padding: EdgeInsets.symmetric(
                                horizontal: ReaderMargin.horizontalPadding[margin] ?? AppSizes.md,
                                vertical: AppSizes.lg,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HighlightedText(
                                    text: readableText,
                                    highlights: highlights,
                                    communityHighlights: communityHl,
                                    fontSize: fontSize,
                                    lineSpacing: lineSpacing,
                                    fontFamily: fontFamily,
                                    textColor: textColorValue,
                                    onSelectionChanged: (sel, cause) =>
                                        _onSelectionChanged(sel, cause),
                                    onNoteTapped: _showHighlightNoteDialog,
                                    searchMatches: _searchMatches,
                                    currentSearchMatch: _currentMatchIndex,
                                  ),
                                  if (_showMyTranslation)
                                    MyTranslationView(
                                      suttaUid: widget.uid,
                                      fontSize: fontSize,
                                      lineSpacing: lineSpacing,
                                    ),
                                  if (_showCommentary)
                                    CommentaryView(suttaUid: widget.uid),
                                  const SizedBox(height: AppSizes.xl),
                                  ParallelsSection(uid: widget.uid),
                                  const SizedBox(height: AppSizes.lg),
                                  TranslatorAttributionWidget(
                                    translator: sutta.translator,
                                    source: sutta.source ?? 'sc',
                                    uid: sutta.uid,
                                  ),
                                  const SizedBox(height: AppSizes.xxl),
                                ],
                              ),
                            ),
                          ),
                  ),
                  if (isPaginated)
                    _PageIndicatorBar(
                      currentPage: _currentPage,
                      totalPages: _totalPages,
                      prevUid: prevUid,
                      nextUid: nextUid,
                      onPrevPage: () =>
                          _paginatedKey.currentState?.previousPage(),
                      onNextPage: () =>
                          _paginatedKey.currentState?.nextPage(),
                      onPrevSutta: prevUid != null
                          ? () => _navigateToSutta(prevUid)
                          : null,
                      onNextSutta: nextUid != null
                          ? () => _navigateToSutta(nextUid)
                          : null,
                    )
                  else if (prevUid != null || nextUid != null)
                    _ReaderBottomBar(
                      prevUid: prevUid,
                      nextUid: nextUid,
                      onPrev: prevUid != null
                          ? () => _navigateToSutta(prevUid)
                          : null,
                      onNext: nextUid != null
                          ? () => _navigateToSutta(nextUid)
                          : null,
                    ),
                ],
              ),
              if (_showHelp) _helpOverlay(),
            ],
          );
        },
          )),
        ],
        ),
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
    this.viewMode = _ReaderViewMode.single,
    this.onCycleViewMode,
    this.showSplitToggle = false,
    this.showCommunityHighlights = false,
    this.onToggleCommunityHighlights,
  });

  final String uid;
  final String activeLanguage;
  final ValueChanged<String> onLanguageChanged;
  final _ReaderViewMode viewMode;
  final VoidCallback? onCycleViewMode;
  final bool showSplitToggle;
  final bool showCommunityHighlights;
  final VoidCallback? onToggleCommunityHighlights;

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
            tooltip: context.l10n.readerSmaller,
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
            tooltip: context.l10n.readerLarger,
            onPressed: idx < sizes.length - 1
                ? () => ref.read(readerFontSizeProvider.notifier).increase()
                : null,
          ),
          const Spacer(),
          // Paginated / scroll toggle
          IconButton(
            icon: Icon(
              ref.watch(readerPaginatedProvider)
                  ? Icons.auto_stories
                  : Icons.view_day,
              size: 20,
              color: ref.watch(readerPaginatedProvider)
                  ? AppColors.green
                  : null,
            ),
            tooltip: ref.watch(readerPaginatedProvider)
                ? context.l10n.readerSwitchToScroll
                : context.l10n.readerSwitchToPages,
            onPressed: () =>
                ref.read(readerPaginatedProvider.notifier).toggle(),
          ),
          // View mode toggle (cycles single → side-by-side → interlinear)
          if (showSplitToggle)
            langsAsync.when(
              data: (langs) {
                if (!langs.contains('pli') || langs.length <= 1) {
                  return const SizedBox.shrink();
                }
                final (icon, tooltip) = switch (viewMode) {
                  _ReaderViewMode.single => (
                      Icons.view_day,
                      'Side-by-side (Ctrl+D)'
                    ),
                  _ReaderViewMode.sideBySide => (
                      Icons.view_column,
                      'Interlinear (Ctrl+D)'
                    ),
                  _ReaderViewMode.interlinear => (
                      Icons.view_agenda,
                      'Single view (Ctrl+D)'
                    ),
                };
                return IconButton(
                  icon: Icon(
                    icon,
                    size: 20,
                    color: viewMode != _ReaderViewMode.single
                        ? AppColors.green
                        : null,
                  ),
                  tooltip: tooltip,
                  onPressed: onCycleViewMode,
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          // Community highlights toggle
          if (onToggleCommunityHighlights != null)
            CommunityHighlightToggle(
              enabled: showCommunityHighlights,
              onChanged: (_) => onToggleCommunityHighlights!(),
            ),
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

// ── Bottom nav bar ───────────────────────────────────────────────────────────

class _PageIndicatorBar extends StatelessWidget {
  const _PageIndicatorBar({
    required this.currentPage,
    required this.totalPages,
    this.prevUid,
    this.nextUid,
    this.onPrevPage,
    this.onNextPage,
    this.onPrevSutta,
    this.onNextSutta,
  });

  final int currentPage;
  final int totalPages;
  final String? prevUid;
  final String? nextUid;
  final VoidCallback? onPrevPage;
  final VoidCallback? onNextPage;
  final VoidCallback? onPrevSutta;
  final VoidCallback? onNextSutta;

  @override
  Widget build(BuildContext context) {
    final isFirstPage = currentPage == 0;
    final isLastPage = currentPage >= totalPages - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Prev sutta (skip back)
            IconButton(
              onPressed: onPrevSutta,
              icon: const Icon(Icons.skip_previous, size: 20),
              tooltip: context.l10n.readerPrevSutta,
              color: AppColors.green,
              visualDensity: VisualDensity.compact,
            ),
            // Prev page
            IconButton(
              onPressed: isFirstPage ? null : onPrevPage,
              icon: const Icon(Icons.chevron_left),
              tooltip: context.l10n.readerPrevPage,
              color: AppColors.green,
              visualDensity: VisualDensity.compact,
            ),
            const Spacer(),
            // Page indicator
            Semantics(
              label: totalPages > 0
                  ? context.l10n.readerPageOf(currentPage + 1, totalPages)
                  : '',
              child: Text(
              totalPages > 0
                  ? context.l10n.readerPageOf(currentPage + 1, totalPages)
                  : '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            ),
            const Spacer(),
            // Next page
            IconButton(
              onPressed: isLastPage ? null : onNextPage,
              icon: const Icon(Icons.chevron_right),
              tooltip: context.l10n.readerNextPage,
              color: AppColors.green,
              visualDensity: VisualDensity.compact,
            ),
            // Next sutta (skip forward)
            IconButton(
              onPressed: onNextSutta,
              icon: const Icon(Icons.skip_next, size: 20),
              tooltip: context.l10n.readerNextSutta,
              color: AppColors.green,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderBottomBar extends StatelessWidget {
  const _ReaderBottomBar({
    this.prevUid,
    this.nextUid,
    this.onPrev,
    this.onNext,
  });

  final String? prevUid;
  final String? nextUid;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            TextButton.icon(
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left, size: 20),
              label: Text(context.l10n.readerPrevious),
              style: TextButton.styleFrom(
                foregroundColor: onPrev != null
                    ? AppColors.green
                    : Colors.grey.withValues(alpha: 0.4),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right, size: 20),
              iconAlignment: IconAlignment.end,
              label: Text(context.l10n.readerNext),
              style: TextButton.styleFrom(
                foregroundColor: onNext != null
                    ? AppColors.green
                    : Colors.grey.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Highlight note sheet ─────────────────────────────────────────────────────

class _HighlightNoteSheet extends StatefulWidget {
  const _HighlightNoteSheet({
    required this.highlight,
    required this.onSave,
    required this.onDelete,
    this.isEditing = false,
  });

  final UserHighlight highlight;
  final void Function(String text) onSave;
  final VoidCallback onDelete;
  final bool isEditing;

  @override
  State<_HighlightNoteSheet> createState() => _HighlightNoteSheetState();
}

class _HighlightNoteSheetState extends State<_HighlightNoteSheet> {
  late final TextEditingController _controller;
  late bool _editing;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.highlight.note ?? '');
    _editing = widget.isEditing;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_controller.text.trim());
    setState(() => _editing = false);
  }

  void _share() {
    final note = _controller.text.trim();
    if (note.isEmpty) return;
    Share.share(note, subject: 'Highlight note');
  }

  void _delete() {
    widget.onDelete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final note = widget.highlight.note ?? '';

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 420),
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
                const Icon(Icons.sticky_note_2_outlined,
                    color: AppColors.green),
                const SizedBox(width: 8),
                Text(
                  context.l10n.readerHighlightNote,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Content
            if (_editing)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: context.l10n.readerWriteNoteHint,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (note.isNotEmpty) {
                              _controller.text = note;
                              setState(() => _editing = false);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text(context.l10n.cancel),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: _save,
                          child: Text(context.l10n.save),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else ...[
              // Note text
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      note,
                      style: const TextStyle(fontSize: 15, height: 1.6),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              const SizedBox(height: 8),
              // Action bar — clearly visible labeled buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () => setState(() => _editing = true),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(context.l10n.readerEdit),
                  ),
                  TextButton.icon(
                    onPressed: _share,
                    icon: const Icon(Icons.share_outlined),
                    label: Text(context.l10n.readerShare),
                  ),
                  TextButton.icon(
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    label: Text(context.l10n.readerDelete,
                        style: const TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── In-sutta search bar ───────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.matchCount,
    required this.currentMatch,
    required this.onNext,
    required this.onPrev,
    required this.onClose,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int matchCount;
  final int currentMatch;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final hasMatches = matchCount > 0;
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding:
          const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Search in sutta…',
                border: InputBorder.none,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                suffixText: hasMatches
                    ? '${currentMatch + 1}/$matchCount'
                    : (controller.text.isNotEmpty ? 'No results' : null),
                suffixStyle: TextStyle(
                  fontSize: 12,
                  color: hasMatches
                      ? AppColors.green
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up, size: 20),
            onPressed: hasMatches ? onPrev : null,
            visualDensity: VisualDensity.compact,
            tooltip: 'Previous match',
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, size: 20),
            onPressed: hasMatches ? onNext : null,
            visualDensity: VisualDensity.compact,
            tooltip: 'Next match',
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onClose,
            visualDensity: VisualDensity.compact,
            tooltip: 'Close search',
          ),
        ],
      ),
    );
  }
}
