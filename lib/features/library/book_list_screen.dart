import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/database/app_database.dart';
import '../../shared/providers/database_provider.dart';
import '../../shared/providers/preferences_provider.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/nikaya_badge.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

typedef _SuttasParams = ({String nikaya, String? book, String? chapter});

final suttasForChapterProvider = StreamProvider.autoDispose
    .family<List<SuttaText>, _SuttasParams>((ref, params) {
  final db = ref.watch(appDatabaseProvider);
  final lang = ref.watch(readerLanguageProvider);
  return db.textsDao.watchSuttasForChapter(
    nikaya: params.nikaya,
    book: params.book,
    chapter: params.chapter,
    language: lang,
  );
});

// ── Screen ────────────────────────────────────────────────────────────────────

/// Handles both book-level and chapter-level browsing with the same widget.
/// When [book] is null, shows all suttas in the nikaya.
/// When [book] is provided, shows suttas in that book.
class BookListScreen extends ConsumerWidget {
  const BookListScreen({
    super.key,
    required this.nikaya,
    this.book,
  });

  final String nikaya;
  final String? book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suttasAsync = ref.watch(
      suttasForChapterProvider((nikaya: nikaya, book: book, chapter: null)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book ?? _nikayaLabel(nikaya)),
            if (book != null)
              Text(
                _nikayaLabel(nikaya),
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
          ],
        ),
      ),
      body: suttasAsync.when(
        data: (suttas) => suttas.isEmpty
            ? const _EmptyState()
            : _SuttaList(suttas: suttas, nikaya: nikaya),
        loading: () => const SuttaListShimmer(),
        error: (e, _) => ErrorState(
          message: 'Could not load suttas.\nMake sure this pack is downloaded.',
          onRetry: () => ref.invalidate(suttasForChapterProvider),
        ),
      ),
    );
  }

  String _nikayaLabel(String nikaya) => switch (nikaya.toLowerCase()) {
        'dn' => 'Dīgha Nikāya',
        'mn' => 'Majjhima Nikāya',
        'sn' => 'Saṃyutta Nikāya',
        'an' => 'Aṅguttara Nikāya',
        'kn' => 'Khuddaka Nikāya',
        _ => nikaya.toUpperCase(),
      };
}

class _SuttaList extends StatelessWidget {
  const _SuttaList({required this.suttas, required this.nikaya});

  final List<SuttaText> suttas;
  final String nikaya;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      itemCount: suttas.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final sutta = suttas[index];
        return _SuttaTile(sutta: sutta, nikaya: nikaya);
      },
    );
  }
}

class _SuttaTile extends StatelessWidget {
  const _SuttaTile({required this.sutta, required this.nikaya});

  final SuttaText sutta;
  final String nikaya;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      leading: NikayaBadge(nikaya: nikaya),
      title: Text(
        sutta.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: sutta.chapter != null
          ? Text(
              sutta.chapter!,
              style: const TextStyle(fontSize: 12),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push(
        '${Routes.readerPath(sutta.uid)}?lang=${sutta.language}',
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No texts found.\nDownload a content pack to start reading.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
