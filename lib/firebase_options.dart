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
    apiKey: 'AIzaSyAsqZbs-mr6Z8NOQqt_iPm7cX2OT-a7jjk',
    appId: '1:410381691609:web:86de0051395ce90741ecc8',
    messagingSenderId: '410381691609',
    projectId: 'starrestaurant-5c67d',
    authDomain: 'starrestaurant-5c67d.firebaseapp.com',
    storageBucket: 'starrestaurant-5c67d.appspot.com',
    measurementId: 'G-PTEGG46R5C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyClhUf4LydOfzBpCNp5EqAaQyO3zFL7gVI',
    appId: '1:410381691609:android:e23b89489f6faaa041ecc8',
    messagingSenderId: '410381691609',
    projectId: 'starrestaurant-5c67d',
    storageBucket: 'starrestaurant-5c67d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPt-tW4ZtZqpHElOG4ealtnTO8Ci7kSEs',
    appId: '1:410381691609:ios:76c47bfda0cc3b5c41ecc8',
    messagingSenderId: '410381691609',
    projectId: 'starrestaurant-5c67d',
    storageBucket: 'starrestaurant-5c67d.appspot.com',
    iosClientId: '410381691609-7p2hlthrjutvo9m1pc73fndidt78a7l6.apps.googleusercontent.com',
    iosBundleId: 'com.example.starRestaurant',
  );
}
