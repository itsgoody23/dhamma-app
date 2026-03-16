import 'package:flutter_test/flutter_test.dart';

import 'package:dhamma_app/core/utils/size_formatter.dart';

void main() {
  group('SizeFormatter.fromBytes', () {
    test('formats bytes below 1 KB', () {
      expect(SizeFormatter.fromBytes(0), '0 B');
      expect(SizeFormatter.fromBytes(512), '512 B');
      expect(SizeFormatter.fromBytes(1023), '1023 B');
    });

    test('formats kilobytes', () {
      expect(SizeFormatter.fromBytes(1024), '1.0 KB');
      expect(SizeFormatter.fromBytes(1536), '1.5 KB');
      expect(SizeFormatter.fromBytes(1024 * 1024 - 1), contains('KB'));
    });

    test('formats megabytes', () {
      expect(SizeFormatter.fromBytes(1024 * 1024), '1.0 MB');
      expect(SizeFormatter.fromBytes((8.2 * 1024 * 1024).round()), '8.2 MB');
    });

    test('formats gigabytes', () {
      expect(SizeFormatter.fromBytes(1024 * 1024 * 1024), '1.00 GB');
      expect(SizeFormatter.fromBytes((2.5 * 1024 * 1024 * 1024).round()),
          '2.50 GB');
    });
  });

  group('SizeFormatter.fromMb', () {
    test('formats sub-MB values in KB', () {
      expect(SizeFormatter.fromMb(0.5), '512 KB');
      expect(SizeFormatter.fromMb(0.25), '256 KB');
    });

    test('formats megabytes', () {
      expect(SizeFormatter.fromMb(1.0), '1.0 MB');
      expect(SizeFormatter.fromMb(8.2), '8.2 MB');
      expect(SizeFormatter.fromMb(100.0), '100.0 MB');
    });

    test('formats gigabytes', () {
      expect(SizeFormatter.fromMb(1024.0), '1.00 GB');
      expect(SizeFormatter.fromMb(2048.0), '2.00 GB');
    });
  });

  group('SizeFormatter.fromMbShort', () {
    test('formats megabytes without KB fallback', () {
      expect(SizeFormatter.fromMbShort(0.5), '0.5 MB');
      expect(SizeFormatter.fromMbShort(3.1), '3.1 MB');
      expect(SizeFormatter.fromMbShort(8.2), '8.2 MB');
    });

    test('formats gigabytes', () {
      expect(SizeFormatter.fromMbShort(1024.0), '1.0 GB');
      expect(SizeFormatter.fromMbShort(1536.0), '1.5 GB');
    });
  });
}
