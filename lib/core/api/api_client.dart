import 'dart:convert';
import 'package:firebase_login/core/api/unauthorize_handler.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({required this.baseUrl, required this.defaultHeaders});

  Future<http.Response> _handleRequest(
      Future<http.Response> Function() request) async {
    try {
      final response = await request();

      // Check if the status code is 401 or if the response is HTML (indicating unauthorized state)
      if (response.statusCode == 401 || _isHtmlResponse(response)) {
        UnauthorizedHandler()
            .handleUnauthorized(); // Trigger the global handler for unauthorized response
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  bool _isHtmlResponse(http.Response response) {
    // Check if the content-type is HTML
    return response.headers['content-type']?.contains('text/html') ?? false;
  }

  Future<http.Response> get(String endpoint, {String? token}) async {
    final headers = {
      ...defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return _handleRequest(() async {
      return await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      );
    });
  }

  Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body, String? token}) async {
    final headers = {
      ...defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return _handleRequest(() async {
      return await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
    });
  }
}
