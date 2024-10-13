import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:system_reports_app/data/models/data_entry.dart';
import 'package:system_reports_app/utils/constants.dart';

class ReportAdminViewModel extends ChangeNotifier {
  Future<bool> uploadData(DataEntry dataEntry) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection(Constants.COLLECTION_PENDING_TASK).add(dataEntry.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
