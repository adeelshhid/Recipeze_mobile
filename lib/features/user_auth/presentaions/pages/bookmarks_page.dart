import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00B473),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        // Uncomment and use your actual image assets
        // children: [
        //   _buildBookmarkItem('assets/image9.png', 'Tomato Spaghetti'),
        //   _buildBookmarkItem('assets/image10.png', 'Banana Bread'),
        //   _buildBookmarkItem('assets/image11.png', 'Tomato Soup'),
        //   _buildBookmarkItem('assets/image16.png', 'Ceasar Salad'),
        //   _buildBookmarkItem('assets/image17.png', 'Moussaka'),
        //   _buildBookmarkItem('assets/image18.png', 'French Toast'),
        //   _buildBookmarkItem('assets/image19.png', 'Apple Pie'),
        // ],
      ));
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: 1,
  //       onTap: (index) {
  //         switch (index) {
  //           case 0:
  //             Navigator.pushReplacementNamed(context, '/kitchen');
  //             break;
  //           case 1:
  //             Navigator.pushReplacementNamed(context, '/bookmarks');
  //             break;
  //           case 2:
  //             Navigator.pushReplacementNamed(context, '/profile');
  //             break;
  //         }
  //       },
  //       items: const [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.kitchen),
  //           label: 'Kitchen',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.bookmark),
  //           label: 'Bookmarks',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.person),
  //           label: 'Profile',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Define your _buildBookmarkItem here as needed
}
}
