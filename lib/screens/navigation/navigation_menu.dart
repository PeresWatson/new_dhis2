import 'package:d2_touch/modules/auth/entities/user.entity.dart';
import 'package:dhis_2/core/services/d2_touch_service.dart';
import 'package:dhis_2/features/dashboard/presentation/screens/settings_screen.dart';
import 'package:dhis_2/screens/analytics_screen/analytic_screen.dart';
import 'package:dhis_2/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  Rx<User?> currentUser = Rx<User?>(null);   // ← Store user globally


  Future<void> loadCurrentUser() async {
    try {
      final User? user = await getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  // Add this helper method
  Future<User?> getCurrentUser() async {
    try {
      final d2 = Get.find<D2Service>().d2; // or however you access your D2Touch instance
      // if (d2 == null) return null;

      return await d2.userModule.user
          .withAuthorities()
          .withRoles()
          .getOne();
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Your existing code
  var selectedScreenIndex = 0.obs;

  final List<Widget> screens = [
    HomeScreen(),
    SimpleAnalyticsPage(),
    ExploreScreen(),
    SettingsScreen(),
  ];

  void changeTab(int index) {
    selectedScreenIndex.value = index;
  }
}

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});

  final NavigationController controller = Get.find<NavigationController>();

  @override
  Widget build(BuildContext context) {
    controller.loadCurrentUser(); // Load user when the widget builds
    return Obx(
      () => Scaffold(
        body: controller.screens[controller.selectedScreenIndex.value],

        bottomNavigationBar: NavigationBar(
          height: 50,
          selectedIndex: controller.selectedScreenIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
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
