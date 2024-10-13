// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAOYhFV_E-QKqdR43kv2HDA7RxpXyZxzKY',
    appId: '1:225490669750:web:a924c0c8c5ba75084f5617',
    messagingSenderId: '225490669750',
    projectId: 'system-reports-app-dd306',
    authDomain: 'system-reports-app-dd306.firebaseapp.com',
    storageBucket: 'system-reports-app-dd306.appspot.com',
    measurementId: 'G-52BDR3GVSE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1Z1nKjaVY7_4G6XM_wnvPvAb0EHQFOBA',
    appId: '1:225490669750:android:ed84823d59d1ce4a4f5617',
    messagingSenderId: '225490669750',
    projectId: 'system-reports-app-dd306',
    storageBucket: 'system-reports-app-dd306.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVnuDkT3t5tRBJsWd6qVJpQO5RgtWI89k',
    appId: '1:225490669750:ios:ae0a869f7e281ce04f5617',
    messagingSenderId: '225490669750',
    projectId: 'system-reports-app-dd306',
    storageBucket: 'system-reports-app-dd306.appspot.com',
    iosBundleId: 'com.example.systemReportsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVnuDkT3t5tRBJsWd6qVJpQO5RgtWI89k',
    appId: '1:225490669750:ios:ae0a869f7e281ce04f5617',
    messagingSenderId: '225490669750',
    projectId: 'system-reports-app-dd306',
    storageBucket: 'system-reports-app-dd306.appspot.com',
    iosBundleId: 'com.example.systemReportsApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAOYhFV_E-QKqdR43kv2HDA7RxpXyZxzKY',
    appId: '1:225490669750:web:2fa07f5735001d434f5617',
    messagingSenderId: '225490669750',
    projectId: 'system-reports-app-dd306',
    authDomain: 'system-reports-app-dd306.firebaseapp.com',
    storageBucket: 'system-reports-app-dd306.appspot.com',
    measurementId: 'G-LCHNF2GF49',
  );
}
