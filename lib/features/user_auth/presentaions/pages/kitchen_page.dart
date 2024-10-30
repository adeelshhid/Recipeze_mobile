import 'package:flutter/material.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/ingredients_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/bookmarks_page.dart';

 import 'package:firebase_login/features/user_auth/presentaions/pages/profile_page.dart'; // Uncomment when ProfilePage is available

class KitchenPage extends StatefulWidget {
  const KitchenPage({Key? key}) : super(key: key);

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    KitchenPageContent(),
    BookmarksPage(),
    ProfilePage(),
    IngredientsPage(),
  // Uncomment when ProfilePage is available

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: "Kitchen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookmarks",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff00b473),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

// Separate widget for KitchenPage content
class KitchenPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00b473),
        centerTitle: true,
        title: const Text(
          "Kitchen",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar and Add Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Fridge",
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.add),
      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const IngredientsPage()),
  );
},

                ),
              ],
            ),
            const SizedBox(height: 20),

            // Fridge Items List
            Expanded(
              child: ListView(
                children: [
                  _buildFridgeItem("Balsamic Vinegar"),
                  _buildFridgeItem("Basil"),
                  _buildFridgeItem("Butter"),
                  _buildFridgeItem("Chicken"),
                  _buildFridgeItem("Eggs"),
                  _buildFridgeItem("Flat Bread"),
                  _buildFridgeItem("Flour"),
                  _buildFridgeItem("Lettuce"),
                  _buildFridgeItem("Olive Oil"),
                  _buildFridgeItem("Pasta"),
                  _buildFridgeItem("Rice"),
                  _buildFridgeItem("Salt"),
                  _buildFridgeItem("Sugar"),
                  _buildFridgeItem("Tomato"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Generate Recipes Button (Full Width)
            ElevatedButton(
              onPressed: () {
                // TODO: Add functionality for generating recipes
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00b473),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Generate Recipes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each fridge item row
  Widget _buildFridgeItem(String itemName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_box, color: Colors.green),
          const SizedBox(width: 10),
          Text(
            itemName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Handle remove item functionality
            },
            icon: const Icon(Icons.remove_circle, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
