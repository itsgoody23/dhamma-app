import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/package_publish_service.dart';
import '../../shared/providers/auth_provider.dart';

final packagePublishServiceProvider = Provider<PackagePublishService>((ref) {
  return PackagePublishService(ref.watch(supabaseClientProvider));
});

/// Parameters for browsing community packages.
class BrowseParams {
  const BrowseParams({this.language, this.orderBy = 'created_at'});
  final String? language;
  final String orderBy;

  @override
  bool operator ==(Object other) =>
      other is BrowseParams &&
      other.language == language &&
      other.orderBy == orderBy;

  @override
  int get hashCode => Object.hash(language, orderBy);
}

final communityPackagesProvider = FutureProvider.autoDispose
    .family<List<TranslationPackage>, BrowseParams>((ref, params) {
  return ref.watch(packagePublishServiceProvider).browsePackages(
        language: params.language,
        orderBy: params.orderBy,
      ).timeout(
    const Duration(seconds: 10),
    onTimeout: () => [],
  );
});

final myPackagesProvider =
    FutureProvider.autoDispose<List<TranslationPackage>>((ref) {
  return ref.watch(packagePublishServiceProvider).getMyPackages();
});
