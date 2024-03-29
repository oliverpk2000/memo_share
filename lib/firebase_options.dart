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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBR8t5fG-vA02DGlpdnJ4eUND39tz-_kJs',
    appId: '1:93963667031:web:9dad2f1aa4488cf3e80512',
    messagingSenderId: '93963667031',
    projectId: 'memoshare-bde3c',
    authDomain: 'memoshare-bde3c.firebaseapp.com',
    databaseURL: 'https://memoshare-bde3c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'memoshare-bde3c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCO1tzOp4Zt0BKaOPI_VWkT2PVneCEXUjw',
    appId: '1:93963667031:android:850da4d1a4222fb5e80512',
    messagingSenderId: '93963667031',
    projectId: 'memoshare-bde3c',
    databaseURL: 'https://memoshare-bde3c-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'memoshare-bde3c.appspot.com',
  );
}
