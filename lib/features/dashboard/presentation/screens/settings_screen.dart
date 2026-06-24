import 'package:dhis_2/screens/login/login_screen.dart';
import 'package:dhis_2/screens/navigation/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ===============================
/// CONTROLLER
/// ===============================
class SettingsController extends GetxController {
  // Profile
  final name = "Abdullatif Heri Mnyamisi".obs;
  final email = "brillianttonsa@gmail.com".obs;
  final role = "DHIS2 Administrator".obs;

  // Server
  final serverUrl = "https://play.dhis2.org/dev".obs;
  final serverOnline = true.obs;

  // Sync
  final wifiOnly = true.obs;
  final autoSync = true.obs;
  final lastSync = "Today 10:45 AM".obs;

  // Storage
  final storageUsed = 0.65.obs;
  final storageMb = 248.0.obs;

  // Appearance
  final darkMode = false.obs;

  void toggleWifi(bool v) => wifiOnly.value = v;
  void toggleAutoSync(bool v) => autoSync.value = v;
  void toggleDarkMode(bool v) => darkMode.value = v;

  void clearCache() {
    storageUsed.value = 0.1;
    storageMb.value = 40;
    Get.snackbar("Storage", "Cache cleared");
  }

  void syncNow() {
    Get.snackbar("Sync", "Synchronization started...");
  }

  void logout() {
    Get.snackbar("Logout", "Session ended");
  }
}

/// ===============================
/// SCREEN
/// ===============================
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController c = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1D5288),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          _profileCard(),

          const SizedBox(height: 16),
          _section("SYSTEM"),

          _serverCard(),

          const SizedBox(height: 16),
          _section("SYNC"),

          _syncCard(),

          const SizedBox(height: 16),
          _section("DASHBOARD"),

          _dashboardCard(),

          const SizedBox(height: 16),
          _section("APPEARANCE"),

          _appearanceCard(),

          const SizedBox(height: 16),
          _section("STORAGE"),

          _storageCard(),

          const SizedBox(height: 16),
          _section("SECURITY"),

          _securityCard(),

          const SizedBox(height: 16),
          _section("SUPPORT"),

          _supportCard(),

          const SizedBox(height: 16),

          _aboutCard(),

          const SizedBox(height: 20),

          _logoutCard(),
        ],
      ),
    );
  }

  /// ===============================
  /// PROFILE
  /// ===============================
  Widget _profileCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFF1D5288),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(c.email.value, style: const TextStyle(color: Colors.grey)),
                    Text(c.role.value, style: const TextStyle(color: Colors.blue)),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// SERVER
  /// ===============================
  Widget _serverCard() {
    return Card(
      child: Obx(() {
        return ListTile(
          leading: const Icon(Icons.cloud, color: Color(0xFF1D5288)),
          title: const Text("Server Endpoint"),
          subtitle: Text(c.serverUrl.value),
          trailing: Icon(Icons.circle, size: 12, color: c.serverOnline.value ? Colors.green : Colors.red),
        );
      }),
    );
  }

  /// ===============================
  /// SYNC
  /// ===============================
  Widget _syncCard() {
    return Card(
      child: Column(
        children: [
          Obx(() {
            return SwitchListTile(title: const Text("WiFi Only Sync"), value: c.wifiOnly.value, onChanged: c.toggleWifi);
          }),
          Obx(() {
            return SwitchListTile(title: const Text("Auto Sync"), value: c.autoSync.value, onChanged: c.toggleAutoSync);
          }),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Last Sync"),
            subtitle: Obx(() => Text(c.lastSync.value)),
            trailing: ElevatedButton(onPressed: c.syncNow, child: const Text("Sync")),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// DASHBOARD
  /// ===============================
  Widget _dashboardCard() {
    return const Card(
      child: Column(
        children: [
          ListTile(leading: Icon(Icons.dashboard), title: Text("Default Dashboard"), subtitle: Text("Home Analytics")),
          ListTile(leading: Icon(Icons.star), title: Text("Favorites First"), trailing: Icon(Icons.toggle_on)),
        ],
      ),
    );
  }

  /// ===============================
  /// APPEARANCE
  /// ===============================
  Widget _appearanceCard() {
    return Card(
      child: Obx(() {
        return SwitchListTile(
          secondary: const Icon(Icons.dark_mode),
          title: const Text("Dark Mode"),
          value: c.darkMode.value,
          onChanged: c.toggleDarkMode,
        );
      }),
    );
  }

  /// ===============================
  /// STORAGE
  /// ===============================
  Widget _storageCard() {
    return Card(
      child: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Storage Usage"),
              const SizedBox(height: 10),

              LinearProgressIndicator(value: c.storageUsed.value, backgroundColor: Colors.grey.shade300, color: const Color(0xFF1D5288)),

              const SizedBox(height: 10),

              Text("${c.storageMb.value} MB used"),

              const SizedBox(height: 12),

              OutlinedButton(onPressed: c.clearCache, child: const Text("Clear Cache")),
            ],
          ),
        );
      }),
    );
  }

  /// ===============================
  /// SECURITY
  /// ===============================
  Widget _securityCard() {
    return const Card(
      child: ListTile(leading: Icon(Icons.lock), title: Text("Change Password"), trailing: Icon(Icons.arrow_forward_ios, size: 16)),
    );
  }

  /// ===============================
  /// SUPPORT
  /// ===============================
  Widget _supportCard() {
    return const Card(
      child: Column(
        children: [
          ListTile(leading: Icon(Icons.help), title: Text("Help Center")),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.bug_report), title: Text("Report Issue")),
        ],
      ),
    );
  }

  /// ===============================
  /// ABOUT
  /// ===============================
  Widget _aboutCard() {
    return const Card(
      child: ListTile(leading: Icon(Icons.info), title: Text("DHIS2 Mobile Dashboard"), subtitle: Text("Version 1.0.0")),
    );
  }

  /// ===============================
  /// LOGOUT
  /// ===============================
  Widget _logoutCard() {
    return Card(
      
      color: Colors.red.shade50,
      child: GestureDetector(
        onTap: () {
          Get.off(() => LoginScreen());
          Get.find<NavigationController>().selectedScreenIndex.value = 0;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
              Icon(Icons.logout, color: Colors.red),
              Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// SECTION TITLE
  /// ===============================
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }
}
