import 'dart:io';
import 'dart:typed_data';

class Utils {
  // Instancia única de Utils
  static final Utils instance = Utils._internal();

  // Constructor privado
  Utils._internal();

  // Método factory para obtener la instancia
  factory Utils() {
    return instance;
  }

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
}