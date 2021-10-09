abstract class BrowserDetector {
  bool get isDesktopBrowser;
}

abstract class FocusOutDetector {
  FocusOutDetector();
  dispose();
}

abstract class PageVisibilityDetector {
  PageVisibilityDetector();
  dispose();
}
