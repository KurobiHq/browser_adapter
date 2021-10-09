@JS()

import 'dart:async';

import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'interface.dart' as inter;

import 'package:js/js.dart';

/// A JavaScript entrypoint that allows developer to set rendering backend
/// at runtime before launching the application.

@JS('window.flutterWebRenderer')
external String get requestedRendererType;

@JS('window.isSafariBrowserLike')
external bool get isSafariBrowserLike;

const bool _autoDetect =
    bool.fromEnvironment('FLUTTER_WEB_AUTO_DETECT', defaultValue: false);

const bool _useSkia =
    bool.fromEnvironment('FLUTTER_WEB_USE_SKIA', defaultValue: false);

enum OperatingSystem {
  /// iOS: <http://www.apple.com/ios/>
  iOs,

  /// Android: <https://www.android.com/>
  android,

  /// Linux: <https://www.linux.org/>
  linux,

  /// Windows: <https://www.microsoft.com/windows/>
  windows,

  /// MacOs: <https://www.apple.com/macos/>
  macOs,

  /// We were unable to detect the current operating system.
  unknown,
}

const Set<OperatingSystem> _desktopOperatingSystems = {
  OperatingSystem.macOs,
  OperatingSystem.linux,
  OperatingSystem.windows,
};

class WebBrowserDetectorImp {
  WebBrowserDetectorImp() {
    _operatingSystem = _detectOperatingSystem();
  }

  OperatingSystem? _operatingSystem;

  OperatingSystem _detectOperatingSystem() {
    final String platform = html.window.navigator.platform!;
    final String userAgent = html.window.navigator.userAgent;

    if (platform.startsWith('Mac')) {
      return OperatingSystem.macOs;
    } else if (platform.toLowerCase().contains('iphone') ||
        platform.toLowerCase().contains('ipad') ||
        platform.toLowerCase().contains('ipod')) {
      return OperatingSystem.iOs;
    } else if (userAgent.contains('Android')) {
      // The Android OS reports itself as "Linux armv8l" in
      // [html.window.navigator.platform]. So we have to check the user-agent to
      // determine if the OS is Android or not.
      return OperatingSystem.android;
    } else if (platform.startsWith('Linux')) {
      return OperatingSystem.linux;
    } else if (platform.startsWith('Win')) {
      return OperatingSystem.windows;
    } else {
      return OperatingSystem.unknown;
    }
  }

  bool get isDesktopBrowser {
    return _desktopOperatingSystems.contains(_operatingSystem);
  }

  bool get isaMobileSafari => _operatingSystem == OperatingSystem.iOs;
}

bool isCanvasKitRenderer() {
  bool isCanvaskit = requestedRendererType == 'canvaskit';
  if (isCanvaskit) {
    return isCanvaskit;
  }
  return _autoDetect ? WebBrowserDetectorImp().isDesktopBrowser : _useSkia;
}

bool isDesktopBrowser() {
  return WebBrowserDetectorImp().isDesktopBrowser;
}

bool isClipSupported() {
  if (isSafariBrowserLike && isCanvasKitRenderer()) {
    return !isSafariBrowserLike;
  }
  return true;
}

bool isSafariBrowser() {
  return isSafariBrowserLike;
}

bool isMobileBrowser() {
  return WebBrowserDetectorImp().isaMobileSafari;
}

EdgeInsets getExtraPadding() {
  //if (!isDesktopBrowser())
  final sat = html.document.documentElement
          ?.getComputedStyle()
          .getPropertyValue("--sat") ??
      '';
  final sar = html.document.documentElement
          ?.getComputedStyle()
          .getPropertyValue("--sar") ??
      '';

  final sab = html.document.documentElement
          ?.getComputedStyle()
          .getPropertyValue("--sab") ??
      '';

  final sal = html.document.documentElement
          ?.getComputedStyle()
          .getPropertyValue("--sal") ??
      '';
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
  final viewportMeta = html.MetaElement()
    ..setAttribute('flt-viewport', '')
    ..name = 'viewport'
    ..content =
        'width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no,viewport-fit=cover';
  html.document.head!.append(viewportMeta);
}

class FocusOutDetector extends inter.FocusOutDetector {
  VoidCallback? onFocusOut;

  FocusOutDetector({this.onFocusOut}) {
    html.document.addEventListener('focusout', _handleFocusOut);
  }

  @override
  dispose() {
    html.document.removeEventListener('focusout', _handleFocusOut);
  }

  void _handleFocusOut(event) {
    onFocusOut?.call();
  }
}

class PageVisibilityDetector extends inter.PageVisibilityDetector {
  ValueChanged<bool>? onVisibilityChanged;
  late StreamSubscription sub;
  PageVisibilityDetector({this.onVisibilityChanged}) {
    sub = html.document.onVisibilityChange.listen(_handleChange);
  }

  @override
  dispose() {
    sub.cancel();
  }

  void _handleChange(event) {
    final visible = !(html.document.hidden ?? false);
    onVisibilityChanged?.call(visible);
  }
}
