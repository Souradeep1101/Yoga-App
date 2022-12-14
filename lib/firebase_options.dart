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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBg-eQVRQa5PPCCwtMdqlboNDkAJ8ys0-s',
    appId: '1:433378237444:android:45643d31d145db83f5e951',
    messagingSenderId: '433378237444',
    projectId: 'yoga-app-b28d4',
    databaseURL: 'https://yoga-app-b28d4-default-rtdb.firebaseio.com',
    storageBucket: 'yoga-app-b28d4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDIl1y4wkY94jRBMsyCapucRZu0lkqoU4',
    appId: '1:433378237444:ios:96f49ed3fa6e13e9f5e951',
    messagingSenderId: '433378237444',
    projectId: 'yoga-app-b28d4',
    databaseURL: 'https://yoga-app-b28d4-default-rtdb.firebaseio.com',
    storageBucket: 'yoga-app-b28d4.appspot.com',
    androidClientId: '433378237444-uulc02inn42hg8ue59cecrc9k2ntiblb.apps.googleusercontent.com',
    iosClientId: '433378237444-getlr6cvvpbluf1mjpt2121am24a01od.apps.googleusercontent.com',
    iosBundleId: 'com.souradeep.yogaApp',
  );
}
