import 'package:firebase_auth/firebase_auth.dart';

import 'web_image_picker.dart' if (dart.library.io) 'mobile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:system_reports_app/data/local/expense_entity.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';
import 'package:system_reports_app/ui/appModule/assets.dart';
import 'package:system_reports_app/ui/expensesReportModule/pdf_generator.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class ExpensesReportViewModel extends ChangeNotifier {
  final PdfGenerator pdfGenerator = PdfGenerator();
  final firebaseDatabase = FirebaseDatabase();

  var currentView = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController weekController = TextEditingController();
  final TextEditingController typeServiceController = TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController expenseTypeController = TextEditingController();
  final TextEditingController billController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  var typeServiceValue = 0;
  var isBill = false;
  List<ExpenseEntity> expenses = [];

  void changeScreen(int screen) {
    currentView = screen;
    notifyListeners();
  }

  void nextScreen() {
    if (currentView < 2) {
      currentView++;
    }
    notifyListeners();
  }

  void previousScreen() {
    if (currentView > 0) {
      currentView--;
    }
    notifyListeners();
  }

  void changeState(bool state) {
    isBill = state;
    notifyListeners();
  }

  bool validateControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool addExpense() {
    List<TextEditingController> controllers = [
      idController,
      expenseTypeController,
      billController,
      amountController
    ];
    if (validateControllers(controllers)) {
      ExpenseEntity expense = ExpenseEntity(
          int.parse(idController.text.toString().trim()),
          expenseTypeController.text.toString().trim(),
          isBill,
          billController.text.toString().trim(),
          double.parse(amountController.text.toString().trim()));
      expenses.add(expense);
      clearFields();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void clearFields() {
    idController.clear();
    expenseTypeController.clear();
    billController.clear();
    amountController.clear();
    isBill = false;
    notifyListeners();
  }

  Future<bool> generateDocument() async {
    final pdf = pdfGenerator.createDocument();
    final ttf = await pdfGenerator.getFontData();

    final logo = await rootBundle.load(Assets.imgSilbec);
    final imageBytes = logo.buffer.asUint8List();

    // Obtener el valor de Viáticos
    double viaticos =
        (double.tryParse(daysController.text) ?? 0) * typeServiceValue;

// Obtener el valor de Otros gastos
    double otrosGastos = expenses.fold(
      0.0,
      (prev, expense) => prev + expense.amount,
    );

// Calcular el Total (Viáticos + Otros gastos - typeServiceValue)
    double total = (viaticos + otrosGastos) - int.parse(advanceController.text);

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Row(children: [
              pw.Expanded(child: pw.Container()),
              pw.Image(pw.MemoryImage(imageBytes), width: 150, height: 100)
            ]),
            pw.SizedBox(height: Dimens.commonPaddingDefault),
            pw.Container(
              width: double.infinity,
              color: PdfColors
                  .blueGrey, // Fondo de color para el nombre de la columna
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                'Comprobación de Viaticos',
                style: pw.TextStyle(
                  font: ttf,
                  color: PdfColors.white, // Color del texto en la columna
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Table(children: [
              pdfGenerator.buildTableRow(
                  'Nombre', nameController.text.toString(), ttf),
              pdfGenerator.buildTableRow(
                  'Días de Servicio', daysController.text.toString(), ttf),
              pdfGenerator.buildTableRow(
                  'Semana', weekController.text.toString(), ttf),
              pdfGenerator.buildTableRow('Tipo de Servicio',
                  typeServiceController.text.toString(), ttf),
              pdfGenerator.buildTableRow(
                  'Cliente', clientController.text.toString(), ttf),
              pdfGenerator.buildTableRow(
                  'Anticipo', advanceController.text.toString(), ttf),
              pdfGenerator.buildTableRow(
                  'No. Referencia', referenceController.text.toString(), ttf)
            ]),
            pw.SizedBox(height: Dimens.commonPaddingDefault),
            pw.Row(children: [
              pw.Container(
                color: PdfColors.blueGrey,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Item',
                  style: pw.TextStyle(
                    font: ttf,
                    color:
                        PdfColors.white, // Color del texto en la celda de valor
                  ),
                ),
              ),
              pw.Expanded(
                  child: pw.Container(
                color: PdfColors.blueGrey,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Tipo de Gasto',
                  style: pw.TextStyle(
                    font: ttf,
                    color:
                        PdfColors.white, // Color del texto en la celda de valor
                  ),
                ),
              )),
              pw.Expanded(
                  child: pw.Container(
                color: PdfColors.blueGrey,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Facturado',
                  style: pw.TextStyle(
                    font: ttf,
                    color:
                        PdfColors.white, // Color del texto en la celda de valor
                  ),
                ),
              )),
              pw.Expanded(
                  child: pw.Container(
                color: PdfColors.blueGrey,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Factura',
                  style: pw.TextStyle(
                    font: ttf,
                    color:
                        PdfColors.white, // Color del texto en la celda de valor
                  ),
                ),
              )),
              pw.Expanded(
                  child: pw.Container(
                color: PdfColors.blueGrey,
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  'Monto Total',
                  style: pw.TextStyle(
                    font: ttf,
                    color:
                        PdfColors.white, // Color del texto en la celda de valor
                  ),
                ),
              ))
            ]),
            pw.ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];
                  return pw.Row(children: [
                    pw.Container(
                      color: PdfColors
                          .white, // Fondo blanco para la celda de valor
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        expense.id.toString(),
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors
                              .black, // Color del texto en la celda de valor
                        ),
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Container(
                      color: PdfColors
                          .white, // Fondo blanco para la celda de valor
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        expense.typeExpense,
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors
                              .black, // Color del texto en la celda de valor
                        ),
                      ),
                    )),
                    pw.Expanded(
                      child: pw.Container(
                        color: PdfColors
                            .white, // Fondo blanco para la celda de valor
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          (expense.isBill == true)
                              ? 'Sí'
                              : 'No', // Usando tilde en "Sí" si es una respuesta afirmativa
                          style: pw.TextStyle(
                            font: ttf,
                            color: PdfColors
                                .black, // Color del texto en la celda de valor
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                        child: pw.Container(
                      color: PdfColors
                          .white, // Fondo blanco para la celda de valor
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        expense.bill,
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors
                              .black, // Color del texto en la celda de valor
                        ),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Container(
                      color: PdfColors
                          .white, // Fondo blanco para la celda de valor
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        '\$ ${expense.amount}',
                        style: pw.TextStyle(
                          font: ttf,
                          color: PdfColors
                              .black, // Color del texto en la celda de valor
                        ),
                      ),
                    ))
                  ]);
                }),
            pw.SizedBox(height: Dimens.commonPaddingDefault),
            pw.Table(children: [
              pdfGenerator.buildTableRow(
                'Facturado',
                '\$${expenses.where((expense) => expense.isBill).fold(0.0, (prev, expense) => prev + expense.amount).toStringAsFixed(2)}',
                ttf,
              ),
              pdfGenerator.buildTableRow(
                'Sin Factura',
                '\$${expenses.where((expense) => !expense.isBill).fold(0.0, (prev, expense) => prev + expense.amount).toStringAsFixed(2)}',
                ttf,
              ),
              pdfGenerator.buildTableRow(
                'Total Reportado',
                '\$${expenses.map((expense) => expense.amount).reduce((prev, element) => prev + element).toStringAsFixed(2)}',
                ttf,
              ),
              pdfGenerator.buildTableRow(
                'Anticipo',
                '\$${advanceController.text}',
                ttf,
              ),
              pdfGenerator.buildTableRow(
                'Viaticos',
                '\$${viaticos.toStringAsFixed(2)}',
                ttf,
              ),
              pdfGenerator.buildTableRow(
                'Otros gastos',
                '\$${otrosGastos.toStringAsFixed(2)}',
                ttf,
              ),
              pdfGenerator.buildTableRow(
                'No facturado',
                '\$${(double.tryParse(daysController.text) ?? 0) * typeServiceValue}',
                ttf,
              ),
              pdfGenerator.buildTableRow(
                'Total',
                '\$${total.toStringAsFixed(2)}',
                ttf,
              ),
            ])
          ]);
        }));
    return await generateFile(pdf, referenceController.text, this);
  }

  Future<bool> saveInFirestore(String downloadURL) {
    final taskEntity = TaskEntity(DateTime.now().millisecondsSinceEpoch,
        referenceController.text, downloadURL, FirebaseAuth.instance.currentUser!.uid, false,
        image: '');
    return firebaseDatabase.createTask(taskEntity);
  }

  void itemDelete(int index) {
    expenses.removeAt(index);
    notifyListeners();
  }
}
