// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBNE17wdThreHZ7H6ZnYrljI4RSTuNGrSw',
    appId: '1:1033494281623:web:b6eb979b61718cb2b058d2',
    messagingSenderId: '1033494281623',
    projectId: 'todp-app-buisness',
    authDomain: 'todp-app-buisness.firebaseapp.com',
    storageBucket: 'todp-app-buisness.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXcSpviLTnVkAouPy43rsmJh1iCjIHgQ4',
    appId: '1:1033494281623:android:1995b16f7ac50d6cb058d2',
    messagingSenderId: '1033494281623',
    projectId: 'todp-app-buisness',
    storageBucket: 'todp-app-buisness.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKftqkVZnRlcm2TVUV1zY2DgaZBytPaIU',
    appId: '1:1033494281623:ios:cdbab5e35e6cbb50b058d2',
    messagingSenderId: '1033494281623',
    projectId: 'todp-app-buisness',
    storageBucket: 'todp-app-buisness.firebasestorage.app',
    iosBundleId: 'com.example.todoAppBuisness',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKftqkVZnRlcm2TVUV1zY2DgaZBytPaIU',
    appId: '1:1033494281623:ios:cdbab5e35e6cbb50b058d2',
    messagingSenderId: '1033494281623',
    projectId: 'todp-app-buisness',
    storageBucket: 'todp-app-buisness.firebasestorage.app',
    iosBundleId: 'com.example.todoAppBuisness',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBNE17wdThreHZ7H6ZnYrljI4RSTuNGrSw',
    appId: '1:1033494281623:web:b914b9c00fa29a7eb058d2',
    messagingSenderId: '1033494281623',
    projectId: 'todp-app-buisness',
    authDomain: 'todp-app-buisness.firebaseapp.com',
    storageBucket: 'todp-app-buisness.firebasestorage.app',
  );

}