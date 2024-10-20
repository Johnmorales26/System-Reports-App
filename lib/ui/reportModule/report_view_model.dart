import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:signature/signature.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/data/models/data_entry.dart';
import 'package:system_reports_app/ui/expensesReportModule/pdf_generator.dart';
import 'package:system_reports_app/ui/reportModule/models/customer_data.dart';
import 'package:system_reports_app/ui/reportModule/models/trip_data.dart';
import 'package:system_reports_app/ui/reportModule/models/work_schedule.dart';
import 'package:system_reports_app/ui/style/dimens.dart';
import 'package:system_reports_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'web_image_picker.dart' if (dart.library.io) 'mobile_image_picker.dart';
import '../../data/network/firebase_database.dart';
import '../appModule/assets.dart';

class ReportViewModel extends ChangeNotifier {
  final firebaseDatabase = FirebaseDatabase();

  final customerData = CustomerData(
    referenceNumberController: TextEditingController(),
    clientNameController: TextEditingController(),
    managerNameController: TextEditingController(),
    ubicationController: TextEditingController(),
    statusController: TextEditingController(),
    activityController: TextEditingController(),
    observationsController: TextEditingController(),
  );
  final tripOneData = TripData(
    recordController: TextEditingController(),
    registerDateController: TextEditingController(),
    startScheduleController: TextEditingController(),
    finalScheduleController: TextEditingController(),
    totalHoursController: TextEditingController(),
  );

  final tripTwoData = TripData(
    recordController: TextEditingController(),
    registerDateController: TextEditingController(),
    startScheduleController: TextEditingController(),
    finalScheduleController: TextEditingController(),
    totalHoursController: TextEditingController(),
  );
  final workScheduleOne = WorkSchedule(
      registerDate: TextEditingController(),
      startSchedule: TextEditingController(),
      lunchStart: TextEditingController(),
      lunchEnd: TextEditingController(),
      endSchedule: TextEditingController(),
      travelHours: TextEditingController());
  final workScheduleTwo = WorkSchedule(
      registerDate: TextEditingController(),
      startSchedule: TextEditingController(),
      lunchStart: TextEditingController(),
      lunchEnd: TextEditingController(),
      endSchedule: TextEditingController(),
      travelHours: TextEditingController());
  final workScheduleThree = WorkSchedule(
      registerDate: TextEditingController(),
      startSchedule: TextEditingController(),
      lunchStart: TextEditingController(),
      lunchEnd: TextEditingController(),
      endSchedule: TextEditingController(),
      travelHours: TextEditingController());
  final TextEditingController urlController = TextEditingController();
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  double _uploadProgress = 0.0;

  double get uploadProgress => _uploadProgress;

