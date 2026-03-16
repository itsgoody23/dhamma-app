import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/routing/routes.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/preferences_provider.dart';

// Note: add url_launcher: ^6.3.0 to pubspec.yaml

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(readerFontSizeProvider);
    final language = ref.watch(readerLanguageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Reading ───────────────────────────────────────────────────────
          const _SectionHeader(title: 'Reading'),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_themeName(themeMode)),
            leading: const Icon(Icons.brightness_6_outlined),
            onTap: () => _pickTheme(context, ref),
          ),
          ListTile(
            title: const Text('Font size'),
            subtitle: Text(_fontSizeName(fontSize)),
            leading: const Icon(Icons.format_size_outlined),
            onTap: () => _pickFontSize(context, ref),
          ),
          ListTile(
            title: const Text('Default language'),
            subtitle: Text(language.toUpperCase()),
            leading: const Icon(Icons.language_outlined),
            onTap: () => _pickLanguage(context, ref),
          ),

          const Divider(),

          // ── Downloads ─────────────────────────────────────────────────────
          const _SectionHeader(title: 'Downloads'),
          Consumer(builder: (context, ref, _) {
            final wifiOnly = ref.watch(wifiOnlyProvider);
            return SwitchListTile(
              title: const Text('Wi-Fi only downloads'),
              subtitle: const Text('Prevents downloads on mobile data'),
              secondary: const Icon(Icons.wifi_outlined),
              value: wifiOnly,
              activeTrackColor: AppColors.green,
              onChanged: (v) => ref.read(wifiOnlyProvider.notifier).set(v),
            );
          }),

          const Divider(),

          // ── Account ─────────────────────────────────────────────────────
          const _SectionHeader(title: 'Account'),
          Consumer(builder: (context, ref, _) {
            final user = ref.watch(currentUserProvider);
            if (user != null) {
              return Column(children: [
                ListTile(
                  title: Text(user.email ?? 'Signed in'),
                  subtitle: const Text('Manage account'),
                  leading: const Icon(Icons.person_outlined),
                  onTap: () => context.push(Routes.profile),
                ),
                Consumer(builder: (context, ref, _) {
                  final wifiOnlySync = ref.watch(wifiOnlySyncProvider);
                  return SwitchListTile(
                    title: const Text('Sync on Wi-Fi only'),
                    subtitle: const Text('Prevents sync on mobile data'),
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
              title: const Text('Sign in'),
              subtitle: const Text('Sync your progress across devices'),
              leading: const Icon(Icons.login_outlined),
              onTap: () => context.push(Routes.login),
            );
          }),

          const Divider(),

          // ── About ─────────────────────────────────────────────────────────
          const _SectionHeader(title: 'About'),
          ListTile(
            title: const Text('Licences'),
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
            title: const Text('Source code'),
            subtitle: const Text('MIT / Apache 2.0 — github.com/dhamma-app'),
            leading: const Icon(Icons.code_outlined),
            onTap: () => launchUrl(Uri.parse('https://github.com/dhamma-app')),
          ),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'),
            leading: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }

  String _themeName(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'System default',
      };

  String _fontSizeName(double size) => switch (size) {
        AppTypography.fontSizeSmall => 'Small',
        AppTypography.fontSizeMedium => 'Medium',
        AppTypography.fontSizeLarge => 'Large',
        AppTypography.fontSizeXL => 'Extra Large',
        _ => '${size.round()}pt',
      };

  void _pickTheme(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Theme'),
        children: [
          RadioGroup<ThemeMode>(
            groupValue: ref.read(themeModeProvider),
            onChanged: (v) {
              if (v != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(v);
              }
              Navigator.pop(ctx);
            },
            child: Column(
              children: ThemeMode.values
                  .map((mode) => RadioListTile<ThemeMode>(
                        title: Text(_themeName(mode)),
                        value: mode,
                        activeColor: AppColors.green,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _pickFontSize(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Font size'),
        children: [
          RadioGroup<double>(
            groupValue: ref.read(readerFontSizeProvider),
            onChanged: (v) {
              if (v != null) {
                ref.read(readerFontSizeProvider.notifier).setFontSize(v);
              }
              Navigator.pop(ctx);
            },
            child: Column(
              children: AppTypography.readerFontSizes
                  .asMap()
                  .entries
                  .map((e) => RadioListTile<double>(
                        title: Text(AppTypography.readerFontSizeLabels[e.key]),
                        value: e.value,
                        activeColor: AppColors.green,
                      ))
                  .toList(),
            ),
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
        title: const Text('Default language'),
        children: [
          RadioGroup<String>(
            groupValue: ref.read(readerLanguageProvider),
            onChanged: (v) {
              if (v != null) {
                ref.read(readerLanguageProvider.notifier).setLanguage(v);
              }
              Navigator.pop(ctx);
            },
            child: Column(
              children: languages
                  .map((lang) => RadioListTile<String>(
                        title: Text(lang.$2),
                        value: lang.$1,
                        activeColor: AppColors.green,
                      ))
                  .toList(),
            ),
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
