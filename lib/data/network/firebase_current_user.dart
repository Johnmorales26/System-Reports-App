import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:system_reports_app/data/local/user_database.dart';
import 'package:system_reports_app/utils/constants.dart';

class FirebaseCurrentUser {
  UserDatabase? _userDatabase;
  static final FirebaseCurrentUser _instance = FirebaseCurrentUser._internal();

  factory FirebaseCurrentUser() {
    return _instance;
  }

  // Instancia de Logger para usar en los logs
  final logger = Logger();

  FirebaseCurrentUser._internal() {
    final user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
        _fetchCurrentUserByFirestore(user);
      } else {
        _userDatabase = null;
      }
  }

  void _fetchCurrentUserByFirestore(String uid) {
    final docRef = FirebaseFirestore.instance
        .collection(Constants.COLLECTION_USERS)
        .doc(uid);
    docRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {

        if (snapshot.data() != null) {
          _userDatabase = UserDatabase.fromJson(snapshot.data()!);
        } else {
          _userDatabase = null;
        }
      } else {
        _userDatabase = null;
      }
    }, onError: (error) {
      logger.e("Error fetching user data for UID: $uid", error);
    });
  }

  Future<void> updateDocumentById(String docId, Map<String, dynamic> updatedData) async {
    final docRef = FirebaseFirestore.instance
        .collection(Constants.COLLECTION_USERS)
        .doc(docId); // Usamos el docId pasado como argumento

    try {
      await docRef.update(updatedData);
      logger.i("Document with ID: $docId updated successfully.");
    } catch (e) {
      logger.e("Error updating document with ID: $docId", e);
    }
  }

  User? fetchCurrentUserByFirebase() {
    return FirebaseAuth.instance.currentUser;
  }

  UserDatabase? get currentUser => _userDatabase;
}
