import 'package:flutter/material.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/bookmarks_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/profile_page.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/ingredients_page.dart';
import 'package:firebase_login/core/api/kitchen_controller.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({Key? key}) : super(key: key);

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  int _selectedIndex = 0;
  final KitchenController _kitchenController = KitchenController();
  List<Map<String, dynamic>> _kitchenItems = [];
  late List<Widget> _pages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Center(child: CircularProgressIndicator()), // Placeholder page
      const BookmarksPage(),
      const ProfilePage(),
    ];
    _fetchKitchenItems();
  }

  Future<void> _fetchKitchenItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final kitchenItems = await _kitchenController.getKitchenItems();
      setState(() {
        _kitchenItems = kitchenItems.map((item) => {'name': item}).toList();
        _pages[0] = KitchenPageContent(kitchenItems: _kitchenItems);
        isLoading = false;
      });
    } catch (e) {
      print('Failed to load kitchen items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : IndexedStack(
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IngredientsPage()),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: const Color(0xff00b473),
        ),
      ),
    );
  }
}

class KitchenPageContent extends StatelessWidget {
  final List<Map<String, dynamic>> kitchenItems;

  const KitchenPageContent({required this.kitchenItems, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00b473),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: kitchenItems.map((item) {
            return ChoiceChip(
              label: Text(item['name']),
              selected: true,
              onSelected: (selected) {
                // Handle item removal
                // Call API to remove item if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['name']} removed from kitchen')),
                );
              },
              selectedColor: Colors.green,
              backgroundColor: Colors.white,
            );
          }).toList(),
        ),
      ),
    );
  }
}