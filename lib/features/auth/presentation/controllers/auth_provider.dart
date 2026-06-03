// lib/features/auth/presentation/controllers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:dhis_2/core/network/dhis2_http_client.dart';

class AuthProvider extends ChangeNotifier {
  final Dhis2HttpClient _networkClient; // Pass via constructor dependency injection

  AuthProvider(this._networkClient);
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  /// Toggles password masking character visibility (the eye icon)
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Sends validation credentials to the underlying secure network layer
 // In lib/features/auth/presentation/controllers/auth_provider.dart
// (Update the login implementation to receive and call Dhis2HttpClient)



Future<bool> login({
  required String serverUrl, 
  required String username, 
  required String password,
}) async {
  _isLoading = true;
  notifyListeners();

  try {
    final cleanUrl = serverUrl.trim().replaceAll(RegExp(r'\/+$'), '');
    
    // Set credentials in the interceptor first so the verification call uses them
    _networkClient.authInterceptor.updateCredentials(
      serverUrl: cleanUrl, 
      username: username, 
      password: password,
    );

    // Fire an initial light query directly against the server to check credential validity
    final response = await _networkClient.client.get('$cleanUrl/api/me?fields=id,displayName');
    
    if (response.statusCode == 200) {
      _isLoading = false;
      notifyListeners();
      return true; // Success!
    }
    throw Exception('Authentication failed with status code: ${response.statusCode}');
  } catch (e) {
    _networkClient.authInterceptor.clearCredentials(); // Wipe failed attempts
    _isLoading = false;
    _errorMessage = 'Invalid instance coordinates, username, or account password.';
    notifyListeners();
    return false;
  }
}}