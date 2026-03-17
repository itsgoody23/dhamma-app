import 'package:flutter/material.dart';

import '../../../data/database/app_database.dart';
import 'highlighted_text.dart';

/// Kindle-style paginated reader that splits text into screen-sized pages.
///
/// Uses [TextPainter] to measure how much text fits on each page, then
/// renders each page as a [HighlightedText] widget inside a [PageView].
class PaginatedReaderView extends StatefulWidget {
  const PaginatedReaderView({
    super.key,
    required this.text,
    required this.highlights,
    required this.fontSize,
    this.lineSpacing = 1.7,
    this.onSelectionChanged,
    this.onPageChanged,
    this.onLastPageReached,
    this.onNoteTapped,
    this.initialPage = 0,
  });

  final String text;
  final List<UserHighlight> highlights;
  final double fontSize;
  final double lineSpacing;
  final void Function(TextSelection selection, SelectionChangedCause? cause)?
      onSelectionChanged;
  final void Function(int page, int totalPages)? onPageChanged;
  final VoidCallback? onLastPageReached;
  final void Function(UserHighlight highlight)? onNoteTapped;
  final int initialPage;

  @override
  State<PaginatedReaderView> createState() => PaginatedReaderViewState();
}

class PaginatedReaderViewState extends State<PaginatedReaderView> {
  PageController? _pageController;
  List<_PageSlice> _pages = [];
  int _currentPage = 0;
  Size _lastSize = Size.zero;

  int get currentPage => _currentPage;
  int get totalPages => _pages.length;

  /// Returns the page index that contains the given character offset.
  int pageForOffset(int charOffset) {
    for (var i = 0; i < _pages.length; i++) {
      if (charOffset < _pages[i].charEnd) return i;
    }
    return _pages.length - 1;
  }

  void goToPage(int page) {
    final target = page.clamp(0, _pages.length - 1);
    _pageController?.animateToPage(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void nextPage() => goToPage(_currentPage + 1);
  void previousPage() => goToPage(_currentPage - 1);

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PaginatedReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.fontSize != widget.fontSize ||
        oldWidget.lineSpacing != widget.lineSpacing) {
      // Force repagination on next build.
      _lastSize = Size.zero;
    }
  }

  void _paginate(Size size) {
    if (size == _lastSize &&
        _pages.isNotEmpty) {
      return;
    }
    _lastSize = size;
    final isFirstPagination = _pages.isEmpty;

    const horizontalPadding = 24.0; // padding on each side
    final availableWidth = size.width - horizontalPadding * 2;
    const verticalPadding = 20.0;
    final availableHeight = size.height - verticalPadding * 2;

    if (availableWidth <= 0 || availableHeight <= 0) return;

    final textStyle = TextStyle(
      fontSize: widget.fontSize,
      height: widget.lineSpacing,
    );

    final pages = <_PageSlice>[];
    var charStart = 0;
    final text = widget.text;

    while (charStart < text.length) {
      // Binary search for how much text fits on this page.
      final charEnd = _findPageBreak(
        text,
        charStart,
        availableWidth,
        availableHeight,
        textStyle,
      );

      pages.add(_PageSlice(charStart: charStart, charEnd: charEnd));
      charStart = charEnd;
    }

    // Ensure at least one page even for empty text.
    if (pages.isEmpty) {
      pages.add(const _PageSlice(charStart: 0, charEnd: 0));
    }

    final oldPage = _currentPage;
    _pages = pages;

    // Clamp current page to valid range.
    if (_currentPage >= _pages.length) {
      _currentPage = _pages.length - 1;
    }

    // Recreate page controller if page changed or first time.
    if (_pageController == null || oldPage != _currentPage) {
      _pageController?.dispose();
      _pageController = PageController(initialPage: _currentPage);
    }

    // Notify parent of initial page count so the indicator bar appears.
    if (isFirstPagination) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onPageChanged?.call(_currentPage, _pages.length);
      });
    }
  }

  int _findPageBreak(
    String text,
    int charStart,
    double availableWidth,
    double availableHeight,
    TextStyle style,
  ) {
    var lo = 1;
    var hi = text.length - charStart;

    // Quick check: does all remaining text fit?
    if (_textFits(text, charStart, charStart + hi, availableWidth, availableHeight, style)) {
      return charStart + hi;
    }

    // Binary search for the maximum amount of text that fits.
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (_textFits(text, charStart, charStart + mid, availableWidth, availableHeight, style)) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }

    var charEnd = charStart + lo;

    // Walk back to a paragraph or word boundary for clean breaks.
    final candidate = charEnd;

    // Try paragraph boundary first (last newline before cutoff).
    final lastNewline = text.lastIndexOf('\n', candidate - 1);
    if (lastNewline > charStart && (candidate - lastNewline) < candidate - charStart) {
      charEnd = lastNewline + 1;
    } else {
      // Fall back to word boundary.
      final lastSpace = text.lastIndexOf(RegExp(r'\s'), candidate - 1);
      if (lastSpace > charStart) {
        charEnd = lastSpace + 1;
      }
    }

    // Safety: always make progress.
    if (charEnd <= charStart) {
      charEnd = candidate;
    }

    return charEnd;
  }

  bool _textFits(
    String text,
    int start,
    int end,
    double width,
    double height,
    TextStyle style,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text.substring(start, end.clamp(start, text.length)),
        style: style,
      ),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: width);

    final fits = painter.height <= height;
    painter.dispose();
    return fits;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _paginate(size);

        // Ensure controller exists.
        _pageController ??= PageController(initialPage: _currentPage);

        return PageView.builder(
          controller: _pageController,
          itemCount: _pages.length,
          onPageChanged: (page) {
            setState(() => _currentPage = page);
            widget.onPageChanged?.call(page, _pages.length);
            if (page == _pages.length - 1) {
              widget.onLastPageReached?.call();
            }
          },
          itemBuilder: (context, index) {
            final slice = _pages[index];
            final pageText = widget.text.substring(
              slice.charStart,
              slice.charEnd.clamp(0, widget.text.length),
            );

            // Remap highlights to page-local offsets.
            final pageHighlights = widget.highlights
                .where((h) =>
                    h.startOffset < slice.charEnd &&
                    h.endOffset > slice.charStart)
                .map((h) => _remapHighlight(h, slice.charStart))
                .toList();

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: HighlightedText(
                text: pageText,
                highlights: pageHighlights,
                fontSize: widget.fontSize,
                lineSpacing: widget.lineSpacing,
                onNoteTapped: widget.onNoteTapped,
                onSelectionChanged: (sel, cause) {
                  // Remap selection back to global offsets.
                  final globalSel = TextSelection(
                    baseOffset: sel.baseOffset + slice.charStart,
                    extentOffset: sel.extentOffset + slice.charStart,
                  );
                  widget.onSelectionChanged?.call(globalSel, cause);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// Remaps a highlight's offsets to be relative to a page's charStart.
  UserHighlight _remapHighlight(UserHighlight h, int pageCharStart) {
    return UserHighlight(
      id: h.id,
      textUid: h.textUid,
      startOffset: (h.startOffset - pageCharStart).clamp(0, 999999),
      endOffset: (h.endOffset - pageCharStart).clamp(0, 999999),
      colour: h.colour,
      language: h.language,
      note: h.note,
      userId: h.userId,
      createdAt: h.createdAt,
      updatedAt: h.updatedAt,
      syncedAt: h.syncedAt,
      isDeleted: h.isDeleted,
    );
  }
}

class _PageSlice {
  const _PageSlice({required this.charStart, required this.charEnd});
  final int charStart;
  final int charEnd;
}
