// lib/features/auth/presentation/controllers/auth_provider.dart

import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
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
  Future<bool> login({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Clean up trailing slashes from user URL inputs
      final formattedUrl = serverUrl.trim().replaceAll(RegExp(r'\/+$'), '');
      
      // Basic validation format check
      if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
        throw Exception('Server URL must start with http:// or https://');
      }

      // Simulating network handshake check against DHIS2 /api/me endpoint
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));

      _isLoading = false;
      notifyListeners();
      return true; // Authentication successful
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}