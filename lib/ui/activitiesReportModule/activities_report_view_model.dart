import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:signature/signature.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';
import 'package:system_reports_app/ui/appModule/assets.dart';
import 'package:system_reports_app/ui/expensesReportModule/mobile_image_picker.dart';
import 'package:system_reports_app/ui/expensesReportModule/pdf_generator.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:system_reports_app/utils/constants.dart';

class ActivitiesReportViewModel extends ChangeNotifier {
  final firebaseDatabase = FirebaseDatabase();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController siteClientController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController specialistController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController objetiveController = TextEditingController();
  final SignatureController signatureClientController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final SignatureController signatureFseSEController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  String dateTimeToString(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}';
  }

  DateTime stringToDateTime(String dateString) {
    // Dividir el String en partes
    final parts = dateString.split('-');
    if (parts.length != 3) {
      throw const FormatException(
          "El formato de la fecha no es válido. Debe ser 'yyyy-MM-dd'.");
    }

    // Convertir las partes a enteros
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    // Crear y retornar un objeto DateTime
    return DateTime(year, month, day);
  }

  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  Future<bool> generatePDF(File signatureClient, File signatureFSE) async {
    final PdfGenerator pdfGenerator = PdfGenerator();
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    final logo = await rootBundle.load(Assets.imgSilbec);
    final imageBytes = logo.buffer.asUint8List();
    final signatureUintClient = await fileToUint8List(signatureClient);
    final signatureUintFSE = await fileToUint8List(signatureFSE);

    // Primera página
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Row(children: [
              pw.Expanded(child: pw.Container()),
              pw.Image(pw.MemoryImage(imageBytes), width: 100, height: 60)
            ]),
            pw.SizedBox(height: Dimens.commonPaddingDefault),
            pw.Text('Datos Generales del Reporte',
                style: pw.Theme.of(context).header3),
            pw.Table(children: [
              pdfGenerator.buildTableRow(
                  'Cliente:', clientController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Sitio del cliente:',
                  siteClientController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'País:', cityController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Fecha:', dateController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Especialista:',
                  specialistController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Servicio:', serviceController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Objetivo:', objetiveController.text.toString().trim(), ttf)
            ]),
            pw.SizedBox(height: 10),
            pw.Image(pw.MemoryImage(signatureUintClient),
                width: 150, height: 100),
            pw.SizedBox(height: 10),
            pw.Image(pw.MemoryImage(signatureUintFSE), width: 150, height: 100),
          ]);
        },
      ),
    );

    return generateFile(pdf);
  }

  Future<bool> generateFile(pw.Document pdf) async {
  final memory = await getInternalStoragePath();
    final year = stringToDateTime(dateController.text).year;
    //final week = getWeekNumber(stringToDateTime(dateController.text));
    final nameFile = 'ActivitiesReport_${year}_${clientController.text}';

    final file = File('$memory/$nameFile');
    await file.writeAsBytes(await pdf.save());
    String response =
        await uploadFile(file, 'activities_reports/${file.path.split('/').last}.pdf');
    saveInFirestore(response);
    if (response.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> uploadFile(File file, route) async {
    String urlDownload = '';
    try {
      final storageRef = FirebaseStorage.instance.ref().child(route);
      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Proceso de subida de imagen: ${progress * 100}%');
      });

      await uploadTask.whenComplete(() async {
        final downloadURL = await storageRef.getDownloadURL();
        print('Archivo subido! URL de descarga: $downloadURL');
        urlDownload = downloadURL;
      });
    } catch (e) {
      print('Error al subir archivo: $e');
    }
    return urlDownload;
  }

  Future<bool> saveInFirestore(String downloadURL) {
    final taskEntity = TaskEntity(
        DateTime.now().millisecondsSinceEpoch,
        clientController.text,
        downloadURL,
        FirebaseAuth.instance.currentUser!.uid,
        false,
        image: '');
    return firebaseDatabase.createTask(Constants.COLLECTION_TASKS, taskEntity);
  }

  void clearControllers() {
    clientController.clear();
    siteClientController.clear();
    cityController.clear();
    dateController.clear();
    specialistController.clear();
    serviceController.clear();
    objetiveController.clear();
    signatureClientController.clear();
    signatureFseSEController.clear();
  }
}
