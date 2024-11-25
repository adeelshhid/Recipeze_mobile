import 'package:firebase_login/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/Home_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/sign_up_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/kitchen_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/ingredients_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/bookmarks_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/profile_info.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
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
        '/login': (context) =>  LoginPage(),
        '/signUp': (context) =>  SignUpPage(),
        '/Home': (context) => const HomePage(),
        '/kitchen': (context) => const KitchenPage(),
        '/ingredients': (context) => const IngredientsPage(),
        '/bookmarks' :  (context) => const BookmarksPage(),
        
      },
    );
  }
}