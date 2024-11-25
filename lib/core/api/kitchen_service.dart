import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../../global/common/toast.dart';
import 'package:firebase_login/core/extensions/string_extensions.dart';

class KitchenService {
  final ApiClient apiClient;

  KitchenService({required this.apiClient});

  Future<List<Map<String, dynamic>>> getAvailableIngredients(String token, {int page = 1}) async {
    try {
      final response = await apiClient.post(
        'kitchen/ingredient/add?page=$page',
        token: token,
      );

      if (response.statusCode == 200 && response.body.isValidJson()) {
        final data = json.decode(response.body);
        print('Received data for page $page: $data');

        if (data is Map<String, dynamic> &&
            data.containsKey('ingredients') &&
            data['ingredients'] is Map<String, dynamic>) {

          final ingredientsData = data['ingredients'];
          final ingredientsList = ingredientsData['data'] ?? [];

          return List<Map<String, dynamic>>.from(ingredientsList);
        } else {
          print('No ingredients found for page $page');
          return [];
        }
      } else {
        print('Failed to load available ingredients. Status code: ${response.statusCode}');
        showToast(message: 'Failed to load available ingredients');
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      showToast(message: 'An error occurred: $e');
      return [];
    }
  }

  Future<void> toggleIngredient(int ingredientId, String token) async {
    try {
      final response = await apiClient.post('kitchen/ingredient/toggle/$ingredientId', token: token);
      if (response.statusCode == 200 && response.body.isValidJson()) {
        showToast(message: 'Ingredient toggled successfully');
      } else {
        final errorData = json.decode(response.body);
        showToast(message: errorData['message'] ?? 'Failed to toggle ingredient');
      }
    } catch (e) {
      showToast(message: 'An error occurred: $e');
    }
  }

  Future<List<String>> getKitchenItems(String token) async {
    try {
      final response = await apiClient.get(
        'kitchen',
        token: token,
      );

      if (response.statusCode == 200 && response.body.isValidJson()) {
        final data = json.decode(response.body);
        print('Received kitchen items: $data');

        if (data is Map<String, dynamic> && data.containsKey('ingredients')) {
          final ingredients = data['ingredients'] as List;
          return ingredients.map((ingredient) => ingredient['name'] as String).toList();
        } else {
          print('Unexpected data format');
          return [];
        }
      } else {
        print('Failed to load kitchen items. Status code: ${response.statusCode}');
        showToast(message: 'Failed to load kitchen items');
        return [];
      }
    } catch (e) {
      print('An error occurred: $e');
      showToast(message: 'An error occurred: $e');
      return [];
    }
  }
}