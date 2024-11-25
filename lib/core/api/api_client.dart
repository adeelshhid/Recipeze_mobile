// core/api/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({required this.baseUrl, required this.defaultHeaders});

  Future<http.Response> get(String endpoint, {String? token}) async {
    final headers = {
      ...defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
    );
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body, String? token}) async {
    final headers = {
      ...defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }
}
