import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Full tutorial / reference screen for the Dhamma Study App.
///
/// Accessible from:
///   • The shell AppBar help icon (all screens)
///   • Settings → Help & Tutorial
///
/// The first-run overlay in the reader (reader_help_overlay.dart) remains
/// for quick visual orientation; this screen is the deep-dive reference.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Tutorial'),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _HelpSection(
            icon: Icons.rocket_launch_outlined,
            title: 'Getting Started',
            items: [
              _HelpItem(
                heading: 'Download a language pack',
                body:
                    'Go to Library → tap the download icon (top-right) → choose a pack (e.g. English). '
                    'Texts are stored offline; no internet needed to read.',
              ),
              _HelpItem(
                heading: 'Open a sutta',
                body:
                    'Tap Library → choose a Nikāya (e.g. Majjhima Nikāya) → browse suttas → tap any title to open the reader.',
              ),
              _HelpItem(
                heading: 'Daily sutta',
                body:
                    'Tap the sun icon in the bottom nav. A different sutta is shown each day. '
                    'Tap it to open the reader; reading it counts toward your streak.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _HelpSection(
            icon: Icons.menu_book_outlined,
            title: 'The Reader',
            items: [
              _HelpItem(
                heading: 'View modes',
                body:
                    'Tap the column icon in the toolbar to cycle through:\n'
                    '• Single — one language, full width\n'
                    '• Side-by-side — Pāli + translation in two columns\n'
                    '• Interlinear — Pāli above, English below per paragraph',
              ),
              _HelpItem(
                heading: 'Paginated vs scroll',
                body:
                    'Tap the book/scroll icon in the toolbar to switch between '
                    'Kindle-style page turns and continuous scroll.',
              ),
              _HelpItem(
                heading: 'Compare translations',
                body:
                    'Tap the ⇄ icon in the AppBar to open the parallel comparison panel. '
                    'Add up to 3 translations side-by-side with optional linked scrolling.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _HelpSection(
            icon: Icons.highlight_outlined,
            title: 'Highlights & Notes',
            items: [
              _HelpItem(
                heading: 'Highlight text',
                body:
                    'Long-press or drag to select text. A colour toolbar appears — '
                    'tap a colour swatch to save the highlight.',
              ),
              _HelpItem(
                heading: 'Smart selection',
                body:
                    'Enable Smart Selection in View Settings to have highlights '
                    'snap to the nearest word, phrase, sentence, or paragraph boundary automatically.',
              ),
              _HelpItem(
                heading: 'Add a note to a highlight',
                body:
                    'Select text that overlaps an existing highlight, then tap the '
                    '✏ note icon in the toolbar. Your note appears as a sticky-note icon in the text.',
              ),
              _HelpItem(
                heading: 'View your highlights',
                body:
                    'Go to Study → Highlights tab to see all highlights across every sutta.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _HelpSection(
            icon: Icons.tab_outlined,
            title: 'Tabs',
            items: [
              _HelpItem(
                heading: 'Open multiple suttas',
                body:
                    'Every sutta you open appears as a tab at the top of the reader. '
                    'Tabs show the abbreviated title (e.g. "DN 1", "MN 36").',
              ),
              _HelpItem(
                heading: 'Switch tabs',
                body:
                    'Tap any tab to switch to it. On PC use Ctrl+Tab / Ctrl+Shift+Tab.',
              ),
              _HelpItem(
                heading: 'Open a new tab',
                body:
                    'Tap the + button at the right of the tab bar, or use Ctrl+T. '
                    'This opens the Library so you can pick a sutta.',
              ),
              _HelpItem(
                heading: 'Close a tab',
                body:
                    'Tap the × on a tab chip, or press Ctrl+W. '
                    'Tabs are restored between sessions.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _HelpSection(
            icon: Icons.bookmark_border_outlined,
            title: 'Study Tools',
            items: [
              _HelpItem(
                heading: 'Bookmarks',
                body:
                    'Tap the bookmark icon in the reader AppBar to bookmark the current sutta. '
                    'Find all bookmarks in Study → Bookmarks.',
              ),
              _HelpItem(
                heading: 'History',
                body:
                    'Study → History shows every sutta you have read, grouped by date. '
                    'Tap any row to restore your last scroll position.',
              ),
              _HelpItem(
                heading: 'Collections',
                body:
                    'Tap ⋮ → Add to Collection in the reader to organise suttas into custom reading lists. '
                    'Collections also appear on the Library screen.',
              ),
              _HelpItem(
                heading: 'Notes',
                body:
                    'Tap the note icon in the reader AppBar to write a free-form note for the whole sutta. '
                    'Per-highlight notes are added via the highlight toolbar.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _HelpSection(
            icon: Icons.search_outlined,
            title: 'Search',
            items: [
              _HelpItem(
                heading: 'Global search',
                body:
                    'Tap the magnifier icon in the bottom nav to search across all downloaded suttas. '
                    'Filter by Nikāya, language, or translator.',
              ),
              _HelpItem(
                heading: 'In-sutta search',
                body:
                    'Tap the 🔍 icon in the reader AppBar (or press Ctrl+F) to search within '
                    'the open sutta. Use ↑ ↓ arrows to jump between matches.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _HelpSection(
            icon: Icons.text_fields_outlined,
            title: 'View Settings',
            items: [
              _HelpItem(
                heading: 'Access View Settings',
                body:
                    'Tap the Aa icon in the reader AppBar, or go to Settings → View Settings.',
              ),
              _HelpItem(
                heading: 'Font',
                body:
                    'Choose between Serif (NotoSerif), Palatino, or Sans-serif. '
                    'Serif fonts are recommended for long reading sessions.',
              ),
              _HelpItem(
                heading: 'Size & spacing',
                body:
                    'Drag the Size slider (12–28pt) and Line Spacing slider (1.2–2.4×) '
                    'for comfortable reading.',
              ),
              _HelpItem(
                heading: 'Margins',
                body:
                    'Choose Narrow (12px), Normal (20px), or Wide (48px) horizontal padding. '
                    'Wide margins suit large monitors.',
              ),
              _HelpItem(
                heading: 'Text color',
                body:
                    'Pick Auto (follows theme), Warm Brown, Sepia, Soft Gray, or High Contrast. '
                    'Sepia is easiest on the eyes in low-light environments.',
              ),
            ],
          ),
          SizedBox(height: 8),
          _HelpSection(
            icon: Icons.keyboard_outlined,
            title: 'Keyboard Shortcuts (PC / Tablet)',
            items: [
              _ShortcutTable(),
            ],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Section ───────────────────────────────────────────────────────────────────

class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.green, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        initiallyExpanded: false,
        childrenPadding:
            const EdgeInsets.only(left: 16, right: 8, bottom: 8),
        children: items,
      ),
    );
  }
}

// ── Help item ─────────────────────────────────────────────────────────────────

class _HelpItem extends StatelessWidget {
  const _HelpItem({required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.green,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            body,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}

// ── Keyboard shortcuts table ──────────────────────────────────────────────────

class _ShortcutTable extends StatelessWidget {
  const _ShortcutTable();

  static const _shortcuts = <(String, String)>[
    ('Ctrl+F', 'In-sutta search'),
    ('Ctrl+D', 'Cycle view mode (single / split / interlinear)'),
    ('Ctrl+T', 'New tab (opens Library)'),
    ('Ctrl+W', 'Close current tab'),
    ('Ctrl+Tab', 'Switch to next tab'),
    ('Ctrl+Shift+Tab', 'Switch to previous tab'),
    ('Page Down / →', 'Next page'),
    ('Page Up / ←', 'Previous page'),
    ('Escape', 'Dismiss overlay or search'),
  ];

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _shortcuts.map((row) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                      color: AppColors.green.withValues(alpha: 0.25)),
                ),
                child: Text(
                  row.$1,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.green,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                row.$2,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(height: 1.5),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
