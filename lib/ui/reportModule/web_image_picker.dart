import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/reportModule/report_view_model.dart';

Future<String> getImageFromGallery(BuildContext context, ReportViewModel provider) async {
  final Completer<String> completer = Completer<String>();

  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha seleccionado ninguna imagen')),
      );
      completer.complete('');
      return;
    }

    final file = files[0];
    final urlDownload = await uploadFile(file, 'images/${file.name}');
    completer.complete(urlDownload);
  });

  return completer.future;
}

Future<String> uploadFile(html.File file, route) async {
  try {
    final reader = html.FileReader();
    final completer = Completer<String>();

    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((e) async {
      final data = reader.result as Uint8List;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child(route);
      final uploadTask = storageRef.putData(data);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Proceso de subida de imagen: ${progress * 100}%');
      });

      await uploadTask.whenComplete(() async {
        final downloadURL = await storageRef.getDownloadURL();
        print('Archivo subido! URL de descarga: $downloadURL');
        completer.complete(downloadURL);
      });
    });

    return completer.future;
  } catch (e) {
    print('Error al subir archivo: $e');
    return '';
  }
}

Future<bool> generateFile(pw.Document pdf, String reference, ReportViewModel reportViewModel) async {
  final pdfBytes = await pdf.save();
  final blob = html.Blob([pdfBytes]);
  final file = html.File([blob], reference);
  String response = await uploadFile(file, 'pdfs/${file.name}.pdf');
  reportViewModel.saveInFirestore(response);
  if (response.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
