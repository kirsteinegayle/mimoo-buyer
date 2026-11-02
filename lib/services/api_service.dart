import 'dart:convert';
import 'package:http/http.dart' as http;

/// Central HTTP client for all calls to the mimoo Laravel backend.
///
/// Usage:
///   final data = await ApiService.get('/products');
///   final res  = await ApiService.post('/auth/login', body: {...});
///
/// For endpoints that require authentication, set [ApiService.token]
/// after the user logs in — it will be sent as a Bearer token on every
/// subsequent request. Clear it on logout.
class ApiService {
  ApiService._();

  /// Base URL for the Laravel API.
  ///
  /// ── Development ──────────────────────────────────────────────────────────
  /// When running on a physical Android device, use your machine's LAN IP
  /// instead of localhost (10.0.2.2 works for the Android emulator):
  ///
  ///   Android emulator : 'http://10.0.2.2:8000/api'
  ///   iOS simulator    : 'http://127.0.0.1:8000/api'
  ///   Physical device  : 'http://192.168.x.x:8000/api'  ← your PC's LAN IP
  ///
  /// ── Production ───────────────────────────────────────────────────────────
  ///   static const String baseUrl = 'https://mimoo.bond/api';
  ///
  /// Start the Laravel dev server with:
  ///   php artisan serve --host=0.0.0.0 --port=8000
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  /// Bearer token for authenticated requests.
  /// Set this after login, clear on logout.
  static String? token;

  /// Default request timeout.
  static const Duration _timeout = Duration(seconds: 15);

  // ── Headers ──────────────────────────────────────────────────────────────

  static Map<String, String> _headers({bool includeAuth = true}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (includeAuth && token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Builds the full URL for a given endpoint path.
  static Uri _uri(String endpoint) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$path');
  }

  // ── HTTP methods ──────────────────────────────────────────────────────────

  /// GET request. Returns decoded JSON (List or Map).
  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    bool includeAuth = true,
  }) async {
    final uri = _uri(endpoint).replace(queryParameters: queryParameters);
    final res = await http
        .get(uri, headers: _headers(includeAuth: includeAuth))
        .timeout(_timeout);
    return _handleResponse(res);
  }

  /// POST request. [body] is encoded as JSON. Returns decoded JSON.
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final res = await http
        .post(
          _uri(endpoint),
          headers: _headers(includeAuth: includeAuth),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_timeout);
    return _handleResponse(res);
  }

  /// PUT request. [body] is encoded as JSON. Returns decoded JSON.
  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final res = await http
        .put(
          _uri(endpoint),
          headers: _headers(includeAuth: includeAuth),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_timeout);
    return _handleResponse(res);
  }

  /// DELETE request. Returns decoded JSON (may be empty map for 204).
  static Future<dynamic> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final res = await http
        .delete(
          _uri(endpoint),
          headers: _headers(includeAuth: includeAuth),
        )
        .timeout(_timeout);
    return _handleResponse(res);
  }

  // ── Response handling ─────────────────────────────────────────────────────

  /// Decodes the response body as JSON and throws [ApiException] on non-2xx.
  static dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body);
    }

    // Try to extract an error message from the Laravel error response.
    String message;
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) {
        // Laravel validation errors: {"message": "...", "errors": {...}}
        message = decoded['message'] as String? ?? 'Request failed';
      } else if (decoded is List) {
        message = decoded.toString();
      } else {
        message = decoded.toString();
      }
    } catch (_) {
      message = 'Request failed (${res.statusCode})';
    }

    throw ApiException(
      statusCode: res.statusCode,
      message: message,
      body: res.body,
    );
  }
}

/// Thrown when the API returns a non-2xx status code.
class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.body,
  });

  final int statusCode;
  final String message;
  final String? body;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
