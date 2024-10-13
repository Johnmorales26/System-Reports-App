import 'package:flutter/material.dart';
import 'package:system_reports_app/data/local/task_entity.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/ui/homeModule/widgets/reports_view_model.dart';
import 'package:system_reports_app/ui/widgets/item_task.dart';

class ItemUser extends StatefulWidget {
  final UserDatabase user;
  final ReportsInnerViewModel vm;

  const ItemUser({super.key, required this.user, required this.vm});

  @override
  // ignore: library_private_types_in_public_api
  _ItemUserState createState() => _ItemUserState();
}

class _ItemUserState extends State<ItemUser> {
  bool _isExpanded =
      false; // Variable para controlar la visibilidad del listado

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                    child: Image.network(widget.user.image,
                        width: 50, height: 50, fit: BoxFit.cover)),
                Text(widget.user.name),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded =
                          !_isExpanded; // Cambia el estado de expansión
                    });
                  },
                ),
              ],
            ),
            if (_isExpanded) // Muestra el listado solo si _isExpanded es true
              FutureBuilder(
                future: widget.vm.fetchTasksByUidUser(widget.user.uid!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Muestra un indicador de carga
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                          'Error: ${snapshot.error}'), // Muestra un mensaje de error
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                          'No tasks found for this user.'), // Muestra mensaje si no hay datos
                    );
                  }

                  final tasks = snapshot.data!.docs.map((doc) {
                    return TaskEntity.fromJson(doc.data());
                  }).toList();

                  return ListView.builder(
                    shrinkWrap:
                        true, // Esto permite que la ListView tome solo el espacio necesario
                    physics:
                        const NeverScrollableScrollPhysics(), // Desactiva el desplazamiento
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        child: ItemTask(taskEntity: task),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
