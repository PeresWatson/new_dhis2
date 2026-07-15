import 'package:dhis_2/screens/login/login_screen.dart';
import 'package:dhis_2/screens/navigation/navigation_menu.dart';
import 'package:dhis_2/screens/onboarding_screen/onboarding_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxController {
  final storage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  void screenRedirect() {
    final bool isFirstTime = storage.read('isFirstTime') ?? true;
    final bool isLoggedIn = storage.read('isLoggedIn') ?? false;

    if (isFirstTime) {
      // 1. Brand new user -> Show Onboarding
      Get.offAll(() => const OnboardingScreen());
    } else if (isLoggedIn) {
      // 2. Returning user who is already authenticated -> Show Home Dashboard
      Get.offAll(() => NavigationMenu());
    } else {
      // 3. Returning user who is logged out -> Show Login Screen
      Get.offAll(() => LoginScreen());
    }
  }

  void logout() {
    storage.write('isLoggedIn', false);
    storage.remove('user_profile');
    Get.offAll(() => LoginScreen());
  }
}
