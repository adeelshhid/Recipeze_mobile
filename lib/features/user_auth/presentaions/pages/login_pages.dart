
import 'package:flutter/material.dart';
import 'package:firebase_login/core/api/auth_controller.dart';
import 'package:firebase_login/features/user_auth/presentaions/widgets/form_container_widget.dart';
import 'package:firebase_login/global/common/toast.dart';


class LoginPage extends StatelessWidget {
  final AuthController authController = AuthController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00B473),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 200, width: 200),
            const SizedBox(height: 24),
            const Text(
              "Recipeze",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            FormContainerWidget(
              controller: emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 16),
            FormContainerWidget(
              controller: passwordController,
              hintText: 'Password',
              isPasswordField: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
  onPressed: () async {
    bool success = await authController.login(
      emailController.text,
      passwordController.text,
    );
    if (success) {
      Navigator.pushReplacementNamed(context, '/kitchen');
    } else {
      showToast(message: 'Email or Password is incorrect');
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 50), // Button takes the whole row
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: const Text(
    'Login',
    style: TextStyle(
      color: Color(0xFF00B473), // Set the text color to green
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signUp');
                  },
                  child: const Text("Sign Up", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
