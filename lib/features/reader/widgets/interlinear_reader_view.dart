import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../data/database/app_database.dart';
import '../utils/html_parser.dart';

/// Interlinear display mode: each paragraph of the Pali sutta is shown
/// directly above the corresponding English paragraph. Both texts are inline
/// in a single scrollable column — no scroll synchronization needed.
class InterlinearReaderView extends StatelessWidget {
  const InterlinearReaderView({
    super.key,
    required this.primarySutta,
    required this.paliSutta,
    required this.fontSize,
    this.lineSpacing = 1.7,
  });

  final SuttaText primarySutta;
  final SuttaText paliSutta;
  final double fontSize;
  final double lineSpacing;

  List<String> _paragraphs(SuttaText sutta) {
    final text = sutta.contentHtml != null
        ? htmlToReadableText(sutta.contentHtml!)
        : (sutta.contentPlain ?? '');
    // Split on double newlines (paragraph boundaries).
    return text
        .split(RegExp(r'\n{2,}'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final paliParagraphs = _paragraphs(paliSutta);
    final englishParagraphs = _paragraphs(primarySutta);
    final count =
        paliParagraphs.length > englishParagraphs.length
            ? paliParagraphs.length
            : englishParagraphs.length;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md, vertical: AppSizes.lg),
      itemCount: count,
      itemBuilder: (context, index) {
        final pali =
            index < paliParagraphs.length ? paliParagraphs[index] : '';
        final english =
            index < englishParagraphs.length ? englishParagraphs[index] : '';

        return _InterlinearPair(
          pali: pali,
          english: english,
          fontSize: fontSize,
          lineSpacing: lineSpacing,
        );
      },
    );
  }
}

class _InterlinearPair extends StatelessWidget {
  const _InterlinearPair({
    required this.pali,
    required this.english,
    required this.fontSize,
    required this.lineSpacing,
  });

  final String pali;
  final String english;
  final double fontSize;
  final double lineSpacing;

  @override
  Widget build(BuildContext context) {
    final dimColor = Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: 0.45);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pali.isNotEmpty)
            SelectableText(
              pali,
              style: TextStyle(
                fontSize: fontSize * 0.92,
                height: lineSpacing,
                fontStyle: FontStyle.italic,
                color: dimColor,
              ),
            ),
          if (pali.isNotEmpty && english.isNotEmpty)
            const SizedBox(height: 4),
          if (english.isNotEmpty)
            SelectableText(
              english,
              style: TextStyle(
                fontSize: fontSize,
                height: lineSpacing,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
        ],
      ),
    );
  }
}
