import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:system_reports_app/ui/generalReportModule/general_report_view_model.dart';
import 'package:image/image.dart' as img;
import 'package:system_reports_app/utils/constants.dart';
import 'package:toastification/toastification.dart';

class GeneralReportScreen extends StatelessWidget {
  const GeneralReportScreen({super.key, required this.typeReport});

  static const route = "/GeneralReportScreen";
  final String typeReport;

  Future<File> _getSignatureFile(GeneralReportViewModel viewModel) async {
    final imageBytes = await viewModel.signatureController.toPngBytes();
    if (imageBytes != null) {
      final image = img.decodeImage(imageBytes)!;
      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/signature.png');
      await file.writeAsBytes(img.encodePng(image));
      return file;
    }
    throw Exception('Failed to convert signature to image file');
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<GeneralReportViewModel>(context);
    final logger = Logger();
    return Scaffold(
        appBar: AppBar(
          title: Text(typeReport == Constants.COLLECTION_COMPUTER
              ? "Reporte Computadora"
              : "Reporte Vehiculos"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                  "Complete el siguiente formulario para enviar un ticket."),
              const SizedBox(height: 16.0),
              TextField(
                controller: vm.titleController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del reporte',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  vm.titleController.text = text;
                  vm.validateControllers();
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: vm.descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Describe la falla reportada',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  vm.descriptionController.text = text;
                  vm.validateControllers();
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: vm.urlController,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Url de la Imagen',
                  border: OutlineInputBorder(),
                ),
                onChanged: (text) {
                  vm.urlController.text = text;
                  vm.validateControllers();
                },
              ),
              const SizedBox(height: 16.0),
              const Text("Agrega tu firma"),
              const SizedBox(height: 16.0),
              Signature(
                controller: vm.signatureController,
                height: 150,
              )
            ])),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                onPressed: () async {
                  final ImagePicker _picker = ImagePicker();
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    File file = File(image.path);

                    Reference ref = FirebaseStorage.instance.ref().child(
                        'uploads/${DateTime.now().millisecondsSinceEpoch}.png');

                    try {
                      await ref.putFile(file);
                      vm.urlController.text = await ref.getDownloadURL();
                      logger.d(
                          'Imagen subida con éxito: ${vm.urlController.text}');
                    } catch (e) {
                      logger.d('Error al subir la imagen: $e');
                    }
                  } else {
                    logger.d('No se seleccionó ninguna imagen.');
                  }
                },
                child: const Icon(Icons.image)),
            const SizedBox(width: 8.0),
            FloatingActionButton(
                onPressed: () async {
                  final signature = await _getSignatureFile(vm);
                  var response = await vm.generatePDF(signature, typeReport);
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
                child: const Icon(Icons.send))
          ],
        ));
  }
}
