import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routing/routes.dart';
import '../../data/models/content_pack.dart';
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _page++);
    } else {
      _finish();
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
      _next();
      return;
    }
    setState(() => _downloading = true);

    final service = ref.read(packDownloadServiceProvider);
    service.progressStream(_selectedPack!.packId).listen((p) {
      if (mounted) {
        setState(() => _downloadFraction = p.fraction);
        if (p.isDone) {
          _next();
        }
      }
    });

    await service.downloadPack(_selectedPack!, wifiOnly: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    List.generate(5, (index) => _Dot(active: index == _page)),
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
          const Text(
            'Dhamma App',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          const Text(
            'The Pali Canon, in your pocket.\nFree, forever.',
            style: TextStyle(fontSize: 18, color: Colors.grey, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xxl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
                onPressed: onNext, child: const Text('Get started')),
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
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose your language',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.sm),
          const Text('You can change this later in Settings',
              style: TextStyle(color: Colors.grey)),
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
                FilledButton(onPressed: onNext, child: const Text('Continue')),
          ),
          const SizedBox(height: AppSizes.sm),
          Center(
              child: TextButton(
                  onPressed: onSkip, child: const Text('Skip for now'))),
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
          const Text('Download your first pack',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.sm),
          const Text(
              'Start with the Middle-Length Discourses — a great introduction to the Dhamma',
              style: TextStyle(color: Colors.grey, height: 1.5)),
          const SizedBox(height: AppSizes.lg),
          Expanded(
            child: packsAsync.when(
              data: (packs) {
                final filtered = language != null
                    ? packs.where((p) => p.language == language).toList()
                    : packs;
                return RadioGroup<ContentPack?>(
                  groupValue: selectedPack,
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
              error: (_, __) => const Text(
                  'Could not load pack list. You can download packs later.'),
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
                  ? 'Downloading… ${(fraction * 100).round()}%'
                  : 'Installing…',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          const SizedBox(height: AppSizes.md),
          if (!downloading) ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: onDownload, child: const Text('Download')),
            ),
            const SizedBox(height: AppSizes.sm),
            Center(
                child: TextButton(
                    onPressed: onSkip,
                    child: const Text('Skip — download later'))),
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
          const Text('How to navigate',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSizes.lg),
          const _NavTip(
            icon: Icons.menu_book_outlined,
            title: 'Library',
            body:
                'Browse the Pali Canon by Nikāya — from the Dīgha to the Khuddaka.',
          ),
          const SizedBox(height: AppSizes.md),
          const _NavTip(
            icon: Icons.search_outlined,
            title: 'Search',
            body:
                'Find any sutta by keyword, title, or phrase — even with or without diacritics.',
          ),
          const SizedBox(height: AppSizes.md),
          const _NavTip(
            icon: Icons.wb_sunny_outlined,
            title: 'Daily',
            body: 'A different sutta every day, plus structured reading plans.',
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onNext, child: const Text('Got it')),
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
          const Text(
            'You\'re ready',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.sm),
          const Text(
            'May your study be a source of wisdom\nand liberation.',
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.xxl),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onStart,
              child: const Text('Start reading'),
            ),
          ),
        ],
      ),
    );
  }
}
