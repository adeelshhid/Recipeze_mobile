import '../../core/api/kitchen_service.dart';
import '../../core/api/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KitchenController {
  final KitchenService kitchenService = KitchenService(
    apiClient: ApiClient(
      baseUrl: 'http://15.237.250.139/api/v1/recipeze',
      defaultHeaders: {'Content-Type': 'application/json'},
    ),
  );

  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Map<String, dynamic>>> getAvailableIngredients(
      {int page = 1}) async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      print('Fetching ingredients for page: $page with token: $token');
      List<Map<String, dynamic>> ingredients =
          await kitchenService.getAvailableIngredients(
        token,
        page: page,
      );
      print('API response: $ingredients');
      return ingredients;
    } catch (e) {
      print('Error fetching ingredients: $e');
      throw Exception('Failed to load available ingredients: $e');
    }
  }

  Future<List> getAllIngredients() async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      print('Fetching ingredients with token: $token');
      List ingredients = await kitchenService.getAllIngredients(token);
      print('API response: $ingredients');
      return ingredients;
    } catch (e) {
      print('Error fetching ingredients: $e');
      throw Exception('Failed to load available ingredients: $e');
    }
  }

  Future<void> toggleIngredient(int ingredientId) async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      await kitchenService.toggleIngredient(ingredientId, token);
    } catch (e) {
      print('Error toggling ingredient: $e');
      throw Exception('Failed to toggle ingredient: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getKitchenItems() async {
    String? token = await _getToken();
    if (token == null) throw Exception('No token found. Please log in again.');

    try {
      print('Fetching kitchen items with token: $token');
      List<Map<String, dynamic>> kitchenItems =
          await kitchenService.getKitchenItems(token);
      print('API response: $kitchenItems');
      return kitchenItems;
    } catch (e) {
      print('Error fetching kitchen items: $e');
      throw Exception('Failed to load kitchen items: $e');
    }
  }
}
