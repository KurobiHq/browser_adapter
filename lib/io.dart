import 'package:flutter/material.dart';
import 'interface.dart' as inter;

bool isCanvasKitRenderer() {
  return false;
}

bool isDesktopBrowser() {
  return false;
}

bool isClipSupported() {
  return true;
}

bool isSafariBrowser() {
  return false;
}

bool isPWA() {
  return false;
}

bool isMobileBrowser() {
  return false;
}

EdgeInsets getExtraPadding() {
  return EdgeInsets.zero;
}

String get browserVersion => throw UnimplementedError();

void initializeViewPort() {}

void removeDocument(String id) {}
void replaceBrowserUrl(String path, {String title = ''}) {}

class FocusOutDetector extends inter.FocusOutDetector {
  VoidCallback? onFocusOut;
  FocusOutDetector({this.onFocusOut});
}

class PageVisibilityDetector extends inter.PageVisibilityDetector {
  ValueChanged<bool>? onVisibilityChanged;
  PageVisibilityDetector({this.onVisibilityChanged});
}

class KeyboardHeightVisibilityDetector
    extends inter.KeyboardHeightVisibilityDetector {
  KeyboardHeightVisibilityDetector();

  @override
  Stream<bool> getStream() => throw UnimplementedError();

  @override
  bool isSupported() => false;
}

class OnFirstFrameListener extends inter.PageVisibilityDetector {
  VoidCallback? onFirstFrame;

  OnFirstFrameListener({this.onFirstFrame});
}
