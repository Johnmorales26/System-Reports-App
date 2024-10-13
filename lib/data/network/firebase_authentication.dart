import 'package:system_reports_app/data/local/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:system_reports_app/data/network/firebase_database.dart';
import 'package:system_reports_app/ui/homeModule/home_screen.dart';

class FirebaseAuthentication {
  final db = FirebaseDatabase();

  Future<String> signUpWithEmailAndPassword(UserDatabase user, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      
      user.uid = credential.user?.uid;
      
      bool userCreationSuccess = await db.createNewUser(user);
      
      if (userCreationSuccess) {
        return HomeScreen.route;
      } else {
        return 'An error occurred while saving the user data. Please try again later.';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak. Please use a stronger password.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email. Please use another email address.';
      }
      return 'Error creating account. Error code: ${e.code}';
    } catch (e) {
      return 'An error occurred while creating the account. Please try again later.';
    }
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return HomeScreen.route;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return 'The email address is badly formatted.';
      } else if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-credential') {
        return 'The supplied auth credential is incorrect, malformed or has expired.';
      } else {
        return e.message ?? 'An unknown error occurred.';
      }
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
