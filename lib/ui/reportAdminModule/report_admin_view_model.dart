import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/data/models/data_entry.dart';
import 'package:system_reports_app/utils/constants.dart';

class ReportAdminViewModel extends ChangeNotifier {
  final TextEditingController referenceNumberController =
      TextEditingController();
  final TextEditingController clientController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController customManagerController = TextEditingController();
  final TextEditingController activityPerformedController =
      TextEditingController();
  final TextEditingController observationsController = TextEditingController();
  final TextEditingController fseNameController = TextEditingController();

  Future<bool> uploadData() async {
    final dataEntry = DataEntry(
      referenceNumber: referenceNumberController.text,
      client: clientController.text,
      location: locationController.text,
      fseName: fseNameController.text,
      customManager: customManagerController.text,
      activityPerformed: activityPerformedController.text,
      observations: observationsController.text,
    );
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore
          .collection(Constants.COLLECTION_PENDING_TASK)
          .add(dataEntry.toJson());
      _clearForm();
      return true;
    } catch (e) {
      return false;
    }
  }

Future<List<UserDatabase>> fetchAllUsers() async {
  final logger = Logger();
  
  try {
    logger.i('Fetching all users from Firestore...');
    
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(Constants.COLLECTION_USERS);
    QuerySnapshot querySnapshot = await collectionRef.get();
    
    logger.i('QuerySnapshot received: ${querySnapshot.docs.length} documents found.');
    
    List<UserDatabase> users = querySnapshot.docs.map((doc) {
      logger.d('Parsing user from document ID: ${doc.id}');
      return UserDatabase.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    
    logger.i('Successfully fetched ${users.length} users.');
    return users;
  } catch (e) {
    logger.e('Error fetching users: $e');
    return [];
  }
}


  void updateFSEController(String fseName) {
    fseNameController.text = fseName;
  }

  void _clearForm() {
    referenceNumberController.clear();
    clientController.clear();
    locationController.clear();
    fseNameController.clear();
    customManagerController.clear();
    activityPerformedController.clear();
    observationsController.clear();
  }
}
