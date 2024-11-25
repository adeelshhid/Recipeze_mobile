import 'dart:convert';

// lib/core/extensions/string_extensions.dart
extension StringExtensions on String {
  bool isValidJson() {
    try {
      json.decode(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}
