/// Represents a playable audio track in the app.
enum AudioTrackType { chanting, talk, meditation }

class AudioTrack {
  const AudioTrack({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
    this.teacher,
    this.duration,
    this.suttaUid,
    this.thumbnailUrl,
    this.isLocal = false,
  });

  final String id;
  final String title;
  final String url;
  final AudioTrackType type;
  final String? teacher;
  final Duration? duration;
  final String? suttaUid;
  final String? thumbnailUrl;
  final bool isLocal;

  factory AudioTrack.fromJson(Map<String, dynamic> json) => AudioTrack(
        id: json['id'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        type: AudioTrackType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => AudioTrackType.talk,
        ),
        teacher: json['teacher'] as String?,
        duration: json['duration_seconds'] != null
            ? Duration(seconds: json['duration_seconds'] as int)
            : null,
        suttaUid: json['sutta_uid'] as String?,
        thumbnailUrl: json['thumbnail_url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'type': type.name,
        'teacher': teacher,
        'duration_seconds': duration?.inSeconds,
        'sutta_uid': suttaUid,
        'thumbnail_url': thumbnailUrl,
      };

  AudioTrack copyWith({String? url, bool? isLocal}) => AudioTrack(
        id: id,
        title: title,
        url: url ?? this.url,
        type: type,
        teacher: teacher,
        duration: duration,
        suttaUid: suttaUid,
        thumbnailUrl: thumbnailUrl,
        isLocal: isLocal ?? this.isLocal,
      );
}
