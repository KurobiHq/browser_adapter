import 'package:flutter/material.dart';
import 'interface.dart' as inter;

bool get isDesktopBrowser => throw UnimplementedError();

bool get isSafariBrowser => throw UnimplementedError();

bool get isPWA => throw UnimplementedError();

bool get isMobileBrowser => throw UnimplementedError();

bool get isWasm => throw UnimplementedError();

Future<bool> canOpenDeepLinkFromWeb(String link) => throw UnimplementedError();

EdgeInsets getExtraPadding() {
  throw UnimplementedError();
}

String get browserVersion => throw UnimplementedError();

void initializeViewPort() {
  throw UnimplementedError();
}

void removeDocument(String id) {
  throw UnimplementedError();
}

void replaceBrowserUrl(String path, {String title = ''}) {
  throw UnimplementedError();
}

class FocusOutDetector extends inter.FocusOutDetector {
  VoidCallback? onFocusOut;
  FocusOutDetector({this.onFocusOut});
  @override
  dispose() {
    throw UnimplementedError();
  }
}

class PageVisibilityDetector extends inter.PageVisibilityDetector {
  ValueChanged<bool>? onVisibilityChanged;
  PageVisibilityDetector({this.onVisibilityChanged});
  @override
  dispose() {
    throw UnimplementedError();
  }
}

class KeyboardHeightVisibilityDetector
    extends inter.KeyboardHeightVisibilityDetector {
  KeyboardHeightVisibilityDetector();

  @override
  Stream<bool> getStream() => throw UnimplementedError();

  @override
  bool isSupported() => false;
}
