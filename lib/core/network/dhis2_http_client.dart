// lib/core/network/dhis2_http_client.dart

import 'package:dio/dio.dart';
import 'dhis2_auth_interceptor.dart';

class Dhis2HttpClient {
  late final Dio _dio;
  final Dhis2AuthInterceptor _authInterceptor = Dhis2AuthInterceptor();

  Dhis2HttpClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10), // Terminate slow cellular connections
        receiveTimeout: const Duration(seconds: 15),
      ),
    );

    // Register our automated security interceptor into Dio's pipeline ecosystem
    _dio.interceptors.add(_authInterceptor);
  }

  // Getter to pass this safe instance cleanly to our analytical services
  Dio get client => _dio;

  // Expose the credential update manager to the Auth provider layer
  Dhis2AuthInterceptor get authInterceptor => _authInterceptor;
}