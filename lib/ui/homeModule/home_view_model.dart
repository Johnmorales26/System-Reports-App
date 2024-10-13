import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/data/models/data_entry.dart';
import 'package:system_reports_app/data/network/firebase_current_user.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';

import '../../data/network/firebase_authentication.dart';

class HomeViewModel extends ChangeNotifier {
  final FirebaseAuthentication _auth = FirebaseAuthentication();
  final FirebaseCurrentUser currentUser = FirebaseCurrentUser();
  final FirebaseDatabase db = FirebaseDatabase();

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  Future<UserDatabase?> getCurrentUserByFirestore() {
    return Future.delayed(const Duration(milliseconds: 5000), () {
      return currentUser.currentUser;
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getAllTask() {
    return db.getTask();
  }

  Future<void> deleteTask(String taskId) async {
    return db.deleteTask(taskId);
  }

  Future<void> updateTaskStatus(String taskId, bool isChecked) async {
    await db.updateTaskStatus(taskId, isChecked);
  }

  void signOut() {
    _auth.signOut();
  }

  Future<bool> downloadFile(BuildContext context, String url,
      String selectedDirectory, String typeFile) {
    return db.downloadFile(context, url, selectedDirectory, typeFile);
  }

  Future<List<DataEntry>> fetchPendingTaskByUser(String fseName) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.fetchPendingTaskByUser(fseName);
    return snapshot.docs.map((doc) => DataEntry.fromJson(doc.data())).toList();
  }

  void updateIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }
}
