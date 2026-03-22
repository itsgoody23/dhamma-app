import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/routing/routes.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/providers/database_provider.dart';
import '../utils/html_parser.dart';
import 'highlighted_text.dart';

/// Provider that fetches available parallel UIDs for a given sutta.
final _parallelTextsProvider = FutureProvider.autoDispose
    .family<List<SuttaText>, String>((ref, uid) async {
  final db = ref.watch(appDatabaseProvider);
  // Get all available translations for this UID.
  final langs = await db.textsDao.getLanguagesForUid(uid);
  final texts = <SuttaText>[];
  for (final lang in langs) {
    final t = await db.textsDao.getSuttaByUid(uid, lang);
    if (t != null) texts.add(t);
  }
  return texts;
});

/// Multi-panel side-by-side view comparing different translations of the
/// same sutta. Panels scroll independently; linked scrolling can be toggled.
class ParallelComparisonView extends ConsumerStatefulWidget {
  const ParallelComparisonView({
    super.key,
    required this.uid,
    required this.primaryLanguage,
  });

  final String uid;
  final String primaryLanguage;

  @override
  ConsumerState<ParallelComparisonView> createState() =>
      _ParallelComparisonViewState();
}

class _ParallelComparisonViewState
    extends ConsumerState<ParallelComparisonView> {
  final List<ScrollController> _controllers = [];
  bool _linkedScrolling = true;
  bool _isSyncing = false;
  late List<String> _selectedLangs;

  @override
  void initState() {
    super.initState();
    _selectedLangs = [widget.primaryLanguage];
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _ensureControllers(int count) {
    while (_controllers.length < count) {
      final controller = ScrollController();
      controller.addListener(() => _onScroll(controller));
      _controllers.add(controller);
    }
    while (_controllers.length > count) {
      _controllers.removeLast().dispose();
    }
  }

  void _onScroll(ScrollController source) {
    if (!_linkedScrolling || _isSyncing) return;
    final sourceMax = source.position.maxScrollExtent;
    if (sourceMax <= 0) return;
    final percent = source.offset / sourceMax;

    _isSyncing = true;
    for (final c in _controllers) {
      if (c == source || !c.hasClients) continue;
      final targetMax = c.position.maxScrollExtent;
      if (targetMax <= 0) continue;
      c.jumpTo((percent * targetMax).clamp(0.0, targetMax));
    }
    _isSyncing = false;
  }

  void _addPanel(List<SuttaText> available) {
    final usedLangs = Set<String>.from(_selectedLangs);
    final unused = available
        .where((t) => !usedLangs.contains(t.language))
        .toList();
    if (unused.isEmpty) return;
    if (_selectedLangs.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 panels')),
      );
      return;
    }
    _showPickerSheet(unused);
  }

  void _showPickerSheet(List<SuttaText> choices) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add translation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSizes.sm),
            ...choices.map((t) => ListTile(
                  title: Text(t.language.toUpperCase()),
                  subtitle: t.translator != null
                      ? Text('Trans. ${t.translator}')
                      : null,
                  onTap: () {
                    setState(() => _selectedLangs.add(t.language));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableAsync =
        ref.watch(_parallelTextsProvider(widget.uid));

    return availableAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (available) {
        final panels = _selectedLangs
            .map((lang) =>
                available.where((t) => t.language == lang).firstOrNull)
            .whereType<SuttaText>()
            .toList();

        _ensureControllers(panels.length);

        return Column(
          children: [
            // Toolbar
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.sm, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.4),
                border: Border(
                  bottom: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.compare_arrows, size: 16),
                  const SizedBox(width: 4),
                  const Text('Compare',
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  // Linked scroll toggle
                  Tooltip(
                    message: _linkedScrolling
                        ? 'Disable linked scrolling'
                        : 'Enable linked scrolling',
                    child: InkWell(
                      onTap: () => setState(
                          () => _linkedScrolling = !_linkedScrolling),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.link,
                              size: 16,
                              color: _linkedScrolling
                                  ? AppColors.green
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Linked',
                              style: TextStyle(
                                fontSize: 12,
                                color: _linkedScrolling
                                    ? AppColors.green
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Add panel
                  if (panels.length < 3 &&
                      available.length > panels.length)
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      tooltip: 'Add translation panel',
                      onPressed: () => _addPanel(available),
                      visualDensity: VisualDensity.compact,
                    ),
                  // Close
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    tooltip: 'Close comparison',
                    onPressed: () => context.pop(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            // Panels
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < panels.length; i++) ...[
                    if (i > 0)
                      Container(
                        width: 1,
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.3),
                      ),
                    Expanded(
                      child: _PanelColumn(
                        sutta: panels[i],
                        scrollController: _controllers[i],
                        onRemove: panels.length > 1
                            ? () => setState(() =>
                                _selectedLangs.remove(panels[i].language))
                            : null,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PanelColumn extends StatelessWidget {
  const _PanelColumn({
    required this.sutta,
    required this.scrollController,
    this.onRemove,
  });

  final SuttaText sutta;
  final ScrollController scrollController;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final text = sutta.contentHtml != null
        ? htmlToReadableText(sutta.contentHtml!)
        : (sutta.contentPlain ?? '');

    return Column(
      children: [
        // Panel header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              vertical: 6, horizontal: AppSizes.sm),
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.3),
          child: Row(
            children: [
              Text(
                sutta.language.toUpperCase(),
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700),
              ),
              if (sutta.translator != null) ...[
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    sutta.translator!,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else
                const Spacer(),
              if (onRemove != null)
                InkWell(
                  onTap: onRemove,
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.close, size: 14, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
        // Scrollable text
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm, vertical: AppSizes.sm),
            child: HighlightedText(
              text: text,
              highlights: const [],
              fontSize: 15,
              lineSpacing: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}
