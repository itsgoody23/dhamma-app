// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhamma_talks_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(youtubeService)
final youtubeServiceProvider = YoutubeServiceProvider._();

final class YoutubeServiceProvider
    extends $FunctionalProvider<YoutubeService, YoutubeService, YoutubeService>
    with $Provider<YoutubeService> {
  YoutubeServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'youtubeServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$youtubeServiceHash();

  @$internal
  @override
  $ProviderElement<YoutubeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  YoutubeService create(Ref ref) {
    return youtubeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(YoutubeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<YoutubeService>(value),
    );
  }
}

String _$youtubeServiceHash() => r'0092cd6b465bd0831f07b86ea7f1710ef2fa84ff';

@ProviderFor(teacherTalks)
final teacherTalksProvider = TeacherTalksFamily._();

final class TeacherTalksProvider extends $FunctionalProvider<
        AsyncValue<List<AudioTrack>>,
        List<AudioTrack>,
        FutureOr<List<AudioTrack>>>
    with $FutureModifier<List<AudioTrack>>, $FutureProvider<List<AudioTrack>> {
  TeacherTalksProvider._(
      {required TeacherTalksFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'teacherTalksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$teacherTalksHash();

  @override
  String toString() {
    return r'teacherTalksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AudioTrack>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AudioTrack>> create(Ref ref) {
    final argument = this.argument as String;
    return teacherTalks(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TeacherTalksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$teacherTalksHash() => r'220528965a6235eef54b7f3664d6c480623b8921';

final class TeacherTalksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AudioTrack>>, String> {
  TeacherTalksFamily._()
      : super(
          retry: null,
          name: r'teacherTalksProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TeacherTalksProvider call(
    String channelId,
  ) =>
      TeacherTalksProvider._(argument: channelId, from: this);

  @override
  String toString() => r'teacherTalksProvider';
}

@ProviderFor(searchTalks)
final searchTalksProvider = SearchTalksFamily._();

final class SearchTalksProvider extends $FunctionalProvider<
        AsyncValue<List<AudioTrack>>,
        List<AudioTrack>,
        FutureOr<List<AudioTrack>>>
    with $FutureModifier<List<AudioTrack>>, $FutureProvider<List<AudioTrack>> {
  SearchTalksProvider._(
      {required SearchTalksFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'searchTalksProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$searchTalksHash();

  @override
  String toString() {
    return r'searchTalksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AudioTrack>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<AudioTrack>> create(Ref ref) {
    final argument = this.argument as String;
    return searchTalks(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SearchTalksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchTalksHash() => r'c5b2acb12239618464d7ef8141150d386753f538';

final class SearchTalksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AudioTrack>>, String> {
  SearchTalksFamily._()
      : super(
          retry: null,
          name: r'searchTalksProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SearchTalksProvider call(
    String query,
  ) =>
      SearchTalksProvider._(argument: query, from: this);

  @override
  String toString() => r'searchTalksProvider';
}

@ProviderFor(teacherChannels)
final teacherChannelsProvider = TeacherChannelsProvider._();

final class TeacherChannelsProvider extends $FunctionalProvider<
        AsyncValue<List<TeacherChannel>>,
        List<TeacherChannel>,
        FutureOr<List<TeacherChannel>>>
    with
        $FutureModifier<List<TeacherChannel>>,
        $FutureProvider<List<TeacherChannel>> {
  TeacherChannelsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'teacherChannelsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$teacherChannelsHash();

  @$internal
  @override
  $FutureProviderElement<List<TeacherChannel>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<TeacherChannel>> create(Ref ref) {
    return teacherChannels(ref);
  }
}

String _$teacherChannelsHash() => r'706fd1654aa46bf7a095c97fafeb11a852c04136';

@ProviderFor(curatedTalkCollections)
final curatedTalkCollectionsProvider = CuratedTalkCollectionsProvider._();

final class CuratedTalkCollectionsProvider extends $FunctionalProvider<
        AsyncValue<List<TalkCollection>>,
        List<TalkCollection>,
        FutureOr<List<TalkCollection>>>
    with
        $FutureModifier<List<TalkCollection>>,
        $FutureProvider<List<TalkCollection>> {
  CuratedTalkCollectionsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'curatedTalkCollectionsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$curatedTalkCollectionsHash();

  @$internal
  @override
  $FutureProviderElement<List<TalkCollection>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<TalkCollection>> create(Ref ref) {
    return curatedTalkCollections(ref);
  }
}

String _$curatedTalkCollectionsHash() =>
    r'35fe18a0fc4c1fed7a1213b171f798d92922fdf6';
