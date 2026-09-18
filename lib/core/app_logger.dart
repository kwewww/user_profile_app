import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Centralized, password-safe diagnostics for authentication and session flow.
class AppLogger {
  AppLogger._();

  static const _name = 'UserProfileApp';

  static void info(String message) {
    debugPrint('[$_name] $message');
    developer.log(message, name: _name, level: 800);
  }

  static void warning(String message) {
    debugPrint('[$_name][WARNING] $message');
    developer.log(message, name: _name, level: 900);
  }

  static void error(String message, Object error, StackTrace stackTrace) {
    debugPrint('[$_name][ERROR] $message: $error');
    developer.log(
      message,
      name: _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
