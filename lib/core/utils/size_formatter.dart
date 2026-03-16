/// Formats a byte count or megabyte value into a human-readable string.
abstract final class SizeFormatter {
  /// Formats [bytes] into the most appropriate unit (B, KB, MB, GB).
  static String fromBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Formats [mb] (already in megabytes) into a human-readable string.
  static String fromMb(double mb) {
    if (mb < 1) return '${(mb * 1024).round()} KB';
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
    return '${(mb / 1024).toStringAsFixed(2)} GB';
  }

  /// Short form: e.g. "8.2 MB", "3.1 GB". No KB fallback.
  static String fromMbShort(double mb) {
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
    return '${(mb / 1024).toStringAsFixed(1)} GB';
  }
}
