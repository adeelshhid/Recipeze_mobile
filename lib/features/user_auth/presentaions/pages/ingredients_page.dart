import 'package:flutter/material.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/kitchen_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/bookmarks_page.dart';
//import 'package:firebase_login/features/user_auth/presentaions/pages/profile_page.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  _IngredientsPageState createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00b473),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Ingredients",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Ingredients',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Placeholder for the ingredients content
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Cooking Essentials",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Add content here (lists of ingredients etc.)
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00b473),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: const Color(0xff00b473),
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 0,
      //   onTap: (index) {
      //     switch (index) {
      //       case 0:
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) => const KitchenPage()),
      //         );
      //         break;
      //       case 1:
      //         Navigator.pushReplacement(
      //           context,
      //           MaterialPageRoute(builder: (context) => const BookmarksPage()),
      //         );
      //         break;
      //       // case 2:
      //       //   Navigator.pushReplacement(
      //       //     context,
      //       //     MaterialPageRoute(builder: (context) => const ProfilePage()),
      //       //   );
      //       //   break;
      //     }
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.kitchen),
      //       label: 'Kitchen',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bookmark),
      //       label: 'Bookmarks',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }
}
