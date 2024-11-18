import 'package:flutter/material.dart';
import 'login_pages.dart'; // Import the login page

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              'assets/Welcome Page.png', // Use the original image you want
              fit: BoxFit.cover, // Ensures the image covers the full screen
            ),
          ),

          // Positioned Button at the bottom
          Positioned(
            bottom: 20, // Adjust this to match the placement like the second image
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  backgroundColor: Colors.white, // White background for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Start cooking!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green, // Green text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

