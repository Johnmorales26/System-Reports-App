import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/homeModule/widgets/reports_inner_repository.dart';

class ReportsInnerViewModel extends ChangeNotifier {
  final ReportsInnerRepository repository = ReportsInnerRepository();

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return repository.fetchAllUsers();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchTasksByUidUser(
      String uidUser) {
    return repository.fetchTasksByUidUser(uidUser);
  }
}
