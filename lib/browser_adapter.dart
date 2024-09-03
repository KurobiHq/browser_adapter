library browser_adapter;

export 'unsupported.dart'
    if (dart.library.js_interop) 'html.dart'
    if (dart.library.io) 'io.dart';
