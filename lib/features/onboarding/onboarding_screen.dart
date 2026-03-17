import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../core/routing/routes.dart';
import '../../data/models/content_pack.dart';
import '../../data/services/pack_download_service.dart';
import '../../shared/providers/preferences_provider.dart';
import '../downloads/downloads_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  String? _selectedLanguage;
  ContentPack? _selectedPack;
  bool _downloading = false;
  double _downloadFraction = 0;
  StreamSubscription<dynamic>? _downloadSubscription;

  static const _supportedLanguageCodes = {'en', 'pli', 'de', 'fr', 'es', 'si'};

  @override
  void initState() {
    super.initState();
    // Auto-detect device locale → pre-select matching content language
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final code = deviceLocale.languageCode;
    if (_supportedLanguageCodes.contains(code)) {
      _selectedLanguage = code;
    }
  }

  @override
  void dispose() {
    _downloadSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 4) {
      // When advancing past the language page, set the content language
      if (_page == 1 && _selectedLanguage != null) {
        const contentLanguages = {'en', 'pli', 'de', 'fr', 'es'};
        final contentLang = contentLanguages.contains(_selectedLanguage)
            ? _selectedLanguage!
            : 'en';
        ref.read(readerLanguageProvider.notifier).setLanguage(contentLang);
      }
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _page++);
    } else {
      _finish();
    }
  }

  void _back() {
    if (_page > 0) {
      HapticFeedback.lightImpact();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _page--);
    }
  }

  void _skip() => _finish();

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) context.go(Routes.daily);
  }

  Future<void> _startDownload() async {
    if (_selectedPack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pack to download')),
      );
      return;
    }
    setState(() => _downloading = true);

    try {
      final service = ref.read(packDownloadServiceProvider);
      _downloadSubscription =
          service.progressStream(_selectedPack!.packId).listen(
        (p) {
          if (mounted) {
            setState(() => _downloadFraction = p.fraction);
            if (p.state == DownloadState.completed) {
              setState(() => _downloading = false);
              _next();
            }
          }
        },
        onError: (Object e) {
          if (mounted) {
            setState(() => _downloading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Download failed: $e')),
            );
          }
        },
      );

      await service.downloadPack(_selectedPack!, wifiOnly: false);
    } catch (e) {
      if (mounted) {
        setState(() => _downloading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back button + Progress dots
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                children: [
                  if (_page > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _back,
                      tooltip: 'Back',
                    )
                  else
                    const SizedBox(width: 48),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          5, (index) => _Dot(active: index == _page)),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomePage(onNext: _next),
                  _LanguagePage(
                    onLanguageSelected: (lang) =>
                        setState(() => _selectedLanguage = lang),
                    selectedLanguage: _selectedLanguage,
                    onNext: _next,
                    onSkip: _skip,
                  ),
                  _DownloadPage(
                    language: _selectedLanguage,
                    onPackSelected: (pack) =>
                        setState(() => _selectedPack = pack),
                    selectedPack: _selectedPack,
                    downloading: _downloading,
                    fraction: _downloadFraction,
                    onDownload: _startDownload,
                    onSkip: _next,
                  ),
                  _HowToPage(onNext: _next),
                  _DonePage(onStart: _finish),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: active ? 20 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color:
            active ? AppColors.green : AppColors.green.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ── Page 1: Welcome ───────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.spa, size: 52, color: AppColors.green),
          ),
          const SizedBox(height: AppSizes.xl),
          Text(
            context.l10n.onboardingHeading,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            context.l10n.onboardingSubtitle,
            style: const TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xxl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
                onPressed: onNext, child: Text(context.l10n.onboardingGetStarted)),
          ),
        ],
      ),
    );
  }
}

// ── Page 2: Choose language ───────────────────────────────────────────────────

class _LanguagePage extends StatelessWidget {
  const _LanguagePage({
    required this.onLanguageSelected,
    required this.selectedLanguage,
    required this.onNext,
    required this.onSkip,
  });

  final ValueChanged<String> onLanguageSelected;
  final String? selectedLanguage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  static const _languages = [
    ('en', 'English'),
    ('pli', 'Pāli'),
    ('de', 'Deutsch'),
    ('fr', 'Français'),
    ('es', 'Español'),
    ('si', 'සිංහල'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.onboardingChooseLanguage,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.sm),
          Text(context.l10n.onboardingChangeLanguageLater,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: AppSizes.lg),
          Wrap(
            spacing: AppSizes.sm,
            runSpacing: AppSizes.sm,
            children: _languages
                .map((lang) => ChoiceChip(
                      label: Text(lang.$2),
                      selected: selectedLanguage == lang.$1,
                      onSelected: (_) => onLanguageSelected(lang.$1),
                    ))
                .toList(),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child:
                FilledButton(onPressed: onNext, child: Text(context.l10n.onboardingContinue)),
          ),
          const SizedBox(height: AppSizes.sm),
          Center(
              child: TextButton(
                  onPressed: onSkip, child: Text(context.l10n.onboardingSkipForNow))),
        ],
      ),
    );
  }
}

