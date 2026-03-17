import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/services/community_service.dart';
import '../../../shared/providers/auth_provider.dart';

/// Provider for CommunityService.
final communityServiceProvider = Provider<CommunityService>((ref) {
  return CommunityService(ref.watch(supabaseClientProvider));
});

/// Provider to fetch community highlights for a given sutta UID.
final communityHighlightsProvider =
    FutureProvider.autoDispose.family<List<CommunityHighlight>, String>(
  (ref, textUid) {
    return ref.watch(communityServiceProvider).getHighlights(textUid);
  },
);

/// Toggle for showing community highlights in the reader.
class CommunityHighlightToggle extends ConsumerWidget {
  const CommunityHighlightToggle({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    // Only show toggle when signed in
    if (user == null) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(
        enabled ? Icons.people : Icons.people_outline,
        size: 20,
      ),
      tooltip: enabled ? 'Hide community highlights' : 'Show community highlights',
      onPressed: () => onChanged(!enabled),
    );
  }
}
