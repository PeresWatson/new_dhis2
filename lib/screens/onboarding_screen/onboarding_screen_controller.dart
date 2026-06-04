import 'package:dhis_2/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  // Reactive state properties
  final RxBool isInitializing = true.obs;
  final RxBool isLoggingIn = false.obs;
  final RxInt currentPage = 0.obs;

  // Text Editing Controllers managed inside GetX Lifecycle
  final TextEditingController urlController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PageController pageController = PageController();

  // Fully isolated UI Copy / Content Strings (No hardcoded values in UI)
  final String textLoadingEngine = "Initializing engine local cache...";
  final String textDefaultInstanceUrl = "https://play.dhis2.org/40.0.0";
  final String textGetStarted = "Get Started";
  final String textNext = "Next";
  final String textGatewayAccess = "DHIS2 Gateway Access";
  final String textLabelUrl = "DHIS2 Instance URL";
  final String textLabelUsername = "Username";
  final String textLabelPassword = "Password";
  final String textButtonAuthenticate = "Authenticate";
  final String textAlertTitleError = "Error Alert";
  final String textAlertTitleSuccess = "Success";
  final String textErrorEmptyFields =
      "Please specify all authentication credentials.";
  final String textSuccessLogin =
      "Authentication successful! Welcome to DHIS2.";
  final String textErrorCredentials =
      "Invalid combination of username and password.";
  final String textErrorServer =
      "The target server responded with an internal 500 status code error.";
  final String textErrorCatch = "Login runtime failure occurred.";

  // Static onboarding assets configuration data
  final List<Map<String, String>> onboardingData = [
    {
      "title": "DHIS2 Mobile Client",
      "description":
          "Access your health information systems data instantly, tailored for local field operations.",
    },
    {
      "title": "Offline-First Synchronization",
      "description":
          "Collect data smoothly in remote areas. The engine caches everything locally until you reconnect.",
    },
    {
      "title": "Secure Tracker & Aggregates",
      "description":
          "Manage aggregate datasets, events, and tracked entity instances securely on your device.",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    urlController.text = textDefaultInstanceUrl;
    stubFakeInitialization();
  }

  @override
  void onClose() {
    pageController.dispose();
    urlController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Base setup placeholder
  void stubFakeInitialization() {
    isInitializing.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isInitializing.value = false;
    });
  }

  /// Handles onboarding navigation action button taps
  void handleNextAction() async{
    if (currentPage.value == onboardingData.length - 1) {
      await GetStorage().write('isFirstTime', false);
      Get.off(()=>  LoginScreen(),
          curve: Curves.linearToEaseOut,
          duration: const Duration(milliseconds: 100) );
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    }
  }

  /// Isolated execution logic simulation
  void performMockLoginFlow() {
    final url = urlController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (url.isEmpty || username.isEmpty || password.isEmpty) {
      _showSnackbar(textErrorEmptyFields, isError: true);
      return;
    }

    isLoggingIn.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoggingIn.value = false;
      _showSnackbar(textSuccessLogin, isError: false);
    });
  }

  void _showSnackbar(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? textAlertTitleError : textAlertTitleSuccess,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError
          ? Colors.redAccent.withOpacity(0.9)
          : Colors.green[700]!.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
