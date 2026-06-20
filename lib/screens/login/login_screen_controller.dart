import 'dart:convert';
import 'package:dhis_2/Notifications/app_loaders.dart';
import 'package:dhis_2/Notifications/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final _box = GetStorage();

  // Reactive loading state for the UI
  var isLoading = false.obs;

  var userData = jsonDecode('{}');

  // Base URL for the public sandbox (Must use HTTPS for security)
  final String baseUrl = 'https://play.im.dhis2.org/dev';

  // UI Input tracking controllers
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Non-hardcoded localization and UI Copy properties
  final String appBarTitle = "DHIS2 Engine Authentication";
  final String labelUrl = "DHIS2 Server Base URL";
  final String labelUsername = "Username";
  final String labelPassword = "Password";
  final String btnLogin = "Login";
  final String loadingMessage = "Contacting gateway instance server...";

  // Alert Text Properties
  final String titleSuccess = "Success";
  final String titleError = "Authentication Error";
  final String errEmptyFields =
      "All credential parameters are strictly required.";
  final String msgLoginSuccess = "Access authorization granted successfully.";
  final String errWrongCredentials =
      "The username or password combination is incorrect.";
  final String errUnauthorized =
      "Invalid credentials profile or unauthorized access.";
  final String errServerError =
      "Target gateway system responded with an internal status code error (500).";
  final String errUnexpected =
      "Could not establish server handshake connection. Check URL syntax.";

  @override
  void onInit() {
    super.onInit();
    // Pre-populating default active reference endpoint path
    urlController.text = "https://play.im.dhis2.org/dev";
  }

  @override
  void onClose() {
    urlController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Communicates with DHIS2 Web API endpoint utilizing standard Basic Authentication headers
  Future<void> loginUser() async {}

  Future<bool> login(String username, String password) async {
    try {
      // isLoading.value = true;
      AppLoaders.showLoadingOverlay(message: "authenticating..");

      // 1. Format credentials string as "username:password"
      String rawCredentials = '$username:$password';

      // 2. Convert to bytes and encode into Base64
      List<int> stringBytes = utf8.encode(rawCredentials);
      String base64Token = base64.encode(stringBytes);

      // 3. Compile the standard HTTP Authorization header
      String authHeader = 'Basic $base64Token';

      // 4. Send GET request to the user profile endpoint
      final response = await http.get(
        Uri.parse('$baseUrl/api/me.json'),
        headers: {'Authorization': authHeader, 'Accept': 'application/json'},
      );

      // 5. Check if the server accepted the credentials (200 OK)
      if (response.statusCode == 200) {
        userData = jsonDecode(response.body);
        // Save token and name to local storage for stateless persistence
        await _box.write('auth_credentials', authHeader);
        await _box.write('user_name', userData['name']);
        await _box.write('isLoggedIn', true);

        return true;
      } else {
        AppLoaders.hideLoadingOverlay();
        AppSnackbars.showError(
          title: "Login Failed",
          message: 'Invalid username or password',
          position: SnackPosition.TOP,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Network connection issue: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Retrieve the saved header to append to your subsequent dashboard API requests
  String get authHeader => _box.read('auth_credentials') ?? '';

  void logout() {
    _box.remove('auth_credentials');
    _box.remove('user_name');
    _box.write('is_logged_in', false);
    // Navigate back to login screen
  }
}
