import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBREWLIiSJxPR9vYyauoEXaHksWmSk13GE',
    appId: '1:176630331571:android:9a34ddd892fb2b7d6258c6',
    messagingSenderId: '176630331571',
    projectId: 'softtask-86707',
    storageBucket: 'softtask-86707.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBREWLIiSJxPR9vYyauoEXaHksWmSk13GE',
    appId: '1:176630331571:android:9a34ddd892fb2b7d6258c6',
    messagingSenderId: '176630331571',
    projectId: 'softtask-86707',
    storageBucket: 'softtask-86707.appspot.com',
    iosClientId: '269299981012-1nqp26gi07tt5c79c6bt4gp1jmg32bdl.apps.googleusercontent.com',
    iosBundleId: 'uchargingpointmerchant.appspot.com',
  );
}
