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
    apiKey: 'AIzaSyBlOmgdhLKTyjzSan09wNLZrHEGFunMoRc',
    appId: '1:594661534003:web:7709fbd47b6183f9823646',
    messagingSenderId: '594661534003',
    projectId: 'tharani-a-traders',
    authDomain: 'tharani-a-traders.firebaseapp.com',
    storageBucket: 'tharani-a-traders.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmVqE1YXl9lIqCXOgJ9hXj9d9UF7L0ABs',
    appId: '1:594661534003:android:e662d92785142c2a823646',
    messagingSenderId: '594661534003',
    projectId: 'tharani-a-traders',
    storageBucket: 'tharani-a-traders.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbfcHNJDClqOjWBHB-YOuBmeKO1ODsdSU',
    appId: '1:594661534003:ios:fb0ad1d7e2f0fb96823646',
    messagingSenderId: '594661534003',
    projectId: 'tharani-a-traders',
    storageBucket: 'tharani-a-traders.appspot.com',
    iosBundleId: 'com.example.tat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbfcHNJDClqOjWBHB-YOuBmeKO1ODsdSU',
    appId: '1:594661534003:ios:7a6c36d0719406f2823646',
    messagingSenderId: '594661534003',
    projectId: 'tharani-a-traders',
    storageBucket: 'tharani-a-traders.appspot.com',
    iosBundleId: 'com.example.tat.RunnerTests',
  );
}
