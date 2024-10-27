import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:system_reports_app/ui/activitiesReportModule/activities_report_view_model.dart';
import 'package:toastification/toastification.dart';
import 'package:image/image.dart' as img;

class ActivityReportsScreen extends StatelessWidget {
  static const route = '/ActivityReportScreen';

  const ActivityReportsScreen({super.key});

  Future<File> _getSignatureFile(SignatureController controller) async {
    final imageBytes = await controller.toPngBytes();
    if (imageBytes != null) {
      final image = img.decodeImage(imageBytes)!;
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/signature.png');
      await file.writeAsBytes(img.encodePng(image));
      return file;
    }
    throw Exception('Failed to convert signature to image file');
  }

  Future<void> _selectDate(
      BuildContext context, ActivitiesReportViewModel vm) async {
    final DateTime selectedDate;

    if (vm.dateController.text.isEmpty) {
      selectedDate = DateTime.now();
    } else {
      selectedDate = vm.stringToDateTime(vm.dateController.text);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    // Actualiza la fecha seleccionada
    if (picked != null && picked != selectedDate) {
      vm.dateController.text = vm.dateTimeToString(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ActivitiesReportViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Report')),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              controller: vm.clientController,
              decoration: const InputDecoration(
                  labelText: 'Client', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: vm.siteClientController,
              decoration: const InputDecoration(
                  labelText: 'Client site', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: vm.cityController,
              decoration: const InputDecoration(
                  labelText: 'City', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: vm.dateController,
              decoration: const InputDecoration(
                  labelText: 'Date', border: OutlineInputBorder()),
              onTap: () => _selectDate(context, vm),
              readOnly: true,
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: vm.specialistController,
              decoration: const InputDecoration(
                  labelText: 'Specialist', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: vm.serviceController,
              decoration: const InputDecoration(
                  labelText: 'Service', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: vm.objetiveController,
              decoration: const InputDecoration(
                  labelText: 'Objetive', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12.0),
            Signature(
              controller: vm.signatureClientController,
              height: 150,
            ),
            const SizedBox(height: 8.0),
            Text('Firma Cliente',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12.0),
            Signature(
              controller: vm.signatureFseSEController,
              height: 150,
            ),
            const SizedBox(height: 8.0),
            Text('Firma FSE', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12.0),
            ElevatedButton(
                onPressed: () async {
                  final signatureClient =
                      await _getSignatureFile(vm.signatureClientController);
                  final signatureFse =
                      await _getSignatureFile(vm.signatureFseSEController);

                  var response =
                      await vm.generatePDF(signatureClient, signatureFse);
                  if (response) {
                    vm.clearControllers();
                    Navigator.pop(context);
                  } else {
                    toastification.show(
                        context: context,
                        title: const Text('Error al subir el archivo'),
                        autoCloseDuration: const Duration(seconds: 5),
                        type: ToastificationType.error);
                  }
                },
                child: const Text('Enviar Reporte'))
          ]))),
    );
  }
}
