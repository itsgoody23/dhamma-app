import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/providers/preferences_provider.dart';
import '../../../shared/providers/reader_view_prefs_provider.dart';

/// A bottom sheet panel exposing all reading-comfort settings:
/// font family, size, line spacing, margins, text color, and smart
/// text selection mode.
///
/// Audio settings are intentionally excluded from this panel.
class ViewSettingsSheet extends ConsumerWidget {
  const ViewSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(readerFontSizeProvider);
    final lineSpacing = ref.watch(readerLineSpacingProvider);
    final fontFamily = ref.watch(readerFontFamilyProvider);
    final textColor = ref.watch(readerTextColorProvider);
    final margin = ref.watch(readerMarginProvider);
    final smartMode = ref.watch(readerSmartSelectionModeProvider);
    final bgColor = ref.watch(readerBgColorProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.text_fields, color: AppColors.green),
                    const SizedBox(width: 8),
                    Text(
                      'View Settings',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
                  children: [
                    // ── Text ─────────────────────────────────────────────
                    const _SectionLabel('TEXT'),
                    const SizedBox(height: 8),

                    // Font family
                    _RowLabel(context, 'Font'),
                    const SizedBox(height: 6),
                    SegmentedButton<String>(
                      selected: {fontFamily},
                      onSelectionChanged: (v) => ref
                          .read(readerFontFamilyProvider.notifier)
                          .set(v.first),
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor:
                            AppColors.green.withValues(alpha: 0.15),
                        selectedForegroundColor: AppColors.green,
                      ),
                      segments: ReaderFontFamily.options
                          .map((o) => ButtonSegment<String>(
                                value: o.$1,
                                label: Text(o.$2),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Font size
                    Row(
                      children: [
                        _RowLabel(context, 'Size'),
                        const Spacer(),
                        Text(
                          '${fontSize.round()}pt',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: fontSize.clamp(12.0, 28.0),
                      min: 12.0,
                      max: 28.0,
                      divisions: 16,
                      activeColor: AppColors.green,
                      onChanged: (v) => ref
                          .read(readerFontSizeProvider.notifier)
                          .setFontSize(v),
                    ),

                    // ── Spacing ───────────────────────────────────────────
                    const SizedBox(height: 8),
                    const _SectionLabel('SPACING'),
                    const SizedBox(height: 8),

                    // Line spacing
                    Row(
                      children: [
                        _RowLabel(context, 'Line spacing'),
                        const Spacer(),
                        Text(
                          '${lineSpacing.toStringAsFixed(1)}×',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: lineSpacing.clamp(1.2, 2.4),
                      min: 1.2,
                      max: 2.4,
                      divisions: 12,
                      activeColor: AppColors.green,
                      onChanged: (v) => ref
                          .read(readerLineSpacingProvider.notifier)
                          .setLineSpacing(v),
                    ),
                    const SizedBox(height: 8),

                    // Margins
                    _RowLabel(context, 'Margins'),
                    const SizedBox(height: 6),
                    SegmentedButton<String>(
                      selected: {margin},
                      onSelectionChanged: (v) =>
                          ref.read(readerMarginProvider.notifier).set(v.first),
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor:
                            AppColors.green.withValues(alpha: 0.15),
                        selectedForegroundColor: AppColors.green,
                      ),
                      segments: const [
                        ButtonSegment(
                            value: ReaderMargin.narrow, label: Text('Narrow')),
                        ButtonSegment(
                            value: ReaderMargin.normal, label: Text('Normal')),
                        ButtonSegment(
                            value: ReaderMargin.wide, label: Text('Wide')),
                      ],
                    ),

                    // ── Color ─────────────────────────────────────────────
                    const SizedBox(height: 16),
                    const _SectionLabel('TEXT COLOR'),
                    const SizedBox(height: 10),
                    _ColorSwatches(
                      selected: textColor,
                      isDark: isDark,
                      onSelected: (hex) =>
                          ref.read(readerTextColorProvider.notifier).set(hex),
                    ),

                    // Background color
                    const SizedBox(height: 16),
                    const _SectionLabel('BACKGROUND'),
                    const SizedBox(height: 10),
                    _BgColorSwatches(
                      selected: bgColor,
                      isDark: isDark,
                      onSelected: (hex) =>
                          ref.read(readerBgColorProvider.notifier).set(hex),
                    ),

                    // ── Smart Selection ───────────────────────────────────
                    const SizedBox(height: 16),
                    const _SectionLabel('SMART SELECTION'),
                    const SizedBox(height: 4),
                    Text(
                      'Selection snaps to nearest boundary when highlighting',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                          ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      selected: {smartMode},
                      onSelectionChanged: (v) => ref
                          .read(readerSmartSelectionModeProvider.notifier)
                          .set(v.first),
                      style: SegmentedButton.styleFrom(
                        selectedBackgroundColor:
                            AppColors.green.withValues(alpha: 0.15),
                        selectedForegroundColor: AppColors.green,
                      ),
                      segments: const [
                        ButtonSegment(
                            value: SmartSelectionMode.word,
                            label: Text('Word')),
                        ButtonSegment(
                            value: SmartSelectionMode.phrase,
                            label: Text('Phrase')),
                        ButtonSegment(
                            value: SmartSelectionMode.sentence,
                            label: Text('Sentence')),
                        ButtonSegment(
                            value: SmartSelectionMode.paragraph,
                            label: Text('Para')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.green,
      ),
    );
  }
}

Widget _RowLabel(BuildContext context, String text) {
  return Text(
    text,
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
        ),
  );
}

// ── Background color swatches ─────────────────────────────────────────────────

class _BgColorSwatches extends StatelessWidget {
  const _BgColorSwatches({
    required this.selected,
    required this.isDark,
    required this.onSelected,
  });

  final String selected;
  final bool isDark;
  final void Function(String hex) onSelected;

  static const _lightBgs = <(String, String)>[
    ('', 'Default'),
    ('#FAF3E0', 'Warm Paper'),
    ('#F4ECD8', 'Sepia'),
    ('#F0F4F8', 'Cool White'),
    ('#1C1C1E', 'Night'),
  ];

  static const _darkBgs = <(String, String)>[
    ('', 'Default'),
    ('#1C1C1E', 'True Black'),
    ('#2C2C2E', 'Dark Gray'),
    ('#1A1A2E', 'Midnight Blue'),
    ('#FAF3E0', 'Warm Paper'),
  ];

  @override
  Widget build(BuildContext context) {
    final bgList = isDark ? _darkBgs : _lightBgs;
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: bgList.map((entry) {
        final isSelected = selected == entry.$1;
        final previewColor = entry.$1.isEmpty
            ? Theme.of(context).colorScheme.surface
            : Color(int.parse(
                'FF${entry.$1.replaceFirst('#', '')}',
                radix: 16,
              ));

        return Tooltip(
          message: entry.$2,
          child: GestureDetector(
            onTap: () => onSelected(entry.$1),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: previewColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.green
                      : Colors.grey.withValues(alpha: 0.35),
                  width: isSelected ? 3 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: previewColor.computeLuminance() > 0.5
                          ? Colors.black87
                          : Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Color swatches ────────────────────────────────────────────────────────────

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches({
    required this.selected,
    required this.isDark,
    required this.onSelected,
  });

  final String selected;
  final bool isDark;
  final void Function(String hex) onSelected;

  static const _lightColors = <(String, String)>[
    ('', 'Auto'),
    ('#1C1A17', 'Warm Brown'),
    ('#5C4A2A', 'Sepia'),
    ('#3A3A3A', 'Soft Gray'),
    ('#000000', 'Black'),
  ];

  static const _darkColors = <(String, String)>[
    ('', 'Auto'),
    ('#EDE6D6', 'Warm Cream'),
    ('#D4C4A8', 'Sepia'),
    ('#B0A898', 'Soft Gray'),
    ('#FFFFFF', 'White'),
  ];

  @override
  Widget build(BuildContext context) {
    final colorList = isDark ? _darkColors : _lightColors;
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: colorList.map((entry) {
        final isSelected = selected == entry.$1;
        final bgColor = entry.$1.isEmpty
            ? (isDark ? const Color(0xFFEDE6D6) : const Color(0xFF1C1A17))
            : Color(int.parse(
                'FF${entry.$1.replaceFirst('#', '')}',
                radix: 16,
              ));

        return Tooltip(
          message: entry.$2,
          child: GestureDetector(
            onTap: () => onSelected(entry.$1),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.green : Colors.transparent,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
