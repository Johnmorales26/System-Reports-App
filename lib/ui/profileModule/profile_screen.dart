import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:system_reports_app/ui/profileModule/profile_view_model.dart';
import 'package:system_reports_app/ui/style/dimens.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);

    if (vm.currentUser == null) {
      vm.fetchCurrentUser();
    }

    return Scaffold(
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, child) {
          return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.commonPaddingDefault),
              child: vm.view);
        },
      ),
    );
  }
}

class ProfileView extends StatelessWidget {
  final User user;

  const ProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: user.photoURL == null
              ? const AssetImage('assets/default_avatar.png')
              : NetworkImage(user.photoURL!) as ImageProvider,
        ),
        const SizedBox(height: Dimens.commonPaddingDefault),
        Text('UID', style: Theme.of(context).textTheme.bodyLarge),
        Text(user.uid.toString(),
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Dimens.commonPaddingDefault),
        Text('Name', style: Theme.of(context).textTheme.bodyLarge),
        Text(user.displayName.toString(),
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Dimens.commonPaddingDefault),
        Text('Email', style: Theme.of(context).textTheme.bodyLarge),
        Text(user.email.toString(),
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Dimens.commonPaddingDefault),
        ElevatedButton(
          onPressed: () {
            vm.editData(user); // Cambiar la vista al editar datos
          },
          child: const Text('Edit Data'),
        ),
      ],
    ));
  }
}

class ProfileEditDataView extends StatelessWidget {
  final User user;

  const ProfileEditDataView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);
    final TextEditingController uidController =
        TextEditingController(text: user.uid);
    final TextEditingController nameController =
        TextEditingController(text: user.displayName);
    final TextEditingController emailController =
        TextEditingController(text: user.email);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: user.photoURL == null
                      ? const AssetImage('assets/default_avatar.png')
                      : NetworkImage(user.photoURL!) as ImageProvider,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt,
                      size: 30, color: Colors.white),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      // Convierte XFile a File
                      File imageFile = File(image.path);
                      // Llama a la función para subir la imagen
                      vm.uploadImageToFirebaseStorage(imageFile);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: Dimens.commonPaddingDefault),
            TextField(
              enabled: false,
              controller: uidController,
              decoration: const InputDecoration(
                labelText: 'UID',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Hacerlo solo lectura
            ),
            const SizedBox(height: Dimens.commonPaddingDefault),
            // Cambiando Text a TextField para Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Dimens.commonPaddingDefault),
            // Cambiando Text a TextField para Name
            TextField(
              enabled: false,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: Dimens.commonPaddingMin),
            vm.inProgress == true
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      vm.updateUserData(nameController.text);
                    },
                    child: const Text('Save Changes'),
                  ),
          ],
        ),
      ),
    );
  }
}
