import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/services/background_download_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WorkManager only supports Android and iOS.
  if (defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS) {
    await BackgroundDownloadService.initialize();
  }

  runApp(const ProviderScope(child: DhammaApp()));
}
