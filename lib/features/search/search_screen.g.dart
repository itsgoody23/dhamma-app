// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchFiltersNotifier)
final searchFiltersProvider = SearchFiltersNotifierProvider._();

final class SearchFiltersNotifierProvider
    extends $NotifierProvider<SearchFiltersNotifier, SearchFilters> {
  SearchFiltersNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'searchFiltersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchFiltersNotifierHash();

  @$internal
  @override
  SearchFiltersNotifier create() => SearchFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilters>(value),
    );
  }
}

String _$searchFiltersNotifierHash() =>
    r'8c5f538c1afb1738d84216ca7c9811a743d9824a';

abstract class _$SearchFiltersNotifier extends $Notifier<SearchFilters> {
  SearchFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchFilters, SearchFilters>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SearchFilters, SearchFilters>,
        SearchFilters,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsFamily._();

final class SearchResultsProvider extends $FunctionalProvider<
        AsyncValue<List<SearchResult>>,
        List<SearchResult>,
        FutureOr<List<SearchResult>>>
    with
        $FutureModifier<List<SearchResult>>,
        $FutureProvider<List<SearchResult>> {
  SearchResultsProvider._(
      {required SearchResultsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'searchResultsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @override
  String toString() {
    return r'searchResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SearchResult>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<SearchResult>> create(Ref ref) {
    final argument = this.argument as String;
    return searchResults(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchResultsHash() => r'373fb624b3ecc3389a9c7da9365f4291dd105187';

final class SearchResultsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SearchResult>>, String> {
  SearchResultsFamily._()
      : super(
          retry: null,
          name: r'searchResultsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SearchResultsProvider call(
    String query,
  ) =>
      SearchResultsProvider._(argument: query, from: this);

  @override
  String toString() => r'searchResultsProvider';
}
