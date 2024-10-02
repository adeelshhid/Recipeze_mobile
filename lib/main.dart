import 'package:firebase_login/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/Home_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/sign_up_page.dart';



import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
        routes: {
        '/': (context) => const SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: HomePage(),
        ),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/Home': (context) => const HomePage(),
      },
    );
  }
}