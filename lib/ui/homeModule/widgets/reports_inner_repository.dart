import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';

class ReportsInnerRepository {
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase();

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return firebaseDatabase.fetchAllUsers();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchTasksByUidUser(
      String uidUser) {
    return firebaseDatabase.fetchTasksByUidUser(uidUser);
  }
}
