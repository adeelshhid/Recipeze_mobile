import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_login/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/sign_up_page.dart';
import 'package:firebase_login/global/common/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  bool _isPasswordVisible = false; // To toggle password visibility
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00B473),
      body: SingleChildScrollView( // Wrap content to prevent overflow
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey, // Form key for validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80), // Add spacing to avoid overflow
                  Image.asset(
                    'assets/logo.png', // Your logo path
                    height: 150,
                    width: 500,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Recipeze',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email Field with Visible Text
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.black), // Black text for visibility
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey), // Light grey for hint text
                      filled: true,
                      fillColor: Colors.white, // White background for input
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password Field with Toggle Visibility
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // Toggle visibility
                    style: const TextStyle(color: Colors.black), // Black text for visibility
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.grey), // Light grey for hint text
                      filled: true,
                      fillColor: Colors.white, // White background for input
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible; // Toggle state
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _signIn,
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isSigning
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(color: Color(0xFF00B473)),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Google Sign-in Button (no changes here)
                  // GestureDetector(
                  //   onTap: _signInWithGoogle,
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 45,
                  //     decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: const Center(
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Icon(FontAwesomeIcons.google, color: Colors.white),
                  //           SizedBox(width: 5),
                  //           Text(
                  //             "Sign in with Google",
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

                 // const SizedBox(height: 20),

                  // Sign Up Redirection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), // Add bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Existing sign-in method with validation
  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSigning = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        User? user = await _auth.signInWithEmailAndPassword(email, password);

        setState(() {
          _isSigning = false;
        });

        if (user != null) {
          showToast(message: "User signed in successfully: ${user.email}");
          Navigator.pushNamed(context, '/Home');
        } else {
          showToast(message: "User is null, something went wrong.");
        }
      } catch (e) {
        showToast(message: "Sign-up failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign-up failed: $e")),
        );
      }
    }
  }

  // Google Sign-in Method (no changes)
  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushNamed(context, "/Home");
      }
    } catch (e) {
      showToast(message: "Some error occurred: $e");
    }
  }
}
