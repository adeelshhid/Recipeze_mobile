import 'package:firebase_login/core/api/recipe_controller.dart';
import 'package:firebase_login/features/user_auth/presentaions/pages/recipe_page.dart';
import 'package:firebase_login/global/common/toast.dart';
import 'package:flutter/material.dart';

class GenerateRecipePage extends StatefulWidget {
  @override
  _GenerateRecipePageState createState() => _GenerateRecipePageState();
}

class _GenerateRecipePageState extends State<GenerateRecipePage> {
  final RecipeController recipeController = RecipeController();
  List recipes = [];
  List savedRecipesIds = [];
  bool isLoading = false;
  int currentPage = 1;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      Map<String, List> fetchedRecipes =
          await recipeController.getRecByPage(page: currentPage);
      setState(() {
        recipes = (fetchedRecipes as Map)['recipes'] as List;
        savedRecipesIds = (fetchedRecipes as Map)['savedRecIds'] as List;
        // Map through the recipes and set 'saved' = 1 if the ID exists in savedRecipesIds
        recipes.forEach((rec) {
          if (savedRecipesIds.contains(rec['id'])) {
            rec['saved'] = 1;
          } else {
            rec['saved'] = 0; // Set 'saved' to 0 if not saved
          }
        });
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void goToNextPage() {
    setState(() {
      currentPage++;
    });
    fetchRecipes();
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchRecipes();
    }
  }

  Future<void> _toggleBookmark(Map<String, dynamic> recipe) async {
    // Toggle the 'saved' status locally
    setState(() {
      recipe['saved'] = recipe['saved'] == 1 ? 0 : 1;
    });

    // Try updating the server with the new bookmark status
    try {
      await recipeController.toggleBookmark(recipe['id']);

      // Show a success message (e.g., recipe saved or unsaved)
      if (recipe['saved'] == 1) {
        showToast(message: 'Recipe saved!');
      } else {
        showToast(message: 'Recipe unsaved!');
      }

      // Re-fetch the updated list of recipes to reflect the server state
      fetchRecipes();
    } catch (err) {
      // If there is an error (e.g., network issue), revert the local toggle
      setState(() {
        recipe['saved'] = recipe['saved'] == 1 ? 0 : 1;
      });

      // Show an error message
      showToast(message: 'Failed to update bookmark. Please try again.');
      print('Error toggling bookmark: $err');
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
          "Recipes Based on Your Kitchen",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : recipes.isEmpty
                  ? const Center(child: Text("No recipes found."))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = recipes[index];
                              bool isSaved = recipe['saved'] == 1;

                              return GestureDetector(
                                onTap: () {
                                  // Navigate to the recipe details page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RecipePage(recipe: recipe),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  margin: const EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        // Thumbnail Image
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            recipe['thumbnail_url'] ?? '',
                                            height: 250,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.image,
                                                        size: 80),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Name
                                        Text(
                                          recipe['name'] ?? "Unknown Recipe",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Missing Ingredients Chip
                                        if (recipe['missing_count'] != null &&
                                            recipe['missing_count'] > 0)
                                          Chip(
                                            label: Text(
                                              "${recipe['missing_count']} Missing Ingredients",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        const SizedBox(height: 10),
                                        // Calories, Timer, and Save Icon
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.local_fire_department,
                                                  color: Colors.orange,
                                                ),
                                                Text(
                                                    "${recipe['calories']} Calories"),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.timer,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                    "${recipe['cook_time_minutes']} Minutes"),
                                              ],
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                isSaved
                                                    ? Icons.bookmark
                                                    : Icons.bookmark_border,
                                                color: const Color(0xff00b473),
                                              ),
                                              onPressed: () {
                                                _toggleBookmark(recipe);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Pagination Controls
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed:
                                    currentPage > 1 ? goToPreviousPage : null,
                                child: const Text("Prev"),
                              ),
                              ElevatedButton(
                                onPressed:
                                    recipes.isNotEmpty ? goToNextPage : null,
                                child: const Text("Next"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
    );
  }
}
