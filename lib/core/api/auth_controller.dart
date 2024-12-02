// features/auth/auth_controller.dart

import '../../core/api/auth_service.dart';
import '../../core/api/api_client.dart';

class AuthController {
  final AuthService authService = AuthService(
    apiClient: ApiClient(
      baseUrl:
          'http://15.237.250.139/api/v1/recipeze', // Updated to use your actual API base URL
      defaultHeaders: {'Content-Type': 'application/json'},
    ),
  );

  Future<bool> login(String email, String password) async {
    return await authService.login(email, password);
  }

  Future<bool> register(String name, String email, String password) async {
    return await authService.register(name, email, password);
  }

  Future<void> logout() async {
    await authService.logout();
  }

  Future<Map<String, dynamic>?> getProfileInfo() async {
    return await authService.getProfileInfo();
  }

  Future<bool> updateProfile(String name, String email, String password) async {
    return await authService.updateProfile(name, email, password);
  }
}
