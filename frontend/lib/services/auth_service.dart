import 'package:dio/dio.dart';

import '../models/user.dart';
import 'api_service.dart';

class AuthResult {
  const AuthResult({
    required this.token,
    required this.user,
  });

  final String token;
  final User user;
}

class AuthService {
  AuthService({
    ApiService? apiService,
  }) : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  String? _accessToken;

  String? get accessToken => _accessToken;

  bool get isAuthenticated => _accessToken != null;

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.client.post<Map<String, dynamic>>(
        '/api/auth/register',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        },
      );

      return _parseAuthResponse(response.data);
    } on DioException catch (error) {
      throw AuthException(_extractMessage(error));
    }
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.client.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      return _parseAuthResponse(response.data);
    } on DioException catch (error) {
      throw AuthException(_extractMessage(error));
    }
  }

  Future<User> getCurrentUser() async {
    final token = _accessToken;

    if (token == null) {
      throw const AuthException('You are not logged in.');
    }

    try {
      final response = await _apiService.client.get<Map<String, dynamic>>(
        '/api/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = response.data;

      if (data == null) {
        throw const AuthException('Invalid profile response.');
      }

      return User.fromJson(data);
    } on DioException catch (error) {
      throw AuthException(_extractMessage(error));
    }
  }

  void logout() {
    _accessToken = null;
  }

  AuthResult _parseAuthResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const AuthException('Authentication response was empty.');
    }

    final token = data['access_token'];
    final userData = data['user'];

    if (token is! String || userData is! Map<String, dynamic>) {
      throw const AuthException('Authentication response was invalid.');
    }

    _accessToken = token;

    return AuthResult(
      token: token,
      user: User.fromJson(userData),
    );
  }

  String _extractMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];

      if (detail is String) {
        return detail;
      }

      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;

        if (first is Map<String, dynamic>) {
          final message = first['msg'];

          if (message is String) {
            return message;
          }
        }
      }
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return 'Unable to connect to the LocalMind backend.';
    }

    return 'Authentication failed. Please try again.';
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}