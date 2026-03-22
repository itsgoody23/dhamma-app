import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/notification_provider.dart';
import '../../shared/providers/preferences_provider.dart';
import '../reader/widgets/view_settings_sheet.dart';

// Note: add url_launcher: ^6.3.0 to pubspec.yaml

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(readerFontSizeProvider);
    final language = ref.watch(readerLanguageProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        children: [
          // ── Reading ───────────────────────────────────────────────────────
          _SectionHeader(title: context.l10n.settingsReading),
          ListTile(
            title: Text(context.l10n.settingsTheme),
            subtitle: Text(_themeName(context, themeMode)),
            leading: const Icon(Icons.brightness_6_outlined),
            onTap: () => _pickTheme(context, ref),
          ),
          ListTile(
            title: Text(context.l10n.settingsFontSize),
            subtitle: Text(_fontSizeName(context, fontSize)),
            leading: const Icon(Icons.format_size_outlined),
            onTap: () => _pickFontSize(context, ref),
          ),
          Consumer(builder: (context, ref, _) {
            final lineSpacing = ref.watch(readerLineSpacingProvider);
            return ListTile(
              title: Text(context.l10n.settingsLineSpacing),
              subtitle: Text(_lineSpacingName(context, lineSpacing)),
              leading: const Icon(Icons.format_line_spacing_outlined),
              onTap: () => _pickLineSpacing(context, ref),
            );
          }),
          ListTile(
            title: const Text('View Settings'),
            subtitle: const Text('Font, size, spacing, margins, text color'),
            leading: const Icon(Icons.text_fields_outlined),
            onTap: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => const ViewSettingsSheet(),
            ),
          ),
          ListTile(
            title: Text(context.l10n.settingsDefaultLanguage),
            subtitle: Text(language.toUpperCase()),
            leading: const Icon(Icons.language_outlined),
            onTap: () => _pickLanguage(context, ref),
          ),
          Consumer(builder: (context, ref, _) {
            final appLocale = ref.watch(appLocaleProvider);
            return ListTile(
              title: Text(context.l10n.settingsAppLanguage),
              subtitle: Text(context.l10n.settingsAppLanguageSubtitle),
              trailing: Text(
                _appLocaleName(appLocale),
                style: const TextStyle(color: AppColors.green),
              ),
              leading: const Icon(Icons.translate_outlined),
              onTap: () => _pickAppLocale(context, ref),
            );
          }),

          const Divider(),

          // ── Downloads ─────────────────────────────────────────────────────
          _SectionHeader(title: context.l10n.settingsDownloads),
          Consumer(builder: (context, ref, _) {
            final wifiOnly = ref.watch(wifiOnlyProvider);
            return SwitchListTile(
              title: Text(context.l10n.settingsWifiOnly),
              subtitle: Text(context.l10n.settingsWifiOnlySubtitle),
              secondary: const Icon(Icons.wifi_outlined),
              value: wifiOnly,
              activeTrackColor: AppColors.green,
              onChanged: (v) => ref.read(wifiOnlyProvider.notifier).set(v),
            );
          }),


          const Divider(),

          // ── Notifications ─────────────────────────────────────────────────
          const _SectionHeader(title: 'Notifications'),
          Consumer(builder: (context, ref, _) {
            final enabled = ref.watch(dailyReminderEnabledProvider);
            return SwitchListTile(
              title: const Text('Daily sutta reminder'),
              subtitle: const Text('Get reminded to read every day'),
              secondary: const Icon(Icons.notifications_outlined),
              value: enabled,
              activeTrackColor: AppColors.green,
              onChanged: (v) =>
                  ref.read(dailyReminderEnabledProvider.notifier).set(v),
            );
          }),
          Consumer(builder: (context, ref, _) {
            final enabled = ref.watch(dailyReminderEnabledProvider);
            final time = ref.watch(dailyReminderTimeProvider);
            return ListTile(
              title: const Text('Reminder time'),
              subtitle: Text(time.format(context)),
              leading: const Icon(Icons.access_time_outlined),
              enabled: enabled,
              onTap: enabled
                  ? () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: time,
                      );
                      if (picked != null) {
                        ref
                            .read(dailyReminderTimeProvider.notifier)
                            .setTime(picked);
                      }
                    }
                  : null,
            );
          }),

          const Divider(),

          // ── Account ─────────────────────────────────────────────────────
          _SectionHeader(title: context.l10n.settingsAccount),
          Consumer(builder: (context, ref, _) {
            final user = ref.watch(currentUserProvider);
            if (user != null) {
              return Column(children: [
                ListTile(
                  title: Text(user.email ?? 'Signed in'),
                  subtitle: Text(context.l10n.settingsManageAccount),
                  leading: const Icon(Icons.person_outlined),
                  onTap: () => context.push(Routes.profile),
                ),
                Consumer(builder: (context, ref, _) {
                  final wifiOnlySync = ref.watch(wifiOnlySyncProvider);
                  return SwitchListTile(
                    title: Text(context.l10n.settingsSyncWifiOnly),
                    subtitle: Text(context.l10n.settingsSyncWifiOnlySubtitle),
                    secondary: const Icon(Icons.sync_outlined),
                    value: wifiOnlySync,
                    activeTrackColor: AppColors.green,
                    onChanged: (v) =>
                        ref.read(wifiOnlySyncProvider.notifier).set(v),
                  );
                }),
              ]);
            }
            return ListTile(
              title: Text(context.l10n.settingsSignIn),
              subtitle: Text(context.l10n.settingsSignInSubtitle),
              leading: const Icon(Icons.login_outlined),
              onTap: () => context.push(Routes.login),
            );
          }),

          const Divider(),

          // ── About ─────────────────────────────────────────────────────────
          const _SectionHeader(title: 'Help'),
          ListTile(
            title: const Text('Help & Tutorial'),
            subtitle:
                const Text('Keyboard shortcuts, reader guide, features'),
            leading: const Icon(Icons.help_outline),
            onTap: () => context.push(Routes.help),
          ),

          const Divider(),

          _SectionHeader(title: context.l10n.settingsAbout),
          ListTile(
            title: Text(context.l10n.settingsLicences),
            leading: const Icon(Icons.gavel_outlined),
            onTap: () => showLicensePage(
                context: context, applicationName: 'Dhamma App'),
          ),
          ListTile(
            title: const Text('SuttaCentral'),
            subtitle: const Text('Primary data source — suttacentral.net'),
            leading: const Icon(Icons.link_outlined),
            onTap: () => launchUrl(Uri.parse('https://suttacentral.net')),
          ),
          ListTile(
            title: const Text('Access to Insight'),
            subtitle: const Text('accesstoinsight.org (CC-BY 4.0)'),
            leading: const Icon(Icons.link_outlined),
            onTap: () => launchUrl(Uri.parse('https://accesstoinsight.org')),
          ),
          ListTile(
            title: Text(context.l10n.settingsSourceCode),
            subtitle: const Text('MIT / Apache 2.0 — github.com/dhamma-app'),
            leading: const Icon(Icons.code_outlined),
            onTap: () => launchUrl(Uri.parse('https://github.com/dhamma-app')),
          ),
          ListTile(
            title: Text(context.l10n.settingsVersion),
            subtitle: const Text('1.0.0'),
            leading: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }

  String _themeName(BuildContext context, ThemeMode mode) => switch (mode) {
        ThemeMode.light => context.l10n.settingsThemeLight,
        ThemeMode.dark => context.l10n.settingsThemeDark,
        ThemeMode.system => context.l10n.settingsThemeSystem,
      };

  String _fontSizeName(BuildContext context, double size) => switch (size) {
        AppTypography.fontSizeSmall => context.l10n.settingsFontSmall,
        AppTypography.fontSizeMedium => context.l10n.settingsFontMedium,
        AppTypography.fontSizeLarge => context.l10n.settingsFontLarge,
        AppTypography.fontSizeXL => context.l10n.settingsFontXL,
        _ => '${size.round()}pt',
      };

  String _lineSpacingName(BuildContext context, double spacing) =>
      switch (spacing) {
        1.4 => context.l10n.settingsLineCompact,
        1.7 => context.l10n.settingsLineNormal,
        2.0 => context.l10n.settingsLineRelaxed,
        _ => '${spacing}x',
      };

  void _pickLineSpacing(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(context.l10n.settingsLineSpacing),
        children: [
          Column(
            children: ReaderLineSpacingNotifier.options
                .asMap()
                .entries
                .map((e) => RadioListTile<double>(
                      title: Text(ReaderLineSpacingNotifier.labels[e.key]),
                      subtitle: Text('${e.value}x'),
                      value: e.value,
                      groupValue: ref.read(readerLineSpacingProvider),
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(readerLineSpacingProvider.notifier)
                              .setLineSpacing(v);
                        }
                        Navigator.pop(ctx);
                      },
                      activeColor: AppColors.green,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _pickTheme(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(context.l10n.settingsTheme),
        children: [
          Column(
            children: ThemeMode.values
                .map((mode) => RadioListTile<ThemeMode>(
                      title: Text(_themeName(context, mode)),
                      value: mode,
                      groupValue: ref.read(themeModeProvider),
                      onChanged: (v) {
                        if (v != null) {
                          ref.read(themeModeProvider.notifier).setThemeMode(v);
                        }
                        Navigator.pop(ctx);
                      },
                      activeColor: AppColors.green,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _pickFontSize(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(context.l10n.settingsFontSize),
        children: [
          Column(
            children: AppTypography.readerFontSizes
                .asMap()
                .entries
                .map((e) => RadioListTile<double>(
                      title: Text(AppTypography.readerFontSizeLabels[e.key]),
                      value: e.value,
                      groupValue: ref.read(readerFontSizeProvider),
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(readerFontSizeProvider.notifier)
                              .setFontSize(v);
                        }
                        Navigator.pop(ctx);
                      },
                      activeColor: AppColors.green,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  String _appLocaleName(Locale? locale) => switch (locale?.languageCode) {
        'en' => 'English',
        'de' => 'Deutsch',
        'fr' => 'Français',
        'es' => 'Español',
        'si' => 'සිංහල',
        _ => 'System',
      };

  void _pickAppLocale(BuildContext context, WidgetRef ref) {
    const locales = [
      (null, 'System'),
      (Locale('en'), 'English'),
      (Locale('de'), 'Deutsch'),
      (Locale('fr'), 'Français'),
      (Locale('es'), 'Español'),
      (Locale('si'), 'සිංහල'),
    ];
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(context.l10n.settingsAppLanguage),
        children: [
          Column(
            children: locales
                .map((entry) => RadioListTile<Locale?>(
                      title: Text(entry.$2),
                      value: entry.$1,
                      groupValue: ref.read(appLocaleProvider),
                      onChanged: (v) {
                        ref.read(appLocaleProvider.notifier).setLocale(v);
                        Navigator.pop(ctx);
                      },
                      activeColor: AppColors.green,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _pickLanguage(BuildContext context, WidgetRef ref) {
    const languages = [
      ('en', 'English'),
      ('pli', 'Pāli'),
      ('de', 'Deutsch'),
      ('fr', 'Français')
    ];
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(context.l10n.settingsDefaultLanguage),
        children: [
          Column(
            children: languages
                .map((lang) => RadioListTile<String>(
                      title: Text(lang.$2),
                      value: lang.$1,
                      groupValue: ref.read(readerLanguageProvider),
                      onChanged: (v) {
                        if (v != null) {
                          ref
                              .read(readerLanguageProvider.notifier)
                              .setLanguage(v);
                        }
                        Navigator.pop(ctx);
                      },
                      activeColor: AppColors.green,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: AppColors.green,
        ),
      ),
    );
  }
}
