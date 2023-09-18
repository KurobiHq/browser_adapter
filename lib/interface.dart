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
  bool isSupported();
  Stream<bool> getStream();
  dispose() {}
}

class OnFirstFrameListener {
  OnFirstFrameListener();
  dispose() {}
}
