// Utilities for handling sutta UID ranges like 'dhp1-20'.

final _rangePattern = RegExp(r'^([a-z]+)(\d+)-(\d+)$');

/// Whether [uid] is a range UID like 'dhp1-20' or 'dhp100-115'.
bool isRangeUid(String uid) => _rangePattern.hasMatch(uid);

/// Expands a range UID into individual UIDs.
/// e.g. 'dhp1-20' → ['dhp1', 'dhp2', ..., 'dhp20']
/// Returns [uid] in a single-element list if not a range.
/// Caps range to 500 items and validates start <= end.
List<String> expandRangeUid(String uid) {
  final match = _rangePattern.firstMatch(uid);
  if (match == null) return [uid];

  final prefix = match.group(1)!;
  final start = int.parse(match.group(2)!);
  final end = int.parse(match.group(3)!);

  if (end < start || end - start > 500) return [uid];

  return [for (var i = start; i <= end; i++) '$prefix$i'];
}

/// Extracts the nikaya prefix from a UID (e.g. 'mn' from 'mn1').
String uidPrefix(String uid) {
  final match = RegExp(r'^([a-z]+)').firstMatch(uid);
  return match?.group(1) ?? uid;
}
