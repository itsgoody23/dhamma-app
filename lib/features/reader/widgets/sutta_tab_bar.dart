import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/routing/routes.dart';
import '../../../shared/providers/tabs_provider.dart';

/// Chrome-style horizontal tab bar showing all open suttas.
///
/// Each tab displays the abbreviated sutta title (e.g. "DN 1", "MN 36").
/// The active tab is highlighted with the brand green accent.
///
/// On phone (< 600dp), the bar is hidden when only one tab is open.
/// On tablet/PC (≥ 600dp), the bar is always shown.
class SuttaTabBar extends ConsumerWidget {
  const SuttaTabBar({super.key, required this.currentUid});

  final String currentUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsState = ref.watch(tabsProvider);
    final tabs = tabsState.tabs;

    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    // On phone, hide tab chips when < 2 tabs, but always show the + button.
    final hideTabChips = !isTablet && tabs.length < 2;

    return Container(
      height: 40,
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.55),
      child: Row(
        children: [
          if (!hideTabChips)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final tab = tabs[index];
                  final isActive = tab.uid == currentUid;
                  return _TabChip(
                    tab: tab,
                    isActive: isActive,
                    onTap: () {
                      if (!isActive) {
                        ref.read(tabsProvider.notifier).setActive(tab.uid);
                        context.pushReplacement(Routes.readerPath(tab.uid));
                      }
                    },
                    onClose: () => _closeTab(context, ref, tab.uid),
                  );
                },
              ),
            )
          else
            const Spacer(),
          // ＋ button — opens Library to pick a new sutta (always visible)
          SizedBox(
            width: 36,
            height: 36,
            child: IconButton(
              icon: const Icon(Icons.add, size: 18),
              tooltip: 'New tab (Ctrl+T)',
              padding: EdgeInsets.zero,
              onPressed: () => context.go(Routes.library),
            ),
          ),
          const SizedBox(width: 2),
        ],
      ),
    );
  }

  void _closeTab(BuildContext context, WidgetRef ref, String uid) {
    ref.read(tabsProvider.notifier).closeTab(uid);
    final state = ref.read(tabsProvider);
    if (uid == currentUid) {
      if (state.activeUid != null) {
        context.pushReplacement(Routes.readerPath(state.activeUid!));
      } else {
        context.pop();
      }
    }
  }
}

// ── Tab chip ──────────────────────────────────────────────────────────────────

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  final SuttaTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.green.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive
                ? AppColors.green
                : theme.colorScheme.outline.withValues(alpha: 0.35),
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tab.abbrev,
              style: TextStyle(
                fontSize: 12,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.green : null,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close,
                size: 14,
                color: isActive
                    ? AppColors.green.withValues(alpha: 0.7)
                    : theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
