import 'package:flutter/material.dart';

import '../../../data/database/app_database.dart';
import '../../../data/services/community_service.dart';

/// Renders [text] as a [SelectableText.rich] with highlight ranges applied
/// as coloured backgrounds from the [highlights] list.
/// Optionally renders [searchMatches] as distinct yellow highlights for
/// in-sutta search results.
class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.highlights,
    required this.fontSize,
    this.lineSpacing = 1.7,
    this.fontFamily,
    this.textColor,
    this.onSelectionChanged,
    this.onNoteTapped,
    this.communityHighlights = const [],
    this.searchMatches = const [],
    this.currentSearchMatch = -1,
  });

  final String text;
  final List<UserHighlight> highlights;
  final double fontSize;
  final double lineSpacing;

  /// Optional font family override (e.g. 'NotoSerif', 'Palatino', 'NotoSans').
  /// Falls back to the theme font when null.
  final String? fontFamily;

  /// Optional text color override. Falls back to the theme body color when null.
  final Color? textColor;

  final void Function(TextSelection selection, SelectionChangedCause? cause)?
      onSelectionChanged;
  final void Function(UserHighlight highlight)? onNoteTapped;
  final List<CommunityHighlight> communityHighlights;

  /// Character offset ranges of in-sutta search results.
  final List<({int start, int end})> searchMatches;

  /// Index of the currently focused search match (highlighted differently).
  final int currentSearchMatch;

  @override
  Widget build(BuildContext context) {
    final spans = _buildSpans(context);
    return SelectableText.rich(
      TextSpan(children: spans),
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        height: lineSpacing,
        color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color,
      ),
      onSelectionChanged: onSelectionChanged,
    );
  }

  List<InlineSpan> _buildSpans(BuildContext context) {
    if (text.isEmpty) return [];
    if (highlights.isEmpty &&
        communityHighlights.isEmpty &&
        searchMatches.isEmpty) {
      return [TextSpan(text: text)];
    }

    // Sort highlights by start offset and filter out-of-range ones.
    final sorted = highlights
        .where((h) => h.startOffset < text.length && h.endOffset > 0)
        .toList()
      ..sort((a, b) => a.startOffset.compareTo(b.startOffset));

    // Convert community highlights to the same range format, rendered
    // with 30% alpha to distinguish from personal highlights.
    final communitySorted = communityHighlights
        .where((h) => h.startOffset < text.length && h.endOffset > 0)
        .toList()
      ..sort((a, b) => a.startOffset.compareTo(b.startOffset));

    // Merge personal and community highlights into a unified range list.
    final allRanges = <_HighlightRange>[];
    for (final hl in sorted) {
      allRanges.add(_HighlightRange(
        start: hl.startOffset.clamp(0, text.length),
        end: hl.endOffset.clamp(0, text.length),
        color: _parseHex(hl.colour),
        isCommunity: false,
        userHighlight: hl,
      ));
    }
    for (final ch in communitySorted) {
      allRanges.add(_HighlightRange(
        start: ch.startOffset.clamp(0, text.length),
        end: ch.endOffset.clamp(0, text.length),
        color: _parseHex(ch.colour).withValues(alpha: 0.3),
        isCommunity: true,
      ));
    }
    // Add search match ranges — rendered above other highlights.
    for (var i = 0; i < searchMatches.length; i++) {
      final m = searchMatches[i];
      if (m.start >= m.end || m.end > text.length) continue;
      allRanges.add(_HighlightRange(
        start: m.start.clamp(0, text.length),
        end: m.end.clamp(0, text.length),
        color: i == currentSearchMatch
            ? const Color(0xFFFF9800) // active match: orange
            : const Color(0xFFFFEB3B), // other matches: yellow
        isCommunity: false,
        isSearchMatch: true,
      ));
    }

    allRanges.sort((a, b) => a.start.compareTo(b.start));

    final spans = <InlineSpan>[];
    var cursor = 0;

    for (final range in allRanges) {
      if (range.start >= range.end) continue;

      // Gap before this highlight.
      if (cursor < range.start) {
        spans.add(TextSpan(text: text.substring(cursor, range.start)));
      }

      // Highlighted span.
      spans.add(TextSpan(
        text: text.substring(range.start, range.end),
        style: TextStyle(
          backgroundColor: range.color,
          color: range.isCommunity ? null : const Color(0xFF1C1A17),
        ),
      ));

      // Note indicator for personal highlights only (not search matches).
      if (!range.isCommunity && !range.isSearchMatch && range.userHighlight != null) {
        final hl = range.userHighlight!;
        if (hl.note != null && hl.note!.isNotEmpty) {
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: onNoteTapped != null
                  ? () => onNoteTapped!(hl)
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(left: 1, right: 2),
                child: Icon(
                  Icons.sticky_note_2_outlined,
                  size: fontSize * 0.7,
                  color: const Color(0xFF1C1A17).withValues(alpha: 0.5),
                ),
              ),
            ),
          ));
        }
      }

      cursor = range.end;
    }

    // Remaining text after last highlight.
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return spans;
  }

  Color _parseHex(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}

class _HighlightRange {
  const _HighlightRange({
    required this.start,
    required this.end,
    required this.color,
    required this.isCommunity,
    this.userHighlight,
    this.isSearchMatch = false,
  });

  final int start;
  final int end;
  final Color color;
  final bool isCommunity;
  final UserHighlight? userHighlight;
  final bool isSearchMatch;
}
