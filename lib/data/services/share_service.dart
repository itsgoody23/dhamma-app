import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';
import '../../shared/widgets/sutta_share_card.dart';

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

  /// Share a passage as a styled card image.
  static Future<void> shareAsImage(
    SuttaText sutta, {
    String? selectedText,
    ShareCardStyle style = ShareCardStyle.forest,
  }) async {
    final passage = _resolvePassage(sutta, selectedText);
    final reference = '${sutta.title} (${sutta.uid})';

    // Render card widget to image
    final widget = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SuttaShareCard(
            passage: passage,
            reference: reference,
            style: style,
          ),
        ),
      ),
    );

    final pngBytes = await _renderWidgetToImage(widget, const Size(600, 800));
    if (pngBytes == null) return;

    // Write to temp file and share
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/sutta_share.png');
    await file.writeAsBytes(pngBytes);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: sutta.title,
      text: '— ${_buildAttribution(sutta)}',
    );
  }

  static Future<Uint8List?> _renderWidgetToImage(
    Widget widget,
    Size size,
  ) async {
    final repaintBoundary = RenderRepaintBoundary();
    final view = ui.PlatformDispatcher.instance.implicitView!;
    final renderView = RenderView(
      view: view,
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(size),
        devicePixelRatio: 3.0,
      ),
    );

    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    final buildOwner = BuildOwner(focusManager: FocusManager());

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      debugShortDescription: 'share_card',
      child: widget,
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return byteData?.buffer.asUint8List();
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
