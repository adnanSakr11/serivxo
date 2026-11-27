import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../error/exceptions.dart';
import '../logging/app_logger.dart';

class AppHttpClient {
  final http.Client _client;

  AppHttpClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    Uri url, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      AppLogger.d('GET ${url.toString()}');
      final response = await _client
          .get(url, headers: {
            'User-Agent': AppConfig.nominatimUserAgent,
            ...?headers,
          })
          .timeout(timeout);
      return _handleResponse(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<Map<String, dynamic>> post(
    Uri url, {
    Map<String, String>? headers,
    Map<String, String>? body,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      AppLogger.d('POST ${url.toString()}');
      final response = await _client
          .post(url, headers: headers, body: body)
          .timeout(timeout);
      return _handleResponse(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Future<List<dynamic>> getList(
    Uri url, {
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      AppLogger.d('GET LIST ${url.toString()}');
      final response = await _client
          .get(url, headers: {
            'User-Agent': AppConfig.nominatimUserAgent,
            ...?headers,
          })
          .timeout(timeout);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      }
      throw NetworkException('HTTP ${response.statusCode}');
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw NetworkException('HTTP ${response.statusCode}');
  }

  void dispose() => _client.close();
}