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
    apiKey: 'AIzaSyABqLZWncMgIx7FACTqKY2ZUql0KF3zdY8',
    appId: '1:842250017294:web:78af12a2f6040d34c4fa5f',
    messagingSenderId: '842250017294',
    projectId: 'energy-diary-5df98',
    authDomain: 'energy-diary-5df98.firebaseapp.com',
    storageBucket: 'energy-diary-5df98.appspot.com',
    measurementId: 'G-FNXJDMZQ3X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKW18-doBZvvFmHrqdLF1UQj1phPdxKsY',
    appId: '1:842250017294:android:c82cc3aa0b50bbb2c4fa5f',
    messagingSenderId: '842250017294',
    projectId: 'energy-diary-5df98',
    storageBucket: 'energy-diary-5df98.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCr46hPGBaUGHC4bwu9PKFh7z0dt36kvYc',
    appId: '1:842250017294:ios:2dc7c16488fe064ec4fa5f',
    messagingSenderId: '842250017294',
    projectId: 'energy-diary-5df98',
    storageBucket: 'energy-diary-5df98.appspot.com',
    androidClientId: '842250017294-tce629a0qha3c9amp5s4rn7fjrhu8f9p.apps.googleusercontent.com',
    iosClientId: '842250017294-melimcvo99mj67eq249rjg1jpi826bg1.apps.googleusercontent.com',
    iosBundleId: 'LeoLiu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCr46hPGBaUGHC4bwu9PKFh7z0dt36kvYc',
    appId: '1:842250017294:ios:c7e026be943e5864c4fa5f',
    messagingSenderId: '842250017294',
    projectId: 'energy-diary-5df98',
    storageBucket: 'energy-diary-5df98.appspot.com',
    androidClientId: '842250017294-tce629a0qha3c9amp5s4rn7fjrhu8f9p.apps.googleusercontent.com',
    iosClientId: '842250017294-vt4rtutgmnvu2rg75sfj521de1tk8l54.apps.googleusercontent.com',
    iosBundleId: 'com.example.myfirstapp',
  );
}
