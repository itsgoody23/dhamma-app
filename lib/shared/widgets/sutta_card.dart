import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import 'nikaya_badge.dart';

/// A reusable card widget that displays a sutta's title, nikaya, chapter, and
/// optional text excerpt/snippet. Taps navigate to the Reader screen.
///
/// Used in: search results, bookmarks list, study tools exports.
class SuttaCard extends StatelessWidget {
  const SuttaCard({
    super.key,
    required this.uid,
    required this.title,
    required this.nikaya,
    this.chapter,
    this.language,
    this.translatorName,
    this.snippet,
    this.trailing,
  });

  final String uid;
  final String title;
  final String nikaya;
  final String? chapter;
  final String? language;
  final String? translatorName;

  /// Optional excerpt or FTS5 snippet. May contain `<b>` tags for bold.
  final String? snippet;

  /// Optional widget placed at the far right (e.g. a bookmark icon).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.nikayaColor(nikaya);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: InkWell(
        onTap: () {
          final langParam = language != null ? '?lang=$language' : '';
          context.push('${Routes.readerPath(uid)}$langParam');
        },
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NikayaBadge(nikaya: nikaya),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (chapter != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        chapter!,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (snippet != null && snippet!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _SnippetText(snippet: snippet!),
                    ],
                    if (translatorName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        translatorName!,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSizes.sm),
                trailing!,
              ] else
                const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders a snippet string that may contain `<b>text</b>` bold markers
/// (as produced by SQLite FTS5 `snippet()`) as a [RichText] widget.
class _SnippetText extends StatelessWidget {
  const _SnippetText({required this.snippet});

  final String snippet;

  @override
  Widget build(BuildContext context) {
    final spans = _parse(snippet, context);
    return RichText(
      text: TextSpan(children: spans),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<TextSpan> _parse(String raw, BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: 12,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      height: 1.4,
    );
    final boldStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
    );

    final spans = <TextSpan>[];
    final parts = raw.split(RegExp(r'</?b>'));
    bool inBold = false;

    for (final part in parts) {
      if (part.isEmpty) {
        inBold = !inBold;
        continue;
      }
      spans.add(TextSpan(text: part, style: inBold ? boldStyle : baseStyle));
      inBold = !inBold;
    }

    return spans;
  }
}
