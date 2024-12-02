import 'package:firebase_login/global/common/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecipePage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipePage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xff00b473),
        title: const Text(
          'Recipe Details',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Center(
              child: Image.network(
                recipe['thumbnail_url'],
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, size: 250),
              ),
            ),
            const SizedBox(height: 16),

            // Recipe Name
            Text(
              recipe['name'],
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Instructions Heading
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Instructions Text
            Text(
              recipe['instructions'],
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),

            // Ingredients Heading
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Ingredients List
            for (var ingredient in recipe['ingredients'])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Color(0xff00b473)),
                    const SizedBox(width: 8),
                    Text(
                      '${ingredient['quantity']} ${ingredient['unit']} ${ingredient['name']}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Video Section (Even though no video URL is provided, this can be prepared for future use)
            const Text(
              'Watch Video',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            // Placeholder for Video
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 300,
                color: Colors.black12,
                child: recipe['orignal_video_url'] != null
                    ? VideoPlayerWidget(videoUrl: recipe['original_video_url'])
                    : const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Color(0xff00b473),
                          size: 80,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
