import 'package:firebase_login/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/Home_Page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/login_pages.dart';
import 'package:firebase_login/features/user_auth/presentaions/widgets/form_container_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/global/common/toast.dart';
import 'package:flutter/material.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpPageState();
  }

}

class _SignUpPageState extends State<SignUpPage>{

  final FirebaseAuthServices _auth = FirebaseAuthServices();


  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

    bool isSigningUp = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body:  Center(
        child: Padding(
          padding: const  EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const  Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const  SizedBox(height: 20,),

                FormContainerWidget(
                controller: _usernameController,
                hintText: "UserName",
                isPasswordField: false,
              ),

              const SizedBox(height: 20,),
          
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
          
             const   SizedBox(height: 20,),
          
               FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),

             const    SizedBox(
                height: 20,
              ),

             GestureDetector(
              onTap: () { 
                _signUp();
                
              },
               child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  child:   Center(child: isSigningUp ? const CircularProgressIndicator(color: Colors.white,):   const Text("Sign Up" , style:  TextStyle(color: Colors.white),), ),
               ),
             ),

             
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 const Text("Already have an account?"),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false,
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          
              // Add more widgets here like TextFormField, ElevatedButton, etc.
            ],
          ),
        ),
      ),
    );
  }
    void _signUp() async {

      setState(() {
  isSigningUp = true;
});

  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  print("Attempting sign-up with email: $email and password: $password");

  try {
    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
  isSigningUp = false;
});

    if (user != null) {
      showToast(message: "User created successfully: ${user.email}");
      Navigator.pushNamed(context, '/Home');
    } else {
      showToast(message: "User is null, something went wrong.");
    }
  } catch (e) {
   showToast(message: "Sign-up failed: $e");  // Log specific errors to understand what's happening
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sign-up failed: $e")),
    );
  }
}

  }


