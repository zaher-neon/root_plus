import 'dart:async';
import 'package:flutter/services.dart';

class RootPlus {
  static const MethodChannel _channel = MethodChannel('com.neon.root_plus');

  /// Requests root access and returns whether it was granted
  static Future<bool> requestRootAccess() async {
    try {
      return await _channel.invokeMethod('requestRootAccess');
    } on PlatformException {
      return false;
    }
  }

  /// Executes a shell command with root privileges
  /// Returns the command output if successful
  static Future<String> executeRootCommand(String command) async {
    try {
      return await _channel.invokeMethod('executeRootCommand', {
        'command': command,
      });
    } on PlatformException catch (e) {
      throw RootCommandException(
        e.code,
        e.message ?? 'Unknown error',
        e.details,
      );
    }
  }
}

class RootCommandException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  RootCommandException(this.code, this.message, this.details);

  @override
  String toString() => 'RootCommandException($code): $message';
}
