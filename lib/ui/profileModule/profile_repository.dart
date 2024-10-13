import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:system_reports_app/data/network/firebase_current_user.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';

class ProfileRepository {

  FirebaseCurrentUser auth = FirebaseCurrentUser();
  FirebaseDatabase db = FirebaseDatabase();

  User? fetchCurrentUser() {
    return auth.fetchCurrentUserByFirebase();
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile) {
    return db.uploadImageToFirebaseStorage(imageFile);
  }

  void updateNameProfile(String name) async {
    final user = auth.fetchCurrentUserByFirebase();
    if (user != null) {
      final userDb = await db.getUserById(user.uid);
      if (userDb != null) {
        userDb.name = name;
        auth.updateDocumentById(user.uid, userDb.toJson());
      }
    }
  }

  void updateImageProfile(String response) async {
    final user = auth.fetchCurrentUserByFirebase();
    if (user != null) {
      final userDb = await db.getUserById(user.uid);
      if (userDb != null) {
        userDb.image = response;
        auth.updateDocumentById(user.uid, userDb.toJson());
      }
    }
  }

}