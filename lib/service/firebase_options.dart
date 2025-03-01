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
    apiKey: 'AIzaSyBuQAQHnGEp0FgKW6mJRzekekytUiB08wQ',
    appId: '1:205622119482:web:3924b08cae7cae40dbf903',
    messagingSenderId: '205622119482',
    projectId: 'to-do-list-9de69',
    authDomain: 'to-do-list-9de69.firebaseapp.com',
    storageBucket: 'to-do-list-9de69.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAc6TLPU9AglTLFK7lh8O1ri0GwM6Y580I',
    appId: '1:205622119482:android:da1cb3a821e98978dbf903',
    messagingSenderId: '205622119482',
    projectId: 'to-do-list-9de69',
    storageBucket: 'to-do-list-9de69.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCVhuw72c-mX18e14pJioqpMGm8RJ5_OCo',
    appId: '1:205622119482:ios:9f78479be97074c6dbf903',
    messagingSenderId: '205622119482',
    projectId: 'to-do-list-9de69',
    storageBucket: 'to-do-list-9de69.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCVhuw72c-mX18e14pJioqpMGm8RJ5_OCo',
    appId: '1:205622119482:ios:9f78479be97074c6dbf903',
    messagingSenderId: '205622119482',
    projectId: 'to-do-list-9de69',
    storageBucket: 'to-do-list-9de69.appspot.com',
    iosBundleId: 'com.example.todoApp',
  );
}
