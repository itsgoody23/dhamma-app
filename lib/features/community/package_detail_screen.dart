import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_sizes.dart';
import '../../data/services/package_publish_service.dart';
import '../../data/services/translation_package_service.dart';
import '../../shared/providers/database_provider.dart';
import 'community_providers.dart';

class PackageDetailScreen extends ConsumerStatefulWidget {
  const PackageDetailScreen({super.key, required this.packageId});

  final int packageId;

  @override
  ConsumerState<PackageDetailScreen> createState() =>
      _PackageDetailScreenState();
}

class _PackageDetailScreenState extends ConsumerState<PackageDetailScreen> {
  TranslationPackage? _package;
  bool _loading = true;
  bool _importing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPackage();
  }

  Future<void> _loadPackage() async {
    try {
      final service = ref.read(packagePublishServiceProvider);
      final pkg = await service.getPackageById(widget.packageId);
      if (mounted) {
        setState(() {
          _package = pkg;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _importPackage() async {
    if (_package == null) return;
    setState(() => _importing = true);

    try {
      final db = ref.read(appDatabaseProvider);
      final service = TranslationPackageService(db: db);
      final jsonStr = jsonEncode(_package!.packageJson);
      final result = await service.importPackageFromJson(jsonStr);

      // Increment download counter
      await ref
          .read(packagePublishServiceProvider)
          .incrementDownloads(widget.packageId);

      if (mounted) {
        setState(() => _importing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Imported ${result.translations} translations, '
              '${result.commentary} commentary',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _importing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_package?.title ?? 'Package'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _package == null
                  ? const Center(child: Text('Package not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSizes.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            _package!.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Author + language
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                _package!.authorName,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _package!.language.toUpperCase(),
                                  style: theme.textTheme.labelSmall,
                                ),
                              ),
                            ],
                          ),
                          // Description
                          if (_package!.description.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              _package!.description,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                          const SizedBox(height: 24),
                          // Stats
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSizes.md),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _Stat(
                                    icon: Icons.translate,
                                    label: 'Translations',
                                    value:
                                        '${_package!.translationCount}',
                                  ),
                                  _Stat(
                                    icon: Icons.comment_outlined,
                                    label: 'Commentary',
                                    value:
                                        '${_package!.commentaryCount}',
                                  ),
                                  _Stat(
                                    icon: Icons.download,
                                    label: 'Downloads',
                                    value: '${_package!.downloads}',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Import button
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _importing ? null : _importPackage,
                              icon: _importing
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.download),
                              label: Text(_importing
                                  ? 'Importing…'
                                  : 'Import Package'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Translations will be merged with your existing data.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.labelSmall),
      ],
    );
  }
}
