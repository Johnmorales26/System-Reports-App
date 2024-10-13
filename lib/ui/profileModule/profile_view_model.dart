import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:system_reports_app/ui/profileModule/profile_repository.dart';
import 'package:system_reports_app/ui/profileModule/profile_screen.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileRepository repository = ProfileRepository();

  User? _currentUser;
  User? get currentUser => _currentUser;

  Widget _view = Container();
  Widget get view => _view;

  bool _inProgress = false;
  bool get inProgress => _inProgress;

  fetchCurrentUser() {
    final response = repository.fetchCurrentUser();

    if (response != null) {
      _currentUser = response;
      _view = ProfileView(user: currentUser!);
    } else {
      _view = const Center(child: Text('No existe data'));
    }

    notifyListeners();
  }

  editData(User user) {
    _view = ProfileEditDataView(user: user);
    notifyListeners();
  }

  uploadImageToFirebaseStorage(File imageFile) async {
    _inProgress = true;
    notifyListeners();
    final response = await repository.uploadImageToFirebaseStorage(imageFile);
    if (response != null) {
      currentUser?.updatePhotoURL(response);
    repository.updateImageProfile(response);
      await Future.delayed(const Duration(seconds: 3), () {
        _inProgress = false;
        fetchCurrentUser();
      });
    }
  }

  void updateUserData(String name) async {
    _inProgress = true;
    notifyListeners();
    if (name.isNotEmpty) currentUser?.updateDisplayName(name);
    repository.updateNameProfile(name);
    await Future.delayed(const Duration(seconds: 3), () {
      _inProgress = false;
      fetchCurrentUser();
    });
  }
}
