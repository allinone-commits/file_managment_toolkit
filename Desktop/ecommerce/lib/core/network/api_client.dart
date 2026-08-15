import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client;
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('${ApiConstants.baseUrl}$path');

  Future<dynamic> get(String path) async {
    final res = await _client.get(_uri(path));
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body);
    }
    throw ApiException(res.statusCode, res.body);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    final res = await _client.post(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body ?? {}),
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return json.decode(res.body);
    }
    throw ApiException(res.statusCode, res.body);
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String body;
  ApiException(this.statusCode, this.body);
  @override
  String toString() => 'ApiException: statusCode=\$statusCode body=\$body';
}
