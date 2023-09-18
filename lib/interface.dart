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

class KeyboardHeightVisibilityDetector {
  KeyboardHeightVisibilityDetector();
  static bool isSupported() => false;
  dispose() {}
}

class OnFirstFrameListener {
  OnFirstFrameListener();
  dispose() {}
}
