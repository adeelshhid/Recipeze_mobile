import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_login/core/api/auth_service.dart';
import 'package:firebase_login/core/api/api_client.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Create an instance of ApiClient with base URL and default headers
  late final ApiClient apiClient;
  late final AuthService authService;

  _ProfilePageState() {
    apiClient = ApiClient(
      baseUrl: 'http://10.0.2.2:8000/api/v1/recipeze',
      defaultHeaders: {'Content-Type': 'application/json'},
    );

    // Pass the apiClient to AuthService
    authService = AuthService(apiClient: apiClient);
  }

  void _logout() async {
    try {
      await authService.logout();
      // Navigate to the login page after successful logout
      Navigator.pushReplacementNamed(context, '/login');
      // Fluttertoast.showToast(
      //   msg: 'User logged out successfully',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      // );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Logout failed: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff00b473),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundColor: const Color(0xff00b473),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),

            // Account, Share, Feedback options
            // GestureDetector(
            //   onTap: _navigateToProfileInfo, // Navigate to Profile Info Page when pressed
            //   child: _buildOptionRow(Icons.account_circle, "Account"),
            // ),
            _buildOptionRow(Icons.account_circle, "Account"),
            const Divider(),
            _buildOptionRow(Icons.share, "Share"),
            const Divider(),
            _buildOptionRow(Icons.feedback, "Feedback"),
            const Divider(),

            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff00b473), size: 28),
          const SizedBox(width: 20),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        ],
      ),
    );
  }
}
