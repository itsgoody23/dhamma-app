import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../database/app_database.dart';

/// Generates a PDF for a single sutta and shares it via the system share sheet.
///
/// Layout: title header, translator attribution block, body text.
/// The PDF uses embedded base fonts (Helvetica) so no font assets are needed.
class PdfExportService {
  /// Builds and shares a PDF for [sutta].
  /// Shows the system share sheet on completion.
  static Future<void> exportAndShare(SuttaText sutta) async {
    final bytes = await _buildPdf(sutta);

    final dir = await getTemporaryDirectory();
    final filename = '${_safeFilename(sutta.uid)}.pdf';
    final file = File(p.join(dir.path, filename));
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: sutta.title,
    );
  }

  static Future<List<int>> _buildPdf(SuttaText sutta) async {
    final doc = pw.Document(
      title: sutta.title,
      author: sutta.translator ?? 'Unknown translator',
    );

    // Use PDF's built-in base fonts — no asset needed.
    final titleFont = pw.Font.helveticaBold();
    final bodyFont = pw.Font.helvetica();
    final monoFont = pw.Font.courier();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(52),
        header: (ctx) => _buildHeader(ctx, sutta, titleFont, bodyFont),
        footer: (ctx) => _buildFooter(ctx, bodyFont),
        build: (ctx) => [
          pw.SizedBox(height: 24),
          // Body text — use content_plain (pre-stripped HTML)
          pw.Text(
            sutta.contentPlain ?? 'No content available.',
            style: pw.TextStyle(
              font: bodyFont,
              fontSize: 11,
              lineSpacing: 4,
            ),
          ),
          pw.SizedBox(height: 32),
          // Translator attribution block (required by CC-BY)
          _buildAttribution(sutta, monoFont),
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _buildHeader(
    pw.Context ctx,
    SuttaText sutta,
    pw.Font titleFont,
    pw.Font bodyFont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          sutta.title,
          style: pw.TextStyle(
            font: titleFont,
            fontSize: 18,
          ),
        ),
        if (sutta.chapter != null)
          pw.Text(
            sutta.chapter!,
            style: pw.TextStyle(
                font: bodyFont, fontSize: 10, color: PdfColors.grey600),
          ),
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
      ],
    );
  }

  static pw.Widget _buildFooter(pw.Context ctx, pw.Font font) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Dhamma App — dhamma.app',
          style:
              pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500),
        ),
        pw.Text(
          'Page ${ctx.pageNumber} of ${ctx.pagesCount}',
          style:
              pw.TextStyle(font: font, fontSize: 8, color: PdfColors.grey500),
        ),
      ],
    );
  }

  static pw.Widget _buildAttribution(SuttaText sutta, pw.Font font) {
    final lines = <String>[
      'Translation: ${sutta.translator ?? "Unknown"}',
      if (sutta.source != null) _sourceLabel(sutta.source!),
      'Exported from Dhamma App — dhamma.app',
    ];

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: lines
            .map(
              (l) => pw.Text(
                l,
                style: pw.TextStyle(
                    font: font, fontSize: 9, color: PdfColors.grey700),
              ),
            )
            .toList(),
      ),
    );
  }

  static String _sourceLabel(String source) => switch (source) {
        'sc' => 'Source: SuttaCentral — suttacentral.net',
        'ati' => 'Source: Access to Insight — accesstoinsight.org (CC-BY 4.0)',
        _ => 'Source: $source',
      };

  static String _safeFilename(String uid) =>
      uid.replaceAll(RegExp(r'[^\w\-]'), '_');
}
