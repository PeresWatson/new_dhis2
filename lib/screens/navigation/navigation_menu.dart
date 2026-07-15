
import 'package:dhis_2/screens/analytics_screen/analytic_screen.dart';
import 'package:dhis_2/screens/home/home_screen.dart';
import 'package:dhis_2/screens/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Your existing code
  var selectedScreenIndex = 0.obs;

  final List<Widget> screens = [HomeScreen(), SimpleAnalyticsPage(), SettingsScreen()];

  void changeTab(int index) {
    selectedScreenIndex.value = index;
  }
}

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});

  final NavigationController controller = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: controller.screens[controller.selectedScreenIndex.value],

        bottomNavigationBar: NavigationBar(
          height: 50,
          selectedIndex: controller.selectedScreenIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: 'Analytics'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
          ],
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
