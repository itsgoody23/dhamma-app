import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';

/// Strips unsafe tags/attributes from HTML content received from the ETL
/// pipeline or any other source, while preserving semantic structure.
///
/// Allowed inline tags: b, strong, em, i, u, mark, span, a, br, cite, abbr
/// Allowed block tags: p, h1–h6, blockquote, ul, ol, li, pre, code, div, hr
/// All other tags are unwrapped (children kept, tag removed).
/// All event attributes (on*) and javascript: hrefs are removed.
class HtmlSanitiser {
  // These tags (and their entire subtree) are deleted, not unwrapped.
  static const _deletedTags = {
    'script',
    'style',
    'svg',
    'iframe',
    'object',
    'embed',
    'noscript'
  };

  static const _allowedTags = {
    'p',
    'h1',
    'h2',
    'h3',
    'h4',
    'h5',
    'h6',
    'blockquote',
    'ul',
    'ol',
    'li',
    'pre',
    'code',
    'b',
    'strong',
    'em',
    'i',
    'u',
    'mark',
    'span',
    'a',
    'br',
    'hr',
    'div',
    'section',
    'article',
    'cite',
    'abbr',
    'sub',
    'sup',
  };

  static const _allowedAttributes = {
    'a': {'href', 'title', 'rel'},
    'abbr': {'title'},
    'span': {'class'},
    'div': {'class'},
    'p': {'class'},
    'blockquote': {'cite'},
  };

  /// Returns sanitised HTML. Never returns null — falls back to the
  /// plain-text representation on catastrophic parse failure.
  static String sanitise(String rawHtml) {
    try {
      final doc = html_parser.parseFragment(rawHtml);
      _sanitiseNode(doc);
      return doc.outerHtml;
    } catch (_) {
      // Fallback: strip all tags and return plain text.
      return html_parser.parse(rawHtml).body?.text ?? '';
    }
  }

  /// Returns plain text (no HTML tags) from HTML content.
  static String toPlainText(String rawHtml) {
    try {
      return html_parser.parse(rawHtml).body?.text ?? '';
    } catch (_) {
      return rawHtml;
    }
  }

  static void _sanitiseNode(Node node) {
    final children = node.nodes.toList();
    for (final child in children) {
      if (child is Element) {
        final tag = child.localName?.toLowerCase() ?? '';
        if (_deletedTags.contains(tag)) {
          // Delete entirely — never expose script/style content.
          node.nodes.remove(child);
          _sanitiseNode(node);
          return;
        } else if (_allowedTags.contains(tag)) {
          _stripDisallowedAttributes(child, tag);
          _sanitiseNode(child);
        } else {
          // Unwrap: replace the element with its children in the parent.
          final index = node.nodes.indexOf(child);
          node.nodes.remove(child);
          for (var i = 0; i < child.nodes.length; i++) {
            node.nodes.insert(index + i, child.nodes[i]);
          }
          // Re-sanitise the newly inserted children.
          _sanitiseNode(node);
          return; // Restart iteration since the list changed.
        }
      }
    }
  }

  static void _stripDisallowedAttributes(Element el, String tag) {
    final allowed = _allowedAttributes[tag] ?? <String>{};
    final toRemove = el.attributes.keys.where((k) {
      final key = k.toString().toLowerCase();
      if (key.startsWith('on')) return true; // block all event handlers
      return !allowed.contains(key);
    }).toList();
    for (final key in toRemove) {
      el.attributes.remove(key);
    }
    // Block javascript: hrefs.
    if (tag == 'a') {
      final href = el.attributes['href'] ?? '';
      if (href.toLowerCase().trimLeft().startsWith('javascript:')) {
        el.attributes.remove('href');
      }
    }
  }
}
