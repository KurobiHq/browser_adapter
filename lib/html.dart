@JS()

import 'dart:async';
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;
import 'interface.dart' as inter;

import 'package:js/js.dart';

@JS('window.browserVersion')
external String get browserVersion;

@JS('navigator.standalone')
external bool? get standAlone;

bool get isWasm => ui_web.BrowserDetection.instance.isWasm;

bool get isDesktopBrowser => ui_web.BrowserDetection.instance.isDesktop;

bool get isPWA =>
    (standAlone ?? false) ||
    web.window.matchMedia('(display-mode: standalone)').matches;

bool get isSafariBrowser => ui_web.BrowserDetection.instance.isSafari;

bool get isMobileBrowser => ui_web.BrowserDetection.instance.isMobile;

void replaceBrowserUrl(String path, {String title = ''}) {
  final currentState = web.window.history.state;
  web.window.history.replaceState(currentState, title, path);
}

EdgeInsets getExtraPadding() {
  //if (!isDesktopBrowser())
  final element = web.document.documentElement as web.HTMLElement;
  final sat = element.style.getPropertyValue("--sat");
  final sar = element.style.getPropertyValue("--sar");
  final sab = element.style.getPropertyValue("--sab");
  final sal = element.style.getPropertyValue("--sal");
  //print('sat: $sat, sar:$sar, sab:$sab, sal:$sal');
  return EdgeInsets.fromLTRB(
      stringToVal(sal), stringToVal(sat), stringToVal(sar), stringToVal(sab));
}

double stringToVal(String val) {
  if (val.endsWith('px')) {
    return double.tryParse(val.substring(0, val.length - 2)) ?? 0;
  }
  return double.tryParse(val) ?? 0;
}

void initializeViewPort() {
  final viewportMeta = web.document.createElement('meta')
    ..setAttribute('flt-viewport', '');
  viewportMeta.setAttribute('name', 'viewport');
  viewportMeta.setAttribute('content',
      'width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no,viewport-fit=cover');
  web.document.head!.append(viewportMeta);
}

void removeDocument(String id) {
  final loader = web.document.getElementById(id);
  if (loader != null) {
    loader.remove();
  }
}

Future<bool> canOpenDeepLinkFromWeb(String url) async {
  final start = DateTime.now();

  // Create an invisible iframe to try opening the URL
  // Create an invisible iframe to try opening the URL
  final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement;
  iframe.style.display = 'none';
  iframe.src = url;
  web.document.body?.append(iframe);

  // Wait for a short delay to check if the app opened
  await Future.delayed(const Duration(seconds: 1));
  final elapsed = DateTime.now().difference(start).inMilliseconds;
  iframe.remove(); // Clean up the iframe

  // Return true if the app likely opened, otherwise false
  return elapsed < 1500;
}

class FocusOutDetector extends inter.FocusOutDetector {
  VoidCallback? onFocusOut;

  FocusOutDetector({this.onFocusOut}) {
    web.document
        .addEventListener('focusout', _handleFocusOut as web.EventHandler);
  }

  @override
  dispose() {
    web.document
        .removeEventListener('focusout', _handleFocusOut as web.EventHandler);
  }

  void _handleFocusOut(event) {
    onFocusOut?.call();
  }
}

class PageVisibilityDetector extends inter.PageVisibilityDetector {
  ValueChanged<bool>? onVisibilityChanged;
  late StreamSubscription sub;
  PageVisibilityDetector({this.onVisibilityChanged}) {
    sub = web.document.onVisibilityChange.listen(_handleChange);
  }

  @override
  dispose() {
    sub.cancel();
  }

  void _handleChange(event) {
    final visible = !(web.document.hidden);
    onVisibilityChanged?.call(visible);
  }
}

class OnFirstFrameListener extends inter.PageVisibilityDetector {
  VoidCallback? onFirstFrame;

  OnFirstFrameListener({this.onFirstFrame}) {
    web.window.addEventListener(
        'flutter-first-frame', _handleFirstFrame as web.EventHandler);
  }

  void _handleFirstFrame(event) {
    onFirstFrame?.call();
  }

  @override
  dispose() {
    web.window.removeEventListener(
        'flutter-first-frame', _handleFirstFrame as web.EventHandler);
  }
}

const _kHeuristicViewPortHeightClientRatio = 0.85;

class KeyboardHeightVisibilityDetector
    extends inter.KeyboardHeightVisibilityDetector {
  final BehaviorSubject<bool> _sub = BehaviorSubject();
  KeyboardHeightVisibilityDetector() {
    if (!isSupported()) {
      return;
    }
    web.window.visualViewport!.onscroll = _checkViewPort as web.EventHandler;
    web.window.visualViewport!.onscroll = _checkViewPort as web.EventHandler;
  }

  void _checkViewPort(event) {
    final viewPort = web.window.visualViewport;
    bool keyBoardVisible = false;
    if (web.document.documentElement?.clientHeight != null &&
        viewPort?.height != null &&
        viewPort?.scale != null) {
      keyBoardVisible = ((viewPort!.height * viewPort.scale) /
              web.document.documentElement!.clientHeight) <
          _kHeuristicViewPortHeightClientRatio;
    }
    _sub.add(keyBoardVisible);
  }

  @override
  Stream<bool> getStream() => _sub.stream.distinct();

  @override
  bool isSupported() => web.window.visualViewport != null;
}
