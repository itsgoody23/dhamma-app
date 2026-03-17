import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../data/database/app_database.dart';
import '../../shared/providers/dictionary_provider.dart';

class DictionaryScreen extends ConsumerStatefulWidget {
  const DictionaryScreen({super.key});

  @override
  ConsumerState<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends ConsumerState<DictionaryScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<PaliDictionaryEntry> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _loading = false;
      });
      return;
    }
    setState(() => _loading = true);
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      final dao = ref.read(dictionaryDaoProvider);
      final results = await dao.searchFuzzy(query.trim(), limit: 50);
      if (mounted) {
        setState(() {
          _results = results;
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.dictionaryTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.dictionarySearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_loading)
            const LinearProgressIndicator()
          else
            const SizedBox(height: 4),
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(
                      _controller.text.isEmpty
                          ? context.l10n.dictionaryEnterWord
                          : context.l10n.dictionaryNoResults,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final entry = _results[index];
                      return _DictionaryTile(entry: entry);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DictionaryTile extends StatefulWidget {
  const _DictionaryTile({required this.entry});

  final PaliDictionaryEntry entry;

  @override
  State<_DictionaryTile> createState() => _DictionaryTileState();
}

class _DictionaryTileState extends State<_DictionaryTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;

    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    entry.entry,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (entry.grammar != null)
                  Text(
                    entry.grammar!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
            if (!_expanded)
              Text(
                entry.definition,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            if (_expanded) ...[
              const SizedBox(height: 8),
              Text(entry.definition, style: theme.textTheme.bodyMedium),
              if (entry.crossRefs != null &&
                  entry.crossRefs!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '${context.l10n.dictionarySeeAlso}${entry.crossRefs}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
