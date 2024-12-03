import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnauthorizedHandler {
  static final UnauthorizedHandler _instance = UnauthorizedHandler._internal();
  factory UnauthorizedHandler() => _instance;

  UnauthorizedHandler._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void handleUnauthorized() {
    removeToken();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/Home', // Replace with your login route
      (route) => false, // Clear the navigation stack
    );
  }

  // Save token function
  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
