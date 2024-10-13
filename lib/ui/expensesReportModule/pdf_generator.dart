import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  PdfGenerator._privateConstructor();

  static final PdfGenerator _instance = PdfGenerator._privateConstructor();

  factory PdfGenerator() {
    return _instance;
  }

  pw.Document createDocument() {
    return pw.Document();
  }

  Future<pw.Font> getFontData() async {
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  pw.TableRow buildTableRow(String label, String value, pw.Font ttf) {
    return pw.TableRow(
      children: [
        pw.Container(
          color:
              PdfColors.blueGrey, // Fondo de color para el nombre de la columna
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              font: ttf,
              color: PdfColors.white, // Color del texto en la columna
              fontWeight: pw.FontWeight.bold,
              fontSize: 10, // Tamaño de fuente reducido
            ),
          ),
        ),
        pw.Container(
          color: PdfColors.white, // Fondo blanco para la celda de valor
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              font: ttf,
              color: PdfColors.black, // Color del texto en la celda de valor
              fontSize: 10, // Tamaño de fuente reducido
            ),
          ),
        ),
      ],
    );
  }
}
