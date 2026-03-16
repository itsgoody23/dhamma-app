import 'package:flutter_test/flutter_test.dart';

// ── Helpers duplicated from daily_screen.dart for isolated testing ─────────────
// (In a larger codebase these would be extracted to a shared utility.)

int dayOfYear(DateTime dt) {
  return dt.difference(DateTime(dt.year, 1, 1)).inDays + 1;
}

void main() {
  group('dayOfYear', () {
    test('1 January → 1', () {
      expect(dayOfYear(DateTime(2026, 1, 1)), 1);
    });

    test('31 December non-leap year → 365', () {
      expect(dayOfYear(DateTime(2025, 12, 31)), 365);
    });

    test('31 December leap year → 366', () {
      expect(dayOfYear(DateTime(2024, 12, 31)), 366);
    });

    test('28 February non-leap year → 59', () {
      expect(dayOfYear(DateTime(2025, 2, 28)), 59);
    });

    test('29 February leap year → 60', () {
      expect(dayOfYear(DateTime(2024, 2, 29)), 60);
    });

    test('1 March non-leap year → 60', () {
      expect(dayOfYear(DateTime(2025, 3, 1)), 60);
    });

    test('1 March leap year → 61', () {
      expect(dayOfYear(DateTime(2024, 3, 1)), 61);
    });

    test('15 March 2026 → 74', () {
      // Today's date per system context.
      expect(dayOfYear(DateTime(2026, 3, 15)), 74);
    });
  });
}
