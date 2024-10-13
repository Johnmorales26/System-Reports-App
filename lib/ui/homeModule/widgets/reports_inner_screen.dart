import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/ui/homeModule/widgets/item_user.dart';
import 'package:system_reports_app/ui/homeModule/widgets/reports_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class ReportsInnerScreen extends StatelessWidget {
  const ReportsInnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReportsInnerViewModel>(context);
    return Padding(padding: const EdgeInsets.all(Dimens.commonPaddingMin), child: FutureBuilder(
        future: vm.fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras esperas los datos
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si ocurre un error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Muestra un mensaje si no hay datos
            return const Center(child: Text('No se encontraron usuarios.'));
          }
          final users = snapshot.data!.docs.map((doc) {
            return UserDatabase.fromJson(doc.data());
          }).toList();
          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ItemUser(user: user, vm: vm);
              });
        }));
  }
}

