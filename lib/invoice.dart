import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:marble/item.dart';
import 'package:marble/util.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Invoice {
  Invoice(
      {required this.products,
      required this.baseColor,
      required this.accentColor,
      required this.font});

  final List<BaseItem> products;
  final PdfColor baseColor;
  final PdfColor accentColor;
  final pw.Font font;

  double get _total =>
      products.map<double>((p) => p.price()).fold(0, (a, b) => a + b);

  Uint8List _logo = Uint8List(0);

  String? _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    final ByteData bytes = await rootBundle.load('assets/logo.jpg');
    _logo = bytes.buffer.asUint8List();
    _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      reverse('?????? ??????????'),
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: const pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                      //color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: const pw.TextStyle(
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text(_formatDate(DateTime.now())),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 144,
                    child: pw.Image(
                      pw.MemoryImage(_logo),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Page ${context.pageNumber}/${context.pagesCount}',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: font,
        bold: font,
        italic: font,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape!),
      ),
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.blueGrey800,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(_formatCurrency(_total)),
                    pw.Text(reverse('?????? ????"??:')),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${(0.17 * 100).toStringAsFixed(1)}%'),
                    pw.Text(reverse('????"??:')),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(_formatCurrency(_total * 1.17)),
                      pw.Text(reverse('????"??:')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Container();
  }

  pw.Widget _contentTable(pw.Context context) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        children: products.map((e) => e.printWidget(context, font)).toList(),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  initializeDateFormatting('iw_IL');
  final format = DateFormat.yMd('iw_IL');
  return format.format(date);
}

String _formatCurrency(double amount) {
  return '???${amount.toStringAsFixed(2)}';
}
