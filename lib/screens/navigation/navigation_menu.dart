import 'package:dhis_2/screens/analytics_screen/analytic_screen.dart';
import 'package:dhis_2/screens/home/home_screen.dart';
import 'package:dhis_2/screens/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Your existing code
  var selectedScreenIndex = 0.obs;

  final List<Widget> screens = [HomeScreen(), AnalyticsPage(), SettingsScreen()];

  void changeTab(int index) {
    selectedScreenIndex.value = index;
  }
}

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});

  final NavigationController controller = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      },
      child: Obx(
        () => Scaffold(
          body: controller.screens[controller.selectedScreenIndex.value],

          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              // YouTube Dark Mode background color
              backgroundColor: const Color(0xFF1D5288),

              // Crucial: This removes the Material 3 pill/capsule indicator behind the selected icon
              indicatorColor: Colors.transparent,

              // Label styling (YouTube uses small, clean, white/gray text)
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500);
                }
                return const TextStyle(
                  color: Color(0xFF909090), // Muted gray for unselected
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                );
              }),
            ),
            child: NavigationBar(
              height: 55, // YouTube navbar is compact
              selectedIndex: controller.selectedScreenIndex.value,
              onDestinationSelected: controller.changeTab,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow, // Keep labels visible
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Color(0xFFF1F1F1)),
                  selectedIcon: Icon(Icons.home, color: Colors.white),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined, color: Color(0xFFF1F1F1)),
                  selectedIcon: Icon(Icons.analytics, color: Colors.white),
                  label: 'Analytics',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined, color: Color(0xFFF1F1F1)),
                  selectedIcon: Icon(Icons.settings, color: Colors.white),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// EXPLORE TAB
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Explore', style: TextStyle(fontSize: 24))),
    );
  }
}
