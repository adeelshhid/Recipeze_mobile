import 'package:firebase_login/core/api/recipe_service.dart';

import '../../core/api/kitchen_service.dart';
import '../../core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipeController {
  final RecipeService recipeService = RecipeService(
    apiClient: ApiClient(
      baseUrl: 'http://15.237.250.139/api/v1/recipeze',
      defaultHeaders: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, List>> getRecByPage({int page = 1}) async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      print('Fetching Recipes for page: $page with token: $token');
      Map<String, List> recipes = await recipeService.getAllRecipeseByPage(
        token,
        page: page,
      );
      print('API response: $recipes');
      return recipes;
    } catch (e) {
      print('Error fetching recipes: $e');
      throw Exception('Failed to load available recipes: $e');
    }
  }

  Future<Map<String, dynamic>> getRec(int id) async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      print('Fetching Recipe by id: $id with token: $token');
      Map<String, dynamic> recipe = await recipeService.getRecById(token, id);
      print('API response: $recipe');
      return recipe;
    } catch (e) {
      print('Error fetching recipes: $e');
      throw Exception('Failed to load available recipes: $e');
    }
  }

  Future<List> savedRec({int page = 1}) async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      print('Fetching saved Recipes with token: $token');
      List recipes = await recipeService.getSavedRecipes(token, page);
      print('API response for recipes: $recipes');
      return recipes;
    } catch (e) {
      print('Error fetching recipes: $e');
      throw Exception('Failed to load available recipes: $e');
    }
  }

  Future<void> toggleBookmark(int id) async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      await recipeService.toggleBookmark(id, token);
    } catch (e) {
      print('Error toggling ingredient: $e');
      throw Exception('Failed to toggle ingredient: $e');
    }
  }

  // Future<List<Map<String, dynamic>>> getKitchenItems() async {
  //   String? token = await _getToken();
  //   if (token == null) throw Exception('No token found. Please log in again.');

  //   try {
  //     print('Fetching kitchen items with token: $token');
  //     List<Map<String, dynamic>> kitchenItems =
  //         await kitchenService.getKitchenItems(token);
  //     print('API response: $kitchenItems');
  //     return kitchenItems;
  //   } catch (e) {
  //     print('Error fetching kitchen items: $e');
  //     throw Exception('Failed to load kitchen items: $e');
  //   }
  // }
}
