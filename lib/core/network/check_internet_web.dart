// lib/core/network/check_internet_web.dart
import 'package:flutter/foundation.dart';
import 'package:start/core/network/check_internet.dart';
import 'dart:html' as html;  // Correct import position

class NetworkInfoWeb implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      return html.window.navigator.onLine!;
    } catch (_) {
      return true; // Fallback to true if check fails
    }
  }
}