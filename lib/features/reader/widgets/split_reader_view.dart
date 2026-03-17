import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../data/database/app_database.dart';
import '../utils/html_parser.dart';
import 'highlighted_text.dart';

/// Displays two sutta texts side-by-side with synchronized scrolling.
/// Each column scrolls independently, but moving one column syncs the
/// other by scroll percentage so both stay roughly aligned.
class SplitReaderView extends StatefulWidget {
  const SplitReaderView({
    super.key,
    required this.primarySutta,
    required this.paliSutta,
    required this.primaryHighlights,
    required this.paliHighlights,
    required this.fontSize,
    this.lineSpacing = 1.7,
    this.onSelectionChanged,
    this.onNoteTapped,
    this.activeLanguage = 'en',
    this.isPaginated = false,
    this.onPageChanged,
  });

  final SuttaText primarySutta;
  final SuttaText paliSutta;
  final List<UserHighlight> primaryHighlights;
  final List<UserHighlight> paliHighlights;
  final double fontSize;
  final double lineSpacing;
  final void Function(
    TextSelection selection,
    SelectionChangedCause? cause,
    String language,
  )? onSelectionChanged;
  final void Function(UserHighlight highlight)? onNoteTapped;
  final String activeLanguage;
  final bool isPaginated;
  final void Function(int page, int totalPages)? onPageChanged;

  @override
  State<SplitReaderView> createState() => SplitReaderViewState();
}

class SplitReaderViewState extends State<SplitReaderView> {
  final _primaryController = ScrollController();
  final _paliController = ScrollController();
  bool _isSyncing = false;

  void nextPage() {}
  void previousPage() {}

  @override
  void initState() {
    super.initState();
    _primaryController.addListener(_onPrimaryScroll);
    _paliController.addListener(_onPaliScroll);
  }

  @override
  void dispose() {
    _primaryController.removeListener(_onPrimaryScroll);
    _paliController.removeListener(_onPaliScroll);
    _primaryController.dispose();
    _paliController.dispose();
    super.dispose();
  }

  void _onPrimaryScroll() {
    if (_isSyncing) return;
    _syncScroll(_primaryController, _paliController);
  }

  void _onPaliScroll() {
    if (_isSyncing) return;
    _syncScroll(_paliController, _primaryController);
  }

  void _syncScroll(ScrollController source, ScrollController target) {
    if (!source.hasClients || !target.hasClients) return;
    final sourceMax = source.position.maxScrollExtent;
    final targetMax = target.position.maxScrollExtent;
    if (sourceMax <= 0 || targetMax <= 0) return;

    final percent = source.offset / sourceMax;
    final targetOffset = (percent * targetMax).clamp(0.0, targetMax);

    _isSyncing = true;
    target.jumpTo(targetOffset);
    _isSyncing = false;
  }

  String _getText(SuttaText sutta) {
    if (sutta.contentHtml != null) {
      return htmlToReadableText(sutta.contentHtml!);
    }
    return sutta.contentPlain ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final primaryText = _getText(widget.primarySutta);
    final paliText = _getText(widget.paliSutta);

    return Column(
      children: [
        // Header row
        Row(
          children: [
            Expanded(
              child:
                  _ColumnHeader(label: widget.activeLanguage.toUpperCase()),
            ),
            const SizedBox(
              height: 24,
              child: VerticalDivider(width: 1),
            ),
            const Expanded(
              child: _ColumnHeader(label: 'PLI'),
            ),
          ],
        ),
        // Side-by-side content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primary (English) side
              Expanded(
                child: SingleChildScrollView(
                  controller: _primaryController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  child: HighlightedText(
                    text: primaryText,
                    highlights: widget.primaryHighlights,
                    fontSize: widget.fontSize,
                    lineSpacing: widget.lineSpacing,
                    onSelectionChanged: (sel, cause) {
                      widget.onSelectionChanged
                          ?.call(sel, cause, widget.activeLanguage);
                    },
                    onNoteTapped: widget.onNoteTapped,
                  ),
                ),
              ),
              // Divider
              Container(
                width: 1,
                color:
                    Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
              // Pāli side
              Expanded(
                child: SingleChildScrollView(
                  controller: _paliController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  child: HighlightedText(
                    text: paliText,
                    highlights: widget.paliHighlights,
                    fontSize: widget.fontSize,
                    lineSpacing: widget.lineSpacing,
                    onSelectionChanged: (sel, cause) {
                      widget.onSelectionChanged
                          ?.call(sel, cause, 'pli');
                    },
                    onNoteTapped: widget.onNoteTapped,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColumnHeader extends StatelessWidget {
  const _ColumnHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(vertical: 4, horizontal: AppSizes.md),
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.3),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}