  void updateSelectedImage(String url) {
    urlController.text = url;
    notifyListeners();
  }

  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  Future<bool> generatePDF(File signature) async {
    final PdfGenerator pdfGenerator = PdfGenerator();
    final pdf = pw.Document();

    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    final logo = await rootBundle.load(Assets.imgSilbec);
    final imageBytes = logo.buffer.asUint8List();
    final signatureUint = await fileToUint8List(signature);

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
                  'Número de referencia:',
                  customerData.referenceNumberController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Nombre FSE:',
                  customerData.clientNameController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Cliente:',
                  customerData.managerNameController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow('Gerente del Cliente:',
                  customerData.ubicationController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Ubicación:',
                  customerData.statusController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Actividad realizada:',
                  customerData.activityController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Observaciones:',
                  customerData.observationsController.text.toString().trim(),
                  ttf)
            ]),
            pw.Text('Horarios de Trabajo', style: pw.Theme.of(context).header3),
            pw.Divider(),

            // Primer horario
            pw.Text('Primer Horario',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Table(children: [
              pdfGenerator.buildTableRow('Fecha de Registro',
                  workScheduleOne.registerDate.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Inicio de Horario',
                  workScheduleOne.startSchedule.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Inicio de Almuerzo',
                  workScheduleOne.lunchStart.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Fin de Almuerzo',
                  workScheduleOne.lunchEnd.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Fin de Horario',
                  workScheduleOne.endSchedule.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Horas de Viaje',
                  workScheduleOne.travelHours.text.toString().trim(), ttf)
            ]),
            pw.SizedBox(height: 20),

            // Segunda página
            pw.Text('Segundo Horario',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Table(children: [
              pdfGenerator.buildTableRow('Fecha de Registro',
                  workScheduleTwo.registerDate.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Inicio de Horario',
                  workScheduleTwo.startSchedule.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Inicio de Almuerzo',
                  workScheduleTwo.lunchStart.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Fin de Almuerzo',
                  workScheduleTwo.lunchEnd.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Fin de Horario',
                  workScheduleTwo.endSchedule.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Horas de Viaje',
                  workScheduleTwo.travelHours.text.toString().trim(), ttf)
            ]),
          ]);
        },
      ),
    );

    // Segunda página (con los datos de la forma)
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Text('Datos del Viaje', style: pw.Theme.of(context).header3),
            pw.Table(children: [
              pdfGenerator.buildTableRow('Registro',
                  tripOneData.recordController.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow(
                  'Fecha de Registro',
                  tripOneData.registerDateController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Inicio de Horario',
                  tripOneData.startScheduleController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow(
                  'Fin de Horario',
                  tripOneData.finalScheduleController.text.toString().trim(),
                  ttf),
              pdfGenerator.buildTableRow('Horas de Viaje',
                  tripOneData.totalHoursController.text.toString().trim(), ttf)
            ]),

            pw.Divider(),

            // Agregar la forma de horarios
            pw.Text('Tercer Horario',
                style: pw.TextStyle(font: ttf, fontSize: 14)),
            pw.Table(children: [
              pdfGenerator.buildTableRow('Fecha de Registro',
                  workScheduleThree.registerDate.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Inicio de Horario',
                  workScheduleThree.startSchedule.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Inicio de Almuerzo',
                  workScheduleThree.lunchStart.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Fin de Almuerzo',
                  workScheduleThree.lunchEnd.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Fin de Horario',
                  workScheduleThree.endSchedule.text.toString().trim(), ttf),
              pdfGenerator.buildTableRow('Horas de Viaje',
                  workScheduleThree.travelHours.text.toString().trim(), ttf)
            ]),

            // Página dedicada para la firma
            pw.SizedBox(height: 20),
            pw.Text('Firma', style: pw.Theme.of(context).header3),
            pw.SizedBox(height: 10),
            pw.Image(pw.MemoryImage(signatureUint), width: 150, height: 100),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 8),
              child: pw.Divider(),
            ),
          ]);
        },
      ),
    );

    return generateFile(pdf, customerData.referenceNumberController.text, this);
  }

  Future<bool> saveInFirestore(String downloadURL) {
    final taskEntity = TaskEntity(
        DateTime.now().millisecondsSinceEpoch,
        customerData.referenceNumberController.text,
        downloadURL,
        FirebaseAuth.instance.currentUser!.uid,
        false,
        image: urlController.text);
    return firebaseDatabase.createTask(Constants.COLLECTION_TASKS, taskEntity);
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir la URL: $url';
    }
  }

  void calculateTimeDifference(TimeOfDay? startTime, TimeOfDay? endTime,
      TextEditingController controller) {
    if (startTime != null && endTime != null) {
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;

      // Si la hora de fin es menor que la hora de inicio, asumimos que es al día siguiente
      final minutesDifference = endMinutes >= startMinutes
          ? endMinutes - startMinutes
          : (1440 - startMinutes) + endMinutes; // 1440 minutos en un día

      controller.text = '$minutesDifference min';
      notifyListeners();
    }
  }

  bool validateControllers() {
    if (customerData.referenceNumberController.text.trim().isEmpty ||
        customerData.clientNameController.text.trim().isEmpty ||
        customerData.managerNameController.text.trim().isEmpty ||
        customerData.ubicationController.text.trim().isEmpty ||
        customerData.statusController.text.trim().isEmpty ||
        customerData.activityController.text.trim().isEmpty ||
        customerData.observationsController.text.trim().isEmpty ||
        urlController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  void clearControllers() {
    customerData.referenceNumberController.clear();
    customerData.clientNameController.clear();
    customerData.managerNameController.clear();
    customerData.ubicationController.clear();
    customerData.statusController.clear();
    customerData.activityController.clear();
    customerData.observationsController.clear();
    urlController.clear();
  }

  void initData(DataEntry dataEntry) {
    customerData.referenceNumberController.text = dataEntry.referenceNumber;
    customerData.clientNameController.text = dataEntry.client;
    customerData.managerNameController.text = dataEntry.customManager;
    customerData.ubicationController.text = dataEntry.location;
    customerData.statusController.text = dataEntry.fseName;
    customerData.activityController.text = dataEntry.activityPerformed;
    customerData.observationsController.text = dataEntry.observations;
  }

  void deletePendingTask(DataEntry dataEntry) async {
    Map<String, dynamic> dataMap = dataEntry.toJson();
    CollectionReference collection = FirebaseFirestore.instance.collection(Constants.COLLECTION_PENDING_TASK);
    Query query = collection;
    dataMap.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });

    QuerySnapshot querySnapshot = await query.get();
    if(querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }
  }
}
