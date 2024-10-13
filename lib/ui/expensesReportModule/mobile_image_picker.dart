import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:system_reports_app/ui/expensesReportModule/expenses_report_view_model.dart';

Future<String> getImageFromGallery(
    BuildContext context, ExpensesReportViewModel provider) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    var file = File(pickedFile.path);
    return await uploadFile(file, 'images/${file.uri.pathSegments.last}');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se ha seleccionado ninguna imagen')),
    );
    return '';
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

Future<String> getInternalStoragePath() async {
  final Directory directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<bool> generateFile(pw.Document pdf, String reference, ExpensesReportViewModel reportViewModel) async {
  final memory = await getInternalStoragePath();
  final file = File('$memory/$reference');
  await file.writeAsBytes(await pdf.save());
  String response = await uploadFile(file, 'pdfs/${file.path.split('/').last}.pdf');
  reportViewModel.saveInFirestore(response);
  if (response.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
