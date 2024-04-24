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
    apiKey: 'AIzaSyBCJKo1uD29Ww5Y9CILHdz92UJw4RID3qE',
    appId: '1:331456193574:web:67772d76d71a9183bff2e7',
    messagingSenderId: '331456193574',
    projectId: 'exerciseapp-e8a0e',
    authDomain: 'exerciseapp-e8a0e.firebaseapp.com',
    databaseURL: 'https://exerciseapp-e8a0e-default-rtdb.firebaseio.com',
    storageBucket: 'exerciseapp-e8a0e.appspot.com',
    measurementId: 'G-NH3THJWK1V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8PWo0sLVM02YNdXrfgk9UCbvsyNrvz_E',
    appId: '1:331456193574:android:f66dcec807b7993ebff2e7',
    messagingSenderId: '331456193574',
    projectId: 'exerciseapp-e8a0e',
    databaseURL: 'https://exerciseapp-e8a0e-default-rtdb.firebaseio.com',
    storageBucket: 'exerciseapp-e8a0e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFhPI86njl-XgpfuRFD9EcXhqekx7eD-8',
    appId: '1:331456193574:ios:18048201f4fa5be3bff2e7',
    messagingSenderId: '331456193574',
    projectId: 'exerciseapp-e8a0e',
    databaseURL: 'https://exerciseapp-e8a0e-default-rtdb.firebaseio.com',
    storageBucket: 'exerciseapp-e8a0e.appspot.com',
    iosBundleId: 'com.example.exerciseApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFhPI86njl-XgpfuRFD9EcXhqekx7eD-8',
    appId: '1:331456193574:ios:18048201f4fa5be3bff2e7',
    messagingSenderId: '331456193574',
    projectId: 'exerciseapp-e8a0e',
    databaseURL: 'https://exerciseapp-e8a0e-default-rtdb.firebaseio.com',
    storageBucket: 'exerciseapp-e8a0e.appspot.com',
    iosBundleId: 'com.example.exerciseApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCJKo1uD29Ww5Y9CILHdz92UJw4RID3qE',
    appId: '1:331456193574:web:ee39f3d86f84591abff2e7',
    messagingSenderId: '331456193574',
    projectId: 'exerciseapp-e8a0e',
    authDomain: 'exerciseapp-e8a0e.firebaseapp.com',
    databaseURL: 'https://exerciseapp-e8a0e-default-rtdb.firebaseio.com',
    storageBucket: 'exerciseapp-e8a0e.appspot.com',
    measurementId: 'G-K4X1WDVYK1',
  );

}