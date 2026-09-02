import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';

class ApiService {
  ApiService({
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
                sendTimeout: const Duration(seconds: 10),
                headers: {
                  'Accept': 'application/json',
                },
              ),
            );

  final Dio _dio;

  Dio get client => _dio;

  Future<Map<String, dynamic>> checkHealth() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiConstants.apiPrefix}/health',
    );

    if (response.statusCode != 200 || response.data == null) {
      throw ApiException(
        message: 'LocalMind backend returned an invalid response.',
        statusCode: response.statusCode,
      );
    }

    return response.data!;
  }
}

class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() {
    if (statusCode == null) {
      return message;
    }

    return '$message (HTTP $statusCode)';
  }
}