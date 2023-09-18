abstract class BrowserDetector {
  bool get isDesktopBrowser;
}

class FocusOutDetector {
  FocusOutDetector();
  dispose() {}
}

class PageVisibilityDetector {
  PageVisibilityDetector();
  dispose() {}
}

abstract class KeyboardHeightVisibilityDetector {
  KeyboardHeightVisibilityDetector();
  static bool isSupported() => false;
  Stream? getStream();
  dispose() {}
}

class OnFirstFrameListener {
  OnFirstFrameListener();
  dispose() {}
}
