import 'package:dhis_2/common/utils/methods/network_manager.dart';
import 'package:dhis_2/features/Authentication/auth.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/screens/navigation/navigation_menu.dart';
import 'package:dhis_2/screens/onboarding_screen/onboarding_screen.dart';
import 'package:dhis_2/screens/setting_screen/setting_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();

  Get.put(NetworkController(), permanent: true);
  Get.put(AuthService(), permanent: true);

  // Notice permanent: true here
  Get.lazyPut(() => LoginController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true); // Notice fenix: true here
  Get.lazyPut(() => SettingScreenController(), fenix: true);
  Get.lazyPut(() => NavigationController(), fenix: true);

  FlutterNativeSplash.remove();
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
      // initialBinding: GlobalBinding(),
      home: const OnboardingScreen(),
    );
  }
}
