// core/api/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_login/global/common/toast.dart';


class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({required this.baseUrl, required this.defaultHeaders});

  Future<http.Response> get(String endpoint) async {
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: defaultHeaders,
    );
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: defaultHeaders,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    return await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: defaultHeaders,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> delete(String endpoint) async {
    return await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: defaultHeaders,
    );
  }
}
