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
///
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
    apiKey: 'AIzaSyBoqQUCvhSSKYZvfbp6Z2c54Mdw7uIW2qs',
    appId: '1:657219940481:web:0d77cd6ed664d255235d80',
    messagingSenderId: '657219940481',
    projectId: 'cycling-routes-app-3fa75',
    authDomain: 'cycling-routes-app-3fa75.firebaseapp.com',
    storageBucket: 'cycling-routes-app-3fa75.appspot.com',
    measurementId: 'G-QXZ4QEVCWF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0kszNLGQU6D0R7Xp1knu0CypHIQcF36E',
    appId: '1:657219940481:android:be5c456a2cf61266235d80',
    messagingSenderId: '657219940481',
    projectId: 'cycling-routes-app-3fa75',
    storageBucket: 'cycling-routes-app-3fa75.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoEOWQLBmMhcSIdzfhpU-S5BiA1ISJVHQ',
    appId: '1:657219940481:ios:daa8eb65e9aa1fd6235d80',
    messagingSenderId: '657219940481',
    projectId: 'cycling-routes-app-3fa75',
    storageBucket: 'cycling-routes-app-3fa75.appspot.com',
    iosClientId: '657219940481-4ism4ngek53pvd69r24jgd2ha91nlmr7.apps.googleusercontent.com',
    iosBundleId: 'com.alpha.cyclingproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoEOWQLBmMhcSIdzfhpU-S5BiA1ISJVHQ',
    appId: '1:657219940481:ios:daa8eb65e9aa1fd6235d80',
    messagingSenderId: '657219940481',
    projectId: 'cycling-routes-app-3fa75',
    storageBucket: 'cycling-routes-app-3fa75.appspot.com',
    iosClientId: '657219940481-4ism4ngek53pvd69r24jgd2ha91nlmr7.apps.googleusercontent.com',
    iosBundleId: 'com.alpha.cyclingproject',
  );
}
