import 'package:dhis_2/Authentication/auth.dart';
import 'package:dhis_2/binding/global_binding.dart';
import 'package:dhis_2/core/services/d2_touch_service.dart';
import 'package:dhis_2/main.reflectable.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/screens/navigation/navigation_menu.dart';
import 'package:dhis_2/screens/onboarding_screen/onboarding_screen.dart';
import 'package:dhis_2/utils/network_controller.dart';
import 'package:dhis_2/utils/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeReflectable();
  final prefs = await SharedPreferences.getInstance();
  // Initialize d2_touch at app start
  await Get.putAsync<D2Service>(() => D2Service().init(
   
  ), permanent: true);

  await GetStorage.init();
  Get.put(AppStorageService());

  // Notice permanent: true here
  Get.put(NetworkManager(), permanent: true);
  Get.put(NetworkServiceController(), permanent: true);
  Get.put(LoginController(), permanent: true);
  Get.put(HomeController(), permanent: true);
  Get.put(NavigationController(), permanent: true);
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
      home: const OnboardingScreen(),
    );
  }
}

