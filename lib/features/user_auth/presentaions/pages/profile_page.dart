import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/login_pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _logout() {
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );

    // Show a toast message
    Fluttertoast.showToast(
      msg: "User logged out successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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

            // Profile Name and Join Date
            const Text(
              "........",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Joining Date: 18/9/2024",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Account, Share, Feedback options
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
