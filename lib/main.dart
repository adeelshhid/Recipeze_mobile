import 'package:firebase_login/core/api/api_client.dart';
import 'package:firebase_login/core/api/auth_service.dart';
import 'package:firebase_login/core/api/unauthorize_handler.dart';
import 'package:firebase_login/features/app/splash_screen/splash_screen.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/generate_recipe.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/login_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/Home_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/sign_up_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/kitchen_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/ingredients_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/bookmarks_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService(
    apiClient: ApiClient(
      baseUrl: 'http://15.237.250.139/api/v1/recipeze',
      defaultHeaders: {'Content-Type': 'application/json'},
    ),
  );

  Future<Widget> _getInitialPage() async {
    String? token = await authService.getToken();
    if (token != null) {
      return const KitchenPage(); // Navigate to KitchenPage if token exists
    } else {
      return const HomePage(); // Otherwise, navigate to LoginPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialPage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        } else if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: UnauthorizedHandler().navigatorKey, // Add global key
            title: 'Flutter Firebase',
            home: snapshot.data, // Set initial page dynamically
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
