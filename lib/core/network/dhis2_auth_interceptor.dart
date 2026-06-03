// lib/core/network/dhis2_auth_interceptor.dart

import 'dart:convert';
import 'package:dio/dio.dart';

class Dhis2AuthInterceptor extends Interceptor {
  String? _serverUrl;
  String? _username;
  String? _password;

  /// Updates the internal credentials immediately after a successful login session
  void updateCredentials({
    required String serverUrl,
    required String username,
    required String password,
  }) {
    _serverUrl = serverUrl;
    _username = username;
    _password = password;
  }

  /// Clears credentials out of memory on logout
  void clearCredentials() {
    _serverUrl = null;
    _username = null;
    _password = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // If credentials haven't been configured yet (e.g., app is still on login screen), pass through
    if (_serverUrl == null || _username == null || _password == null) {
      return handler.next(options);
    }

    // 1. Prepend the dynamic server base URL dynamically if it's missing
    if (!options.path.startsWith('http')) {
      options.baseUrl = _serverUrl!;
    }

    // 2. Generate the Base64 encoding string required by standard DHIS2 authentication
    final rawCredentials = '$_username:$_password';
    final bytes = utf8.encode(rawCredentials);
    final base64Credentials = base64.encode(bytes);

    // 3. Auto-inject headers into the outgoing HTTP package configuration parameters
    options.headers['Authorization'] = 'Basic $base64Credentials';
    options.headers['Accept'] = 'application/json';

    print('📡 interceptor Outgoing Request: ${options.baseUrl}${options.path}');
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Global Error Trap: Intercept 401 Unauthorized errors (Session Expirations)
    if (err.response?.statusCode == 401) {
      print('🚨 Session Unauthorized or Expired. Triggering logout flow cleanup.');
      clearCredentials();
      // In production, insert a deep broadcast stream/event here to kick the UI back to LoginScreen
    }
    return handler.next(err);
  }
}