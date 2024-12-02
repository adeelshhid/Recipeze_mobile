import 'dart:convert';
import 'package:firebase_login/global/common/toast.dart';

import 'api_client.dart';
import 'package:firebase_login/core/extensions/string_extensions.dart';

class RecipeService {
  final ApiClient apiClient;

  RecipeService({required this.apiClient});

  Future<Map<String, List>> getAllRecipeseByPage(String token,
      {int page = 1}) async {
    try {
      final response = await apiClient.get(
        'recipes/generated?page=$page',
        token: token,
      );

      if (response.statusCode == 200 && response.body.isValidJson()) {
        final data = json.decode(response.body);
        print('Received Recipes: $data');

        // Extract the data from "paginatedRecipes" and map it into a list of recipes
        final savedRecIds = data['savedRecipeIds'];
        final paginatedRecipes = data['paginatedRecipes']['data'];
        if (paginatedRecipes is List) {
          return {'recipes': paginatedRecipes, 'savedRecIds': savedRecIds};
        } else {
          final recipeList = paginatedRecipes.values.toList();
          return {'recipes': recipeList, 'savedRecIds': savedRecIds};
        }
      } else {
        print(
            'Failed to load kitchen items. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('An error occurred while fetching kitchen items.');
    }
  }

  Future<List> getSavedRecipes(String token, int page) async {
    try {
      final response = await apiClient.get(
        'recipes/saved?page=$page',
        token: token,
      );

      if (response.statusCode == 200 && response.body.isValidJson()) {
        final data = json.decode(response.body);
        print('Received Saved Recipes: $data');
        final list = data['savedRecipes']['data'];
        return list;
      } else {
        print('Failed to load Recipes. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('An error occurred while fetching Recipes.');
    }
  }

  Future<Map<String, dynamic>> getRecById(String token, int id) async {
    try {
      final response = await apiClient.get(
        'recipes/$id',
        token: token,
      );

      if (response.statusCode == 200 && response.body.isValidJson()) {
        final data = json.decode(response.body);
        print('Received Recipe By Id:$id \n\n\n: $data');
        final rec = data['recipe'];
        return rec;
      } else {
        print('Failed to load Recipes. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('An error occurred: $e');
      throw Exception('An error occurred while fetching Recipes.');
    }
  }

  Future<void> toggleBookmark(int id, String token) async {
    try {
      final response =
          await apiClient.post('recipes/bookmark/$id', token: token);
      if (response.statusCode == 200 && response.body.isValidJson()) {
        // showToast(message: 'Ingredient toggled successfully');
      } else {
        final errorData = json.decode(response.body);
        showToast(message: errorData['message'] ?? 'Failed to toggle bookmark');
      }
    } catch (e) {
      showToast(message: 'An error occurred: $e');
    }
  }
}
