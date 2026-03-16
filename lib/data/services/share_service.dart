import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';

/// Wraps share_plus to provide sutta-aware sharing with CC-BY attribution.
///
/// Produces shareable text including:
/// - Sutta title
/// - Selected passage (or first 280 chars if none selected)
/// - Translator attribution (required by CC-BY licences)
/// - App credit
class ShareService {
  const ShareService._();

  /// Share a passage from a sutta. If [selectedText] is null, uses the first
  /// paragraph of [sutta.contentPlain] (up to 280 chars).
  static Future<void> sharePassage(
    SuttaText sutta, {
    String? selectedText,
  }) async {
    final passage = _resolvePassage(sutta, selectedText);
    final attribution = _buildAttribution(sutta);
    final shareText = '$passage\n\n— $attribution';

    await Share.share(
      shareText,
      subject: sutta.title,
    );
  }

  /// Share a sutta reference only (title + UID + translator).
  static Future<void> shareReference(SuttaText sutta) async {
    final attribution = _buildAttribution(sutta);
    final shareText = '"${sutta.title}" (${sutta.uid})\n$attribution';

    await Share.share(
      shareText,
      subject: sutta.title,
    );
  }

  // ── Internals ────────────────────────────────────────────────────────────

  static String _resolvePassage(SuttaText sutta, String? selected) {
    if (selected != null && selected.trim().isNotEmpty) {
      return selected.trim();
    }
    final plain = sutta.contentPlain ?? '';
    if (plain.isEmpty) return sutta.title;
    // Take the first meaningful paragraph — up to 280 chars
    final trimmed = plain.trim();
    if (trimmed.length <= 280) return trimmed;
    final cut = trimmed.substring(0, 280);
    // Break at last word boundary
    final lastSpace = cut.lastIndexOf(' ');
    return '${lastSpace > 0 ? cut.substring(0, lastSpace) : cut}…';
  }

  static String _buildAttribution(SuttaText sutta) {
    final parts = <String>[];

    if (sutta.translator != null && sutta.translator!.isNotEmpty) {
      parts.add('Trans. ${sutta.translator}');
    }

    // Source organisation
    final source = sutta.source ?? 'SuttaCentral';
    parts.add(source == 'sc' ? 'SuttaCentral (CC0/CC-BY)' : source);

    parts.add('Dhamma App — dhamma.app');
    return parts.join(' · ');
  }
}
