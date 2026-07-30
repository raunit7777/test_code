import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';

class AppLogger {
  static void debug(String message) {
    if (kDebugMode) {
      dev.log('DEBUG: $message', name: 'AppLogger');
    }
  }

  static void info(String message) {
    dev.log('INFO: $message', name: 'AppLogger');
  }

  static void warning(String message) {
    dev.log('WARNING: $message', name: 'AppLogger');
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    dev.log(
      'ERROR: $message',
      name: 'AppLogger',
      error: error,
      stackTrace: stackTrace,
    );
  }
}