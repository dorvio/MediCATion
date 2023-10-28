// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB4pTsOl3RVojn6v9j1HwLA79Vkk0NNMWA',
    appId: '1:447061596736:web:02f026b2e1e5ad6f595da5',
    messagingSenderId: '447061596736',
    projectId: 'medication-e25c0',
    authDomain: 'medication-e25c0.firebaseapp.com',
    storageBucket: 'medication-e25c0.appspot.com',
    measurementId: 'G-TBD898N6YQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCgcvPAUpi8-VFYER7ISsqZtsWTX6cm6yI',
    appId: '1:447061596736:android:061f3c7baaa51e19595da5',
    messagingSenderId: '447061596736',
    projectId: 'medication-e25c0',
    storageBucket: 'medication-e25c0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCR_g_CeU-B2JsycwU4RGNuj1Tgmw56tRg',
    appId: '1:447061596736:ios:71d8b4a700bf179c595da5',
    messagingSenderId: '447061596736',
    projectId: 'medication-e25c0',
    storageBucket: 'medication-e25c0.appspot.com',
    iosBundleId: 'com.example.medication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCR_g_CeU-B2JsycwU4RGNuj1Tgmw56tRg',
    appId: '1:447061596736:ios:173050722725ca5c595da5',
    messagingSenderId: '447061596736',
    projectId: 'medication-e25c0',
    storageBucket: 'medication-e25c0.appspot.com',
    iosBundleId: 'com.example.medication.RunnerTests',
  );
}
