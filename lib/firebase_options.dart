// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
// import 'package:flutter/foundation.dart'
//     show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Replace with your Firebase configuration
    return const FirebaseOptions(
      apiKey: "AIzaSyCcsHxpMkN7mFeOdFU6mSSXgSJ2yz1yluI",
      authDomain: "securityharisguard.firebaseapp.com",
      projectId: "securityharisguard",
      storageBucket: "securityharisguard.appspot.com",
      messagingSenderId: "164616734121",
      appId: "1:164616734121:web:3befe41105ef94ab7530b8"
    );
  }
}

