class ContentPack {
  const ContentPack({
    required this.packId,
    required this.packName,
    required this.language,
    required this.suttaCount,
    required this.sizeMb,
    required this.compressedSizeMb,
    required this.downloadUrl,
    required this.checksumSha256,
    this.nikaya,
    this.version,
  });

  final String packId;
  final String packName;
  final String language;
  final int suttaCount;
  final double sizeMb;
  final double compressedSizeMb;
  final String downloadUrl;
  final String checksumSha256;
  final String? nikaya;
  final String? version;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentPack && packId == other.packId;

  @override
  int get hashCode => packId.hashCode;

  factory ContentPack.fromJson(Map<String, dynamic> json) => ContentPack(
        packId: json['pack_id'] as String,
        packName: json['pack_name'] as String,
        language: json['language'] as String,
        suttaCount: json['sutta_count'] as int,
        sizeMb: (json['size_mb'] as num).toDouble(),
        compressedSizeMb: (json['compressed_size_mb'] as num).toDouble(),
        downloadUrl: json['download_url'] as String,
        checksumSha256: json['checksum_sha256'] as String,
        nikaya: json['nikaya'] as String?,
        version: json['version'] as String?,
      );
}
