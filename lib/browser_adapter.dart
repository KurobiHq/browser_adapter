library browser_adapter;

export 'unsupported.dart'
    if (dart.library.html) 'html.dart'
    if (dart.library.io) 'io.dart';
