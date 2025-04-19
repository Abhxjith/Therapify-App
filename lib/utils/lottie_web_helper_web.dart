import 'dart:html' as html;
import 'dart:ui' as ui;

void registerLottieWebView() {
  // Register a factory for the lottie animation
  ui.platformViewRegistry.registerViewFactory(
    'lottie-animation',
    (int viewId) {
      final iframe = html.IFrameElement()
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..src = 'https://lottie.host/embed/a49dd977-c1cc-4b88-8f10-7a53b0ccc572/YmlX07RQVA.lottie';
      return iframe;
    },
  );
} 