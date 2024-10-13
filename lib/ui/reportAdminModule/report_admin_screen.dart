import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/data/models/data_entry.dart';
import 'package:system_reports_app/ui/reportAdminModule/report_admin_view_model.dart';

class ReportAdminScreen extends StatelessWidget {
  const ReportAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReportAdminViewModel>(context);

    return Scaffold(body: _DataEntryFormState(vm: vm));
  }
}

class _DataEntryFormState extends StatelessWidget {
  final ReportAdminViewModel vm;

  const _DataEntryFormState({required this.vm});

  @override
  Widget build(BuildContext context) {
    final TextEditingController referenceNumberController =
        TextEditingController();
    final TextEditingController clientController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController fseNameController = TextEditingController();
    final TextEditingController customManagerController =
        TextEditingController();
    final TextEditingController activityPerformedController =
        TextEditingController();
    final TextEditingController observationsController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Entry Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: referenceNumberController,
              decoration: const InputDecoration(
                labelText: 'Número de referencia',
                border: OutlineInputBorder(), // Establece el borde a Outlined
              ),
            ),
            const SizedBox(height: 10), // Espacio entre los campos
            TextField(
              controller: clientController,
              decoration: const InputDecoration(
                labelText: 'Cliente',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Locación',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fseNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre FSE',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: customManagerController,
              decoration: const InputDecoration(
                labelText: 'Custom Manager',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: activityPerformedController,
              decoration: const InputDecoration(
                labelText: 'Activity Performed',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: observationsController,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Aquí puedes manejar el envío de datos
                final dataEntry = DataEntry(
                  referenceNumber: referenceNumberController.text,
                  client: clientController.text,
                  location: locationController.text,
                  fseName: fseNameController.text,
                  customManager: customManagerController.text,
                  activityPerformed: activityPerformedController.text,
                  observations: observationsController.text,
                );
                final response = await vm.uploadData(dataEntry);
                if (response) {
                  referenceNumberController.clear();
                  clientController.clear();
                  locationController.clear();
                  fseNameController.clear();
                  customManagerController.clear();
                  activityPerformedController.clear();
                  observationsController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos enviados con éxito')),
                  );

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al enviar los datos')),
                  );
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
