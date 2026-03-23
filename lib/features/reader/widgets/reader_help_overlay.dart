import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// Full-screen overlay explaining reader gestures, tools, and keyboard
/// shortcuts. Shown automatically on first reader open and accessible any
/// time via the help icon in the AppBar.
class ReaderHelpOverlay extends StatelessWidget {
  const ReaderHelpOverlay({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.85),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSizes.md, AppSizes.lg, AppSizes.md, 0),
              child: Row(
                children: [
                  const Icon(Icons.help_outline,
                      color: AppColors.green, size: 24),
                  const SizedBox(width: AppSizes.sm),
                  const Expanded(
                    child: Text(
                      'Reader Guide',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: onDismiss,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSizes.md),
                children: const [
                  _Section(title: 'Touch Gestures'),
                  _HelpRow(
                    icon: Icons.touch_app_outlined,
                    label: 'Tap & hold',
                    description: 'Select text to highlight or look up',
                  ),
                  _HelpRow(
                    icon: Icons.auto_stories_outlined,
                    label: 'Swipe left / right',
                    description: 'Navigate to previous or next sutta',
                  ),
                  _HelpRow(
                    icon: Icons.zoom_in_outlined,
                    label: 'Pinch',
                    description: 'Zoom in or out (use Aa buttons in toolbar)',
                  ),
                  SizedBox(height: AppSizes.md),
                  _Section(title: 'Annotation Tools'),
                  _HelpRow(
                    icon: Icons.highlight_outlined,
                    label: 'Highlight colours',
                    description:
                        'Select text then tap a colour circle to highlight',
                  ),
                  _HelpRow(
                    icon: Icons.sticky_note_2_outlined,
                    label: 'Highlight note',
                    description:
                        'Tap the note icon on an existing highlight to add a note',
                  ),
                  _HelpRow(
                    icon: Icons.bookmark_border,
                    label: 'Bookmark',
                    description:
                        'Tap the bookmark icon in the AppBar to save this sutta',
                  ),
                  _HelpRow(
                    icon: Icons.edit_note_outlined,
                    label: 'Sutta note',
                    description:
                        'Tap the note icon in the AppBar to write a study note',
                  ),
                  SizedBox(height: AppSizes.md),
                  _Section(title: 'Reading Tools'),
                  _HelpRow(
                    icon: Icons.search_outlined,
                    label: 'In-sutta search',
                    description: 'Search within this sutta for any word or phrase',
                  ),
                  _HelpRow(
                    icon: Icons.view_column_outlined,
                    label: 'View mode',
                    description:
                        'Cycle between single · side-by-side · interlinear views',
                  ),
                  _HelpRow(
                    icon: Icons.compare_arrows_outlined,
                    label: 'Compare translations',
                    description:
                        'Open multiple translations of the same sutta side by side',
                  ),
                  _HelpRow(
                    icon: Icons.auto_stories,
                    label: 'Page / scroll mode',
                    description: 'Toggle between paginated and continuous scroll',
                  ),
                  _HelpRow(
                    icon: Icons.menu_book_outlined,
                    label: 'Dictionary',
                    description:
                        'Select a Pali word and tap the dictionary icon to look it up',
                  ),
                  SizedBox(height: AppSizes.md),
                  _Section(title: 'External Keyboard'),
                  _HelpRow(
                    icon: Icons.keyboard_outlined,
                    label: 'Ctrl + F',
                    description: 'Open / close in-sutta search',
                  ),
                  _HelpRow(
                    icon: Icons.keyboard_outlined,
                    label: 'Ctrl + D',
                    description: 'Cycle display view modes',
                  ),
                  _HelpRow(
                    icon: Icons.keyboard_outlined,
                    label: '← → or Page Up / Down',
                    description: 'Turn pages in paginated mode',
                  ),
                  _HelpRow(
                    icon: Icons.keyboard_outlined,
                    label: 'Escape',
                    description: 'Close search bar or dismiss overlays',
                  ),
                ],
              ),
            ),
            // Dismiss button
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onDismiss,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.green,
                  ),
                  child: const Text('Got it'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.xs),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.green,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _HelpRow extends StatelessWidget {
  const _HelpRow({
    required this.icon,
    required this.label,
    required this.description,
  });

  final IconData icon;
  final String label;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
