/// Converts sutta HTML content into readable plain text with paragraph breaks.
///
/// The ETL `content_plain` field uses `get_text(separator=" ")` which strips
/// all paragraph structure. This utility preserves block-level breaks so the
/// text renders nicely in [SelectableText.rich].
String htmlToReadableText(String html) {
  // Insert newlines before block-level tags so we can split on them later.
  var text = html;

  // Replace <br> variants with newline.
  text = text.replaceAll(RegExp(r'<br\s*/?>'), '\n');

  // Insert double-newline before block-level opening tags.
  text = text.replaceAllMapped(
    RegExp(r'<(p|h[1-6]|blockquote|div|article|section|li|tr)[\s>]',
        caseSensitive: false),
    (m) {
      final tag = m[1]!;
      final full = m[0]!;
      return '\n\n<$tag${full.substring(full.indexOf('<') + 1 + tag.length)}';
    },
  );

  // Strip all remaining HTML tags.
  text = text.replaceAll(RegExp(r'<[^>]+>'), '');

  // Decode common HTML entities.
  text = text
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&#160;', ' ');

  // Collapse runs of whitespace within each line (but preserve newlines).
  text = text.replaceAll(RegExp(r'[^\S\n]+'), ' ');

  // Normalize multiple blank lines into exactly two newlines (one blank line).
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  // Trim leading/trailing whitespace from each line and the whole string.
  text = text
      .split('\n')
      .map((line) => line.trim())
      .join('\n')
      .trim();

  return text;
}
