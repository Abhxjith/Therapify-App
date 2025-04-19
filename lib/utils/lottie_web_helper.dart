import 'package:flutter/foundation.dart' show kIsWeb;

// Only import dart:html on web
import 'lottie_web_helper_web.dart' if (dart.library.io) 'lottie_web_helper_mobile.dart';

class LottieWebHelper {
  static void registerWebView() {
    if (kIsWeb) {
      // Call the platform-specific implementation
      registerLottieWebView();
    }
    // Do nothing on mobile platforms
  }
} 