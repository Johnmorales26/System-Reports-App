import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/data/local/user_database.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data Entry Form'),
        ),
        body: SingleChildScrollView(child: FutureBuilder(
            future: vm.fetchAllUsers(),
            builder: (BuildContext context,
                AsyncSnapshot<List<UserDatabase>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                final users = snapshot.data!;
                if (users.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: vm.referenceNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Número de referencia',
                            border:
                                OutlineInputBorder(), // Establece el borde a Outlined
                          ),
                        ),
                        const SizedBox(height: 10), // Espacio entre los campos
                        TextField(
                          controller: vm.clientController,
                          decoration: const InputDecoration(
                            labelText: 'Cliente',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vm.locationController,
                          decoration: const InputDecoration(
                            labelText: 'Locación',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            _showAlertDialog(context, users, vm);
                          },
                          child: AbsorbPointer(
                              child: TextField(
                            controller: vm.fseNameController,
                            decoration: const InputDecoration(
                              labelText: 'Nombre FSE',
                              border: OutlineInputBorder(),
                            ),
                          )),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vm.customManagerController,
                          decoration: const InputDecoration(
                            labelText: 'Custom Manager',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vm.activityPerformedController,
                          decoration: const InputDecoration(
                            labelText: 'Activity Performed',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: vm.observationsController,
                          decoration: const InputDecoration(
                            labelText: 'Observaciones',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            final response = await vm.uploadData();
                            if (response) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Datos enviados con éxito')),
                              );

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Error al enviar los datos')),
                              );
                            }
                          },
                          child: const Text('Enviar'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            })));
  }

  void _showAlertDialog(BuildContext context, List<UserDatabase> users, ReportAdminViewModel vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona un usuario'),
          content: SizedBox(
            width: double
                .maxFinite, // Asegura que el contenido use el máximo ancho
            height:
                300, // Establece una altura fija para que no se extienda demasiado
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final currentUser = users[index];
                return ListTile(
                  title: Text(currentUser.name),
                  subtitle: Text(currentUser.fseName),
                  leading: currentUser.image.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                          currentUser.image,
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ))
                      : Container(),
                  onTap: () {
                    vm.updateFSEController(currentUser.fseName);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
