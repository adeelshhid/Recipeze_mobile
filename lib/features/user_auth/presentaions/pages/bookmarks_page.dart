import 'package:flutter/material.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removed the back arrow
        backgroundColor: const Color(0xff00b473),
        centerTitle: true,
        title: const Text(
          "Bookmarks",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            _buildBookmarkCard(
              imagePath: 'assets/image 9.png',
              title: 'Tomato Spaghetti',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkCard({required String imagePath, required String title}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff00b473), width: 2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Green bar at the top to reach the full width
          Container(
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xff00b473),
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
          ),
          // Bookmark Item
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            trailing: Icon(
              Icons.bookmark,
              color: const Color(0xff00b473),
              size: 30,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ],
      ),
    );
  }
}
