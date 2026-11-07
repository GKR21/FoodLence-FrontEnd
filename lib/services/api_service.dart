import 'dart:convert';
import 'dart:io';
import '../models/profile_model.dart';
import 'scan_service.dart';

/// Central API client connecting the Flutter mobile app to the FoodLence FastAPI backend.
///
/// Implements endpoints across:
/// - Authentication (/api/v1/auth)
/// - Dietary Profiles (/api/v1/profiles)
/// - Inference & Allergen Evaluation (/api/v1/analyze)
/// - Scan History (/api/v1/history)
/// - Allergen Taxonomy (/api/v1/allergens)
class ApiService {
  static final ApiService _instance = ApiService._internal();
  static ApiService get instance => _instance;

  factory ApiService() => _instance;

  ApiService._internal();

  /// Default backend base URL: 10.0.2.2 for Android emulator, localhost for desktop/testing
  String _baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:8000/api/v1'
      : 'http://localhost:8000/api/v1';

  String? _authToken;

  String get baseUrl => _baseUrl;
  String? get authToken => _authToken;

  void configure({required String baseUrl, String? authToken}) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    if (authToken != null) {
      _authToken = authToken;
    }
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  // ---------------------------------------------------------------------------
  // Generic HTTP Helper
  // ---------------------------------------------------------------------------

  Future<dynamic> _sendRequest({
    required String method,
    required String path,
    Map<String, dynamic>? body,
    Map<String, String>? queryParams,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final client = HttpClient();
    client.connectionTimeout = timeout;

    try {
      final uriStr = '$_baseUrl$path';
      var uri = Uri.parse(uriStr);
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      HttpClientRequest request;
      switch (method.toUpperCase()) {
        case 'POST':
          request = await client.postUrl(uri);
          break;
        case 'PUT':
          request = await client.putUrl(uri);
          break;
        case 'DELETE':
          request = await client.deleteUrl(uri);
          break;
        case 'GET':
        default:
          request = await client.getUrl(uri);
          break;
      }

      request.headers.contentType = ContentType.json;
      if (_authToken != null && _authToken!.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_authToken');
      }

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (responseBody.isEmpty) {
          return null;
        }
        return jsonDecode(responseBody);
      } else {
        throw HttpException(
          'API Error [${response.statusCode}]: $responseBody',
          uri: uri,
        );
      }
    } finally {
      client.close();
    }
  }

  // ---------------------------------------------------------------------------
  // Authentication Endpoints
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final res = await _sendRequest(
      method: 'POST',
      path: '/auth/register',
      body: {
        'email': email,
        'password': password,
        'full_name': fullName,
      },
    );
    if (res is Map<String, dynamic> && res.containsKey('access_token')) {
      _authToken = res['access_token'] as String;
    }
    return res as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await _sendRequest(
      method: 'POST',
      path: '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    if (res is Map<String, dynamic> && res.containsKey('access_token')) {
      _authToken = res['access_token'] as String;
    }
    return res as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // Dietary Profiles Endpoints
  // ---------------------------------------------------------------------------

  Future<List<DietaryProfile>> fetchProfiles() async {
    final res = await _sendRequest(
      method: 'GET',
      path: '/profiles/',
    );
    if (res is List) {
      return res.map((item) => DietaryProfile.fromJson(item as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<DietaryProfile> createProfile(DietaryProfile profile) async {
    final res = await _sendRequest(
      method: 'POST',
      path: '/profiles/',
      body: profile.toJson(),
    );
    return DietaryProfile.fromJson(res as Map<String, dynamic>);
  }

  Future<DietaryProfile> updateProfile(DietaryProfile profile) async {
    final res = await _sendRequest(
      method: 'PUT',
      path: '/profiles/${profile.id}',
      body: profile.toJson(),
    );
    return DietaryProfile.fromJson(res as Map<String, dynamic>);
  }

  Future<void> deleteProfile(String profileId) async {
    await _sendRequest(
      method: 'DELETE',
      path: '/profiles/$profileId',
    );
  }

  // ---------------------------------------------------------------------------
  // Inference & Food Label Analysis
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> analyzeLabel({
    required ScanPayload payload,
  }) async {
    final res = await _sendRequest(
      method: 'POST',
      path: '/analyze',
      body: payload.toJson(),
    );
    return res as Map<String, dynamic>;
  }

  // ---------------------------------------------------------------------------
  // Knowledge Base & Allergen Taxonomy
  // ---------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchSupportedAllergens() async {
    final res = await _sendRequest(
      method: 'GET',
      path: '/allergens',
    );
    if (res is List) {
      return res.cast<Map<String, dynamic>>();
    }
    return [];
  }

  // ---------------------------------------------------------------------------
  // Scan History
  // ---------------------------------------------------------------------------

  Future<List<dynamic>> fetchHistory({int limit = 20, int offset = 0}) async {
    final res = await _sendRequest(
      method: 'GET',
      path: '/history/',
      queryParams: {
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );
    if (res is List) {
      return res;
    }
    return [];
  }
}
