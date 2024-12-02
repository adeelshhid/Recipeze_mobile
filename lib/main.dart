import 'package:firebase_login/core/api/api_client.dart';
import 'package:firebase_login/core/api/auth_service.dart';
import 'package:firebase_login/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/generate_recipe.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService(
    apiClient: ApiClient(
      baseUrl:
          'http://15.237.250.139/api/v1/recipeze', // Updated to use your actual API base URL
      defaultHeaders: {'Content-Type': 'application/json'},
    ),
  );

  Future<Widget> _getInitialPage() async {
    String? token = await authService.getToken();
    if (token != null) {
      return const KitchenPage(); // Navigate to KitchenPage if token is available
    } else {
      return LoginPage(); // Otherwise, navigate to LoginPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while determining the initial page
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        } else if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Firebase',
            home: snapshot.data, // Set the initial page
            routes: {
              '/login': (context) => LoginPage(),
              '/signUp': (context) => SignUpPage(),
              '/Home': (context) => const HomePage(),
              '/kitchen': (context) => const KitchenPage(),
              '/ingredients': (context) => const IngredientsPage(),
              '/bookmarks': (context) => const BookmarksPage(),
              '/gen-recipe': (context) => GenerateRecipePage(),
            },
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        }
      },
    );
  }
}
