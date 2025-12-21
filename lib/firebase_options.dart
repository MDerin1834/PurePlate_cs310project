import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBfN4ItcGqqdtox3eGcZUtxJj9pQ8jKfXI',
    appId: '1:365556069856:android:081a3f1b1f3ccf67b46785',
    messagingSenderId: '365556069856',
    projectId: 'pureplate-4f35b',
    storageBucket: 'pureplate-4f35b.firebasestorage.app',
  );

}