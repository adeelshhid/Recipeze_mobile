// lib/features/user_auth/presentations/pages/profile_info.dart
import 'package:flutter/material.dart';
import 'package:firebase_login/core/api/auth_service.dart';
import 'package:firebase_login/core/api/api_client.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/profile_edit.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({Key? key}) : super(key: key);

  @override
  _ProfileInfoPageState createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  late final ApiClient apiClient;
  late final AuthService authService;

  Map<String, dynamic>? userProfile;

  @override
  void initState() {
    super.initState();

    // Initialize ApiClient and AuthService
    apiClient = ApiClient(
      baseUrl: 'http://15.237.250.139/api/v1/recipeze',
      defaultHeaders: {'Content-Type': 'application/json'},
    );
    authService = AuthService(apiClient: apiClient);

    // Fetch user profile info
    _fetchProfileInfo();
  }

  Future<void> _fetchProfileInfo() async {
    try {
      final profileInfo = await authService.getProfileInfo();
      setState(() {
        userProfile = profileInfo;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch profile info: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00b473),
        title:
            const Text('Profile Info', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: userProfile == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xff00b473),
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Name: ${userProfile!['name']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Email: ${userProfile!['email']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileEditPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00b473),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Edit Profile',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
