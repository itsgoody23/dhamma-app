import 'dart:convert';
import 'package:flutter/services.dart';

class ParallelSutta {
  const ParallelSutta({required this.uid, this.title});
  final String uid;
  final String? title;
}

class ParallelsService {
  ParallelsService._();
  static final instance = ParallelsService._();

  Map<String, List<String>>? _parallelsMap;

  Future<void> _ensureLoaded() async {
    if (_parallelsMap != null) return;
    try {
      final jsonStr =
          await rootBundle.loadString('assets/data/parallels.json');
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      _parallelsMap = map.map(
        (key, value) => MapEntry(
          key,
          (value as List).cast<String>(),
        ),
      );
    } catch (_) {
      _parallelsMap = {};
    }
  }

  Future<List<String>> getParallelUids(String uid) async {
    await _ensureLoaded();
    // Check direct mapping
    final direct = _parallelsMap?[uid];
    if (direct != null) return direct;

    // Check reverse — if this uid appears as a parallel of another
    final reverse = <String>[];
    _parallelsMap?.forEach((key, values) {
      if (values.contains(uid)) {
        reverse.add(key);
      }
    });
    return reverse;
  }
}
