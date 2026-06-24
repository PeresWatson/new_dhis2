import 'package:dhis_2/Authentication/auth.dart';
import 'package:dhis_2/binding/global_binding.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/screens/navigation/navigation_menu.dart';
import 'package:dhis_2/screens/onboarding_screen/onboarding_screen.dart';
import 'package:dhis_2/utils/network_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AppStorageService());

  // Notice permanent: true here
  Get.put(NetworkController(), permanent: true);
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




// // lib/main.dart

// import 'package:flutter/material.dart';
// import 'core/network/dhis2_http_client.dart';
// import 'features/auth/presentation/controllers/auth_provider.dart';
// import 'features/auth/presentation/screens/login_screen.dart';
// import 'features/dashboard/presentation/screens/preview_home_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // 1. Instantiate the single source of truth for networking
//   final dhis2NetworkClient = Dhis2HttpClient();
  
//   // 2. Inject it into the authentication state manager
//   final authProvider = AuthProvider(dhis2NetworkClient);

//   runApp(Dhis2DashboardApp(
//     networkClient: dhis2NetworkClient,
//     authProvider: authProvider,
//   ));
// }

// class Dhis2DashboardApp extends StatefulWidget {
//   final Dhis2HttpClient networkClient;
//   final AuthProvider authProvider;

//   const Dhis2DashboardApp({
//     super.key,
//     required this.networkClient,
//     required this.authProvider,
//   });

//   @override
//   State<Dhis2DashboardApp> createState() => _Dhis2DashboardAppState();
// }

// class _Dhis2DashboardAppState extends State<Dhis2DashboardApp> {
//   bool _isAuthenticated = false;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'DHIS2 Mobile Dashboard',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: const Color(0xFF1D5288),
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFF1D5288),
//           primary: const Color(0xFF1D5288),
//         ),
//         useMaterial3: true,
//       ),
//       // 3. Centralized Session Switcher Control
//       home: !_isAuthenticated
//           ? LoginScreen(
//               provider: widget.authProvider,
//               onLoginSuccess: () {
//                 // When authentication intercepts successfully, flip state to mount home shell
//                 setState(() {
//                   _isAuthenticated = true;
//                 });
//               },
//             )
//           : PreviewHomeScreen(
//               networkClient: widget.networkClient, // ✅ Safe Client passed directly
//             ),
//     );
//   }
// }