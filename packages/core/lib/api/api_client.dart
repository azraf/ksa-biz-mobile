import 'dart:async';
import 'dart:convert';
import 'dart:math' show min;

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'api_exception.dart';

typedef SendProgressCallback = void Function(int sent, int total);
typedef UnauthorizedCallback = void Function();

class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? AppConfig.defaultApiBaseUrl;

  static const defaultTimeout = Duration(seconds: 30);

  final http.Client _client;
  String _baseUrl;
  String? _token;
  UnauthorizedCallback? onUnauthorized;

  String get baseUrl => _baseUrl;

  void setBaseUrl(String url) {
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }

  void setToken(String? token) => _token = token;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
    Duration? timeout,
  }) async {
    final uri = _uri(path, query);
    final response = await _withTimeout(
      _client.get(uri, headers: _headers()),
      timeout,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? query,
    Duration? timeout,
  }) async {
    final uri = _uri(path, query);
    final response = await _withTimeout(
      _client.post(
        uri,
        headers: _headers(),
        body: body == null ? null : jsonEncode(body),
      ),
      timeout,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    Duration? timeout,
  }) async {
    final uri = _uri(path);
    final response = await _withTimeout(
      _client.patch(
        uri,
        headers: _headers(),
        body: body == null ? null : jsonEncode(body),
      ),
      timeout,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Duration? timeout,
  }) async {
    final uri = _uri(path);
    final response = await _withTimeout(
      _client.put(
        uri,
        headers: _headers(),
        body: body == null ? null : jsonEncode(body),
      ),
      timeout,
    );
    return _handleResponse(response);
  }

  Future<void> delete(String path, {Duration? timeout}) async {
    final uri = _uri(path);
    final response = await _withTimeout(_client.delete(uri, headers: _headers()), timeout);
    if (response.statusCode == 204) return;
    _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteJson(String path, {Duration? timeout}) async {
    final uri = _uri(path);
    final response = await _withTimeout(_client.delete(uri, headers: _headers()), timeout);
    if (response.statusCode == 204) return {};
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> uploadMultipart(
    String path, {
    required String fileField,
    required List<int> bytes,
    required String filename,
    Map<String, String>? fields,
    SendProgressCallback? onSendProgress,
    Duration? timeout,
  }) async {
    final uri = _uri(path);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    if (_token != null && _token!.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $_token';
    }
    if (fields != null) {
      request.fields.addAll(fields);
    }
    Stream<List<int>> byteStream() async* {
      const chunkSize = 8192;
      var sent = 0;
      for (var i = 0; i < bytes.length; i += chunkSize) {
        final end = min(i + chunkSize, bytes.length);
        sent = end;
        onSendProgress?.call(sent, bytes.length);
        yield bytes.sublist(i, end);
      }
    }
    request.files.add(http.MultipartFile(
      fileField,
      byteStream(),
      bytes.length,
      filename: filename,
    ));
    final streamed = await _withTimeout(_client.send(request), timeout);
    final response = await _withTimeout(http.Response.fromStream(streamed), timeout);
    return _handleResponse(response);
  }

  Future<T> _withTimeout<T>(Future<T> future, Duration? timeout) {
    return future.timeout(
      timeout ?? defaultTimeout,
      onTimeout: () => throw ApiException('Request timed out', statusCode: 408),
    );
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$_baseUrl$normalized').replace(queryParameters: query);
  }

  Map<String, String> _headers() {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      onUnauthorized?.call();
    }

    final body = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final message = body['message']?.toString() ??
        (body['errors'] is Map ? _firstValidationError(body['errors'] as Map) : null) ??
        'Request failed (${response.statusCode})';

    throw ApiException(
      message,
      statusCode: response.statusCode,
      errors: body['errors'] is Map ? Map<String, dynamic>.from(body['errors'] as Map) : null,
    );
  }

  String? _firstValidationError(Map errors) {
    for (final entry in errors.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value is String) return value;
    }
    return null;
  }
}
