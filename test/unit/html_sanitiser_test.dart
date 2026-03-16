import 'package:flutter_test/flutter_test.dart';
import 'package:dhamma_app/core/utils/html_sanitiser.dart';

void main() {
  group('HtmlSanitiser.sanitise', () {
    test('preserves allowed block tags', () {
      const input = '<p>Hello <strong>world</strong>.</p>';
      final result = HtmlSanitiser.sanitise(input);
      expect(result, contains('<p>'));
      expect(result, contains('<strong>'));
      expect(result, contains('Hello'));
    });

    test('strips script tags and their content', () {
      const input = '<p>Safe</p><script>alert("xss")</script>';
      final result = HtmlSanitiser.sanitise(input);
      expect(result, isNot(contains('<script>')));
      expect(result, isNot(contains('alert')));
      expect(result, contains('Safe'));
    });

    test('strips on* event attributes', () {
      const input = '<p onclick="evil()">Click me</p>';
      final result = HtmlSanitiser.sanitise(input);
      expect(result, isNot(contains('onclick')));
      expect(result, contains('Click me'));
    });

    test('strips javascript: href', () {
      const input = '<a href="javascript:evil()">Link</a>';
      final result = HtmlSanitiser.sanitise(input);
      expect(result, isNot(contains('javascript:')));
      expect(result, contains('Link'));
    });

    test('preserves safe href', () {
      const input = '<a href="https://suttacentral.net/mn1">MN 1</a>';
      final result = HtmlSanitiser.sanitise(input);
      expect(result, contains('href="https://suttacentral.net/mn1"'));
    });

    test('unwraps disallowed tags but keeps children', () {
      // <table> is not in the allowed list.
      const input = '<table><tr><td>Cell text</td></tr></table>';
      final result = HtmlSanitiser.sanitise(input);
      expect(result, isNot(contains('<table>')));
      expect(result, contains('Cell text'));
    });

    test('handles empty string without throwing', () {
      final result = HtmlSanitiser.sanitise('');
      expect(result, isA<String>());
    });

    test('handles plain text without throwing', () {
      final result = HtmlSanitiser.sanitise('No tags here');
      expect(result, contains('No tags here'));
    });

    test('strips style attribute from paragraphs', () {
      const input = '<p style="color:red">Styled text</p>';
      final result = HtmlSanitiser.sanitise(input);
      expect(result, isNot(contains('style=')));
      expect(result, contains('Styled text'));
    });
  });

  group('HtmlSanitiser.toPlainText', () {
    test('strips all tags', () {
      const input = '<p>Hello <strong>world</strong>.</p>';
      final result = HtmlSanitiser.toPlainText(input);
      expect(result, isNot(contains('<')));
      expect(result, contains('Hello'));
      expect(result, contains('world'));
    });

    test('handles empty string', () {
      expect(HtmlSanitiser.toPlainText(''), isEmpty);
    });
  });
}
