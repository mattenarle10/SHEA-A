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
    apiKey: 'AIzaSyBLyyCDVjzsLCBkJ3P3PJ3dW6h9g4ErLsw',
    appId: '1:285656086763:web:fa5b5d722a04cb7d11e6ae',
    messagingSenderId: '285656086763',
    projectId: 'shea-a',
    authDomain: 'shea-a.firebaseapp.com',
    storageBucket: 'shea-a.firebasestorage.app',
    measurementId: 'G-B015VDSCFB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSW1Lx3qeCe1g48jSSNPwnhhsvx1Tx0KU',
    appId: '1:285656086763:android:4cdf17298f30889711e6ae',
    messagingSenderId: '285656086763',
    projectId: 'shea-a',
    storageBucket: 'shea-a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAjce18cnGbCsvOqKHAoRgSH0jUCZq9Sxg',
    appId: '1:285656086763:ios:ceafc2991dd6010e11e6ae',
    messagingSenderId: '285656086763',
    projectId: 'shea-a',
    storageBucket: 'shea-a.firebasestorage.app',
    iosBundleId: 'com.example.seaa',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAjce18cnGbCsvOqKHAoRgSH0jUCZq9Sxg',
    appId: '1:285656086763:ios:ceafc2991dd6010e11e6ae',
    messagingSenderId: '285656086763',
    projectId: 'shea-a',
    storageBucket: 'shea-a.firebasestorage.app',
    iosBundleId: 'com.example.seaa',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBLyyCDVjzsLCBkJ3P3PJ3dW6h9g4ErLsw',
    appId: '1:285656086763:web:ba07fac9fe93d46611e6ae',
    messagingSenderId: '285656086763',
    projectId: 'shea-a',
    authDomain: 'shea-a.firebaseapp.com',
    storageBucket: 'shea-a.firebasestorage.app',
    measurementId: 'G-0ZFHYDNRG9',
  );
}
