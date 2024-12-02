import 'dart:async';

import 'package:firebase_login/core/api/recipe_controller.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/generate_recipe.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/recipe_page.dart';
import 'package:firebase_login/global/common/toast.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final RecipeController _recipeController = RecipeController();
  List _savedRecipes = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1; // Track the current page

  @override
  void initState() {
    super.initState();
    _fetchSavedRecipes();
  }

  // Fetch saved recipes for the current page
  Future<void> _fetchSavedRecipes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recipes = await _recipeController.savedRec(page: _currentPage);
      setState(() {
        _savedRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBookmark(Map<String, dynamic> recipe) async {
    setState(() {
      recipe['saved'] = recipe['saved'] == 1 ? 0 : 1;
    });

    try {
      await _recipeController.toggleBookmark(recipe['id']);
      showToast(message: 'Recipe unsaved!');
      _fetchSavedRecipes();
    } catch (err) {}
  }

  void navigateToGenRecPage() async {
    // Wait for the user to return from GenerateRecipePage
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateRecipePage(),
      ),
    );

    // After returning from the GenerateRecipePage, call your method
    _fetchSavedRecipes(); // Example method you want to call when returning
  }

  // Go to the next page
  void _goToNextPage() {
    setState(() {
      _currentPage++;
    });
    _fetchSavedRecipes();
  }

  // Go to the previous page
  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchSavedRecipes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff00b473),
        centerTitle: true,
        title: const Text(
          "Bookmarks",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red)))
              : _savedRecipes.isEmpty
                  ? const Center(child: Text('No saved recipes found.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      itemCount: _savedRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _savedRecipes[index];
                        return _buildBookmarkCard(
                          recipe: recipe,
                          onToggleBookmark: () => _toggleBookmark(recipe),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'bookmarks_fab', // Provide a unique tag
        onPressed: navigateToGenRecPage,
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xff00b473),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _currentPage > 1 ? _goToPreviousPage : null,
              child: const Text("Prev"),
            ),
            ElevatedButton(
              onPressed: _savedRecipes.isNotEmpty ? _goToNextPage : null,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each bookmark card
  Widget _buildBookmarkCard({
    required dynamic recipe,
    required VoidCallback onToggleBookmark,
  }) {
    return GestureDetector(
        onTap: () async {
          setState(() {
            _isLoading = true; // Show loading indicator
          });

          try {
            final rec = await _recipeController.getRec(recipe['id']);
            print(rec);

            // Hide loading indicator after data is fetched
            setState(() {
              _isLoading = false;
            });

            // Navigate to the recipe details page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: rec),
              ),
            );
          } catch (e) {
            setState(() {
              _isLoading = false; // Hide loading indicator in case of error
            });
            // Handle the error (e.g., show a toast or error message)
            print('Error: $e');
          }
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff00b473), width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              // Green bar at the top
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
                  child: Image.network(
                    recipe['thumbnail_url'],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image, size: 80),
                  ),
                ),
                title: Text(
                  recipe['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.bookmark,
                    color: Color(0xff00b473),
                    size: 30,
                  ),
                  onPressed: onToggleBookmark,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              // Show loading indicator on top of the card when loading
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
