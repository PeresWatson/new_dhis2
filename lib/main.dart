import 'package:dhis_2/Authentication/auth.dart';
import 'package:dhis_2/binding/global_binding.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/screens/onboarding_screen/onboarding_screen.dart';
import 'package:dhis_2/utils/network_controller.dart';
import 'package:dhis_2/preview_mode.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Set to true to enable preview mode (bypasses login)
const bool PREVIEW_MODE = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AppStorageService());

  // Notice permanent: true here
  Get.put(NetworkController(), permanent: true);
  Get.put(LoginController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DHIS2 Mobile Client',
      initialBinding: GlobalBinding(),
      home: PREVIEW_MODE ? const PreviewHomeScreen() : const OnboardingScreen(),
    );
  }
}
