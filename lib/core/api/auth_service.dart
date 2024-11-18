// lib/core/api/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../../global/common/toast.dart';


class AuthService {
  final ApiClient apiClient;

  AuthService({required this.apiClient});

  // Login Method
  Future<bool> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        'login',
        body: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        showToast(message: 'Loged in successfully');
        // Store the token for further authenticated requests if needed
        return true;
      } else {
        final errorData = json.decode(response.body);
        //showToast(message: 'Login failed: ${errorData['message']}');
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

      if (response.statusCode == 201) {
        showToast(message: 'Registration successful');
        return true;
      } else {
        final errorData = json.decode(response.body);
        showToast(message: 'Registration failed: ${errorData['errors']['email'] ?? errorData['message']}');
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
    final response = await apiClient.post('logout');
    if (response.statusCode == 200 || response.statusCode == 201 ) {
      final data = json.decode(response.body);
      if (data['message'] == 'User Logged Out') {
        showToast(message: 'Logged out successfully');
        return true;
      }
    }
    
    showToast(message: 'Logged out successfully');
    return false;
  } catch (e) {
    // Catch and handle any exceptions, including unexpected HTML responses
    showToast(message: 'An error occurred: $e');
    return false;
  }
}

  // Get Profile Info
  Future<Map<String, dynamic>?> getProfileInfo() async {
    try {
      final response = await apiClient.get('profile');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['user']; // Return profile info
      } else {
        final errorData = json.decode(response.body);
        showToast(message: errorData['message'] ?? 'Failed to fetch profile info');
        return null;
      }
    } catch (e) {
      showToast(message: 'An error occurred: $e');
      return null;
    }
  }

  // Update Profile
  Future<bool> updateProfile(String name, String email, String password) async {
    try {
      final response = await apiClient.post(
        'profile/update',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      if (response.statusCode == 200) {
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