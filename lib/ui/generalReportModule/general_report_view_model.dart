import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:signature/signature.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/ui/expensesReportModule/mobile_image_picker.dart';
import 'package:system_reports_app/ui/expensesReportModule/pdf_generator.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

import '../../data/network/firebase_database.dart';
import '../appModule/assets.dart';

class GeneralReportViewModel extends ChangeNotifier {
  final firebaseDatabase = FirebaseDatabase();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool validateControllers() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        urlController.text.isNotEmpty &&
        signatureController.points.isNotEmpty;
  }

  void uploadDataOnFirebase() {
    Logger logger = Logger();
    if (validateControllers()) {
    } else {
      logger.e("No se han podido validar los controllers");
    }
  }

  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  Future<bool> generatePDF(File signaturem, String collection) async {
    final PdfGenerator pdfGenerator = PdfGenerator();
    final pdf = pw.Document();

    // Carga de la fuente
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    // Carga del logo
    final logo = await rootBundle.load(Assets.imgSilbec);
    final imageBytes = logo.buffer.asUint8List();

    // Convertir la firma a Uint8List
    final signatureUint = await fileToUint8List(signaturem);

    // Primera página
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Expanded(child: pw.Container()),
                  pw.Image(pw.MemoryImage(imageBytes), width: 100, height: 60),
                ],
              ),
              pw.SizedBox(height: Dimens.commonPaddingDefault),
              pw.Text(
                'Datos del Reporte',
                style: pw.Theme.of(context).header3,
              ),
              pw.Table(
                children: [
                  pdfGenerator.buildTableRow(
                    'Titutlo:',
                    titleController.text.trim(),
                    ttf,
                  ),
                  pdfGenerator.buildTableRow(
                    'Descripción:',
                    descriptionController.text.trim(),
                    ttf,
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Image(pw.MemoryImage(signatureUint), width: 150, height: 100),
            ],
          );
        },
      ),
    );

    // Llama a tu función para generar el archivo PDF
    return generateFileReportGeneral(pdf, titleController.text.trim(), this, collection);
  }

  Future<bool> saveInFirestore(String downloadURL, String collection) {
    final taskEntity = TaskEntity(
        DateTime.now().millisecondsSinceEpoch,
        titleController.text.trim(),
        downloadURL,
        FirebaseAuth.instance.currentUser!.uid,
        false,
        image: urlController.text);
    return firebaseDatabase.createTask(collection, taskEntity);
  }

  void clearControllers() {
    titleController.clear();
    descriptionController.clear();
    urlController.clear();
    signatureController.clear();
    notifyListeners();
  }
}
