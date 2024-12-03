// lib/core/api/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../../global/common/toast.dart';
import 'package:firebase_login/core/extensions/string_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});

  // Save token function
  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get token function
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Login Method
  Future<bool> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        'login',
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200 && response.body.isValidJson()) {
        final data = json.decode(response.body);
        showToast(message: 'Logged in successfully');
        await saveToken(data['token']); // Save the token
        return true;
      } else {
        final errorData = json.decode(response.body);
        showToast(message: 'Login failed: ${errorData['message']}');
        return false;
      }
    } catch (e) {
      showToast(message: 'Password or email is incorrect');
      return false;
    }
  }

  // Register Method
  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await apiClient.post(
        'register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      if (response.statusCode == 201 && response.body.isValidJson()) {
        showToast(message: 'Registration successful');
        return true;
      } else {
        final errorData = json.decode(response.body);
        showToast(
            message:
                'Registration failed: ${errorData['errors']['email'] ?? errorData['message']}');
        return false;
      }
    } catch (e) {
      showToast(message: 'An error occurred: $e');
      return false;
    }
  }

  // Logout Method
  Future<bool> logout() async {
    try {
      final response = await apiClient.post('logout', token: await getToken());
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.body.isValidJson()) {
        final data = json.decode(response.body);
        if (data['message'] == 'User Logged Out') {
          showToast(message: 'Logged out successfully');
          await saveToken(''); // Clear the token
          return true;
        }
      }

      showToast(message: 'Logged out successfully');
      await saveToken(''); // Clear the token
      return false;
    } catch (e) {
      showToast(message: 'An error occurred: $e');
      return false;
    }
  }

  // Get Profile Info
  Future<Map<String, dynamic>?> getProfileInfo() async {
    String? token = await getToken();
    if (token == null) {
      showToast(message: 'No token found. Please login again.');
      return null;
    }

    try {
      final response = await apiClient.get('profile', token: token);

      if (response.statusCode == 200 && response.body.isValidJson()) {
        final data = json.decode(response.body);
        return data['user']; // Return profile info
      } else if (response.statusCode == 401) {
        showToast(message: 'Unauthorized. Please log in again.');
        return null;
      } else {
        final errorData = json.decode(response.body);
        showToast(
            message: errorData['message'] ?? 'Failed to fetch profile info');
        return null;
      }
    } catch (e) {
      showToast(message: 'An error occurred: $e');
      return null;
    }
  }

  // Update Profile
  Future<bool> updateProfile(String name, String email, String password) async {
    String? token = await getToken();
    if (token == null) {
      showToast(message: 'No token found. Please login again.');
      return false;
    }

    try {
      final response = await apiClient.post(
        'profile/update',
        token: token,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      if (response.statusCode == 200 && response.body.isValidJson()) {
        showToast(message: 'Profile updated successfully');
        return true;
      } else {
        final errorData = json.decode(response.body);
        showToast(message: 'Update failed: ${errorData['message']}');
        return false;
      }
    } catch (e) {
      showToast(message: 'An error occurred: $e');
      return false;
    }
  }
}