// ── Page 3: Download first pack ───────────────────────────────────────────────

class _DownloadPage extends ConsumerWidget {
  const _DownloadPage({
    required this.language,
    required this.onPackSelected,
    required this.selectedPack,
    required this.downloading,
    required this.fraction,
    required this.onDownload,
    required this.onSkip,
  });

  final String? language;
  final ValueChanged<ContentPack> onPackSelected;
  final ContentPack? selectedPack;
  final bool downloading;
  final double fraction;
  final VoidCallback onDownload;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packsAsync = ref.watch(availablePacksProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.onboardingDownloadFirst,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.sm),
          Text(
              context.l10n.onboardingDownloadHint,
              style: const TextStyle(color: Colors.grey, height: 1.5)),
          const SizedBox(height: AppSizes.lg),
          Expanded(
            child: packsAsync.when(
              data: (packs) {
                final filtered = language != null
                    ? packs.where((p) => p.language == language).toList()
                    : packs;
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(context.l10n.onboardingDownloadError),
                  );
                }
                final effective = selectedPack ?? filtered.first;
                return RadioGroup<ContentPack>(
                  groupValue: effective,
                  onChanged: (p) {
                    if (p != null) onPackSelected(p);
                  },
                  child: ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final pack = filtered[index];
                      return RadioListTile<ContentPack>(
                        value: pack,
                        title: Text(pack.packName),
                        subtitle: Text(
                            '${pack.compressedSizeMb.toStringAsFixed(1)} MB · ${pack.suttaCount} suttas'),
                        activeColor: AppColors.green,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => Text(context.l10n.onboardingDownloadError),
            ),
          ),
          if (downloading) ...[
            const SizedBox(height: AppSizes.md),
            LinearProgressIndicator(
              value: fraction,
              backgroundColor: AppColors.green.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation(AppColors.green),
            ),
            const SizedBox(height: 4),
            Text(
              fraction < 1
                  ? context.l10n.onboardingDownloading((fraction * 100).round())
                  : context.l10n.onboardingInstalling,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          const SizedBox(height: AppSizes.md),
          if (!downloading) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: onDownload, child: Text(context.l10n.onboardingDownload)),
            ),
            const SizedBox(height: AppSizes.sm),
            Center(
                child: TextButton(
                    onPressed: onSkip,
                    child: Text(context.l10n.onboardingSkipDownload))),
          ],
        ],
      ),
    );
  }
}

// ── Page 4: How to navigate ───────────────────────────────────────────────────

class _HowToPage extends StatelessWidget {
  const _HowToPage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.onboardingHowToNavigate,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.lg),
          _NavTip(
            icon: Icons.menu_book_outlined,
            title: context.l10n.onboardingNavLibrary,
            body: context.l10n.onboardingNavLibraryDesc,
          ),
          const SizedBox(height: AppSizes.md),
          _NavTip(
            icon: Icons.search_outlined,
            title: context.l10n.onboardingNavSearch,
            body: context.l10n.onboardingNavSearchDesc,
          ),
          const SizedBox(height: AppSizes.md),
          _NavTip(
            icon: Icons.wb_sunny_outlined,
            title: context.l10n.onboardingNavDaily,
            body: context.l10n.onboardingNavDailyDesc,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onNext, child: Text(context.l10n.onboardingGotIt)),
          ),
        ],
      ),
    );
  }
}

class _NavTip extends StatelessWidget {
  const _NavTip({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.green, size: 22),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 4),
              Text(body,
                  style: const TextStyle(color: Colors.grey, height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Page 5: Done ──────────────────────────────────────────────────────────────

class _DonePage extends StatelessWidget {
  const _DonePage({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite, size: 72, color: AppColors.green),
          const SizedBox(height: AppSizes.xl),
          Text(
            context.l10n.onboardingReady,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            context.l10n.onboardingReadySubtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xxl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onStart,
              child: Text(context.l10n.onboardingStartReading),
            ),
          ),
        ],
      ),
    );
  }
}
