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
    apiKey: 'AIzaSyCzCpu0YoG9cViHR8H4KKIK4GvDDgRk0cs',
    appId: '1:147166136402:web:292b44627ac58d123cb78b',
    messagingSenderId: '147166136402',
    projectId: 'skibble-accessibility',
    authDomain: 'skibble-accessibility.firebaseapp.com',
    storageBucket: 'skibble-accessibility.appspot.com',
    measurementId: 'G-DZP2WX89Q7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmq5OoJpLRsJ3WAUeMsqpduCi8dccbYbs',
    appId: '1:147166136402:android:2f79ec328cd824523cb78b',
    messagingSenderId: '147166136402',
    projectId: 'skibble-accessibility',
    storageBucket: 'skibble-accessibility.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASC5rdj-GsvS12cjgHf1QkX1lk8Hx284c',
    appId: '1:147166136402:ios:6102f1dd564892243cb78b',
    messagingSenderId: '147166136402',
    projectId: 'skibble-accessibility',
    storageBucket: 'skibble-accessibility.appspot.com',
    iosBundleId: 'com.skib.skibbleAccessibility',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASC5rdj-GsvS12cjgHf1QkX1lk8Hx284c',
    appId: '1:147166136402:ios:f74f8e50b69c9c303cb78b',
    messagingSenderId: '147166136402',
    projectId: 'skibble-accessibility',
    storageBucket: 'skibble-accessibility.appspot.com',
    iosBundleId: 'com.skib.skibbleAccessibility.RunnerTests',
  );
}
