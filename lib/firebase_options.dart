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
    apiKey: 'AIzaSyDzMC-GCfWQ01afhgMAb4ZQiG6_tPpZqWI',
    appId: '1:964978059660:web:f41be01d51a22bd4438ea9',
    messagingSenderId: '964978059660',
    projectId: 'agilecards-da16f',
    authDomain: 'agilecards-da16f.firebaseapp.com',
    databaseURL: 'https://agilecards-da16f-default-rtdb.firebaseio.com',
    storageBucket: 'agilecards-da16f.appspot.com',
    measurementId: 'G-TEJ8WSZ5GW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7aVGwPXttxUFxRF2QgRfWOVBzZddbEz8',
    appId: '1:964978059660:android:91a605ff5dc13826438ea9',
    messagingSenderId: '964978059660',
    projectId: 'agilecards-da16f',
    databaseURL: 'https://agilecards-da16f-default-rtdb.firebaseio.com',
    storageBucket: 'agilecards-da16f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAd8lSsk2LcHAHKP4ytI6S3yRra4epcyk8',
    appId: '1:964978059660:ios:8eb546ad69ab9710438ea9',
    messagingSenderId: '964978059660',
    projectId: 'agilecards-da16f',
    databaseURL: 'https://agilecards-da16f-default-rtdb.firebaseio.com',
    storageBucket: 'agilecards-da16f.appspot.com',
    iosClientId: '964978059660-6fo53jtaq0qqfidbejk6bt607qqd8ue2.apps.googleusercontent.com',
    iosBundleId: 'com.voostack.agilecardssprintplanning',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAd8lSsk2LcHAHKP4ytI6S3yRra4epcyk8',
    appId: '1:964978059660:ios:8eb546ad69ab9710438ea9',
    messagingSenderId: '964978059660',
    projectId: 'agilecards-da16f',
    databaseURL: 'https://agilecards-da16f-default-rtdb.firebaseio.com',
    storageBucket: 'agilecards-da16f.appspot.com',
    iosClientId: '964978059660-6fo53jtaq0qqfidbejk6bt607qqd8ue2.apps.googleusercontent.com',
    iosBundleId: 'com.voostack.agilecardssprintplanning',
  );
}
