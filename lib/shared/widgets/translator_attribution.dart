import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

/// Displays translator name, source organisation, and CC-BY licence notice.
///
/// Required by the Creative Commons Attribution licence under which
/// SuttaCentral translations are published.
class TranslatorAttributionWidget extends StatelessWidget {
  const TranslatorAttributionWidget({
    super.key,
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
    final sourceLabel = switch (source) {
      'sc' => 'SuttaCentral',
      'ati' => 'Access to Insight',
      _ => source,
    };

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
            'Source: $sourceLabel \u00b7 $uid',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'This translation is published under a Creative Commons '
            'Attribution licence (CC BY).',
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
