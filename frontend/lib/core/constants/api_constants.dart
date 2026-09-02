import 'package:flutter/foundation.dart';

class ApiConstants {
  ApiConstants._();

  static const String apiPrefix = '/api';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    return 'http://10.0.2.2:8000';
  }

  static String get healthUrl => '$baseUrl$apiPrefix/health';
}