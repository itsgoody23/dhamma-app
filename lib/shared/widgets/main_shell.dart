import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/extensions/l10n_extension.dart';
import '../../features/audio/audio_player_sheet.dart';
import '../../shared/providers/audio_provider.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAudio = ref.watch(currentAudioTrackProvider).value != null;

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: shell),
          if (hasAudio) const MiniPlayer(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (index) => shell.goBranch(
          index,
          initialLocation: index == shell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: context.l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: context.l10n.navSearch,
          ),
          NavigationDestination(
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.wb_sunny),
            label: context.l10n.navDaily,
          ),
          NavigationDestination(
            icon: const Icon(Icons.headphones_outlined),
            selectedIcon: const Icon(Icons.headphones),
            label: context.l10n.navAudio,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark_outline),
            selectedIcon: const Icon(Icons.bookmark),
            label: context.l10n.navStudy,
          ),
          NavigationDestination(
            icon: const Icon(Icons.download_outlined),
            selectedIcon: const Icon(Icons.download),
            label: context.l10n.navDownloads,
          ),
        ],
      ),
    );
  }
}
