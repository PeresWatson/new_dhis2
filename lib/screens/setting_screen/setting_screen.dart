import 'package:dhis_2/common/utils/methods/dataSize.dart';
import 'package:dhis_2/common/utils/methods/lastTime.dart';
import 'package:dhis_2/common/utils/methods/network_manager.dart';
import 'package:dhis_2/features/Authentication/auth.dart';
import 'package:dhis_2/screens/setting_screen/setting_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// ===============================
/// SCREEN
/// ===============================
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final c = Get.find<SettingScreenController>();

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
          _section("STORAGE"),

          _storageCard(),

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
    final storage = GetStorage();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(storage.read('user_profile')?['fullName'] ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(storage.read('user_profile')?['email'] ?? 'user@example.com', style: const TextStyle(color: Colors.grey)),
                  Text(storage.read('user_profile')?['jobTitle'] ?? 'User Role', style: const TextStyle(color: Colors.blue)),
                ],
              ),
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
    final storage = GetStorage();
    return Obx(
      () => Card(
        child: ListTile(
          leading: const Icon(Icons.cloud, color: Color(0xFF1D5288)),
          title: const Text("Server Endpoint"),
          subtitle: Text(storage.read('user_profile')?['serverUrl'] ?? 'Not Specified'),
          trailing: Icon(Icons.circle, size: 12, color: Get.find<NetworkController>().isOnline.value ? Colors.green : Colors.red),
        ),
      ),
    );
  }

  /// ===============================
  /// SYNC
  /// ===============================
  Widget _syncCard() {
    return Card(
      child: Column(
        children: [
          Obx(() => SwitchListTile(title: const Text("WiFi Only Sync"), value: c.wifiOnly.value, onChanged: c.toggleWifi)),

          Obx(() => SwitchListTile(title: const Text("Auto Sync"), value: c.autoSync.value, onChanged: c.toggleAutoSync)),

          Obx(
            () => ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Last Sync"),
              subtitle: Text(c.lastSync.value == "Never" ? "Never" : lastTime(c.lastSync.value)),
              trailing: ElevatedButton(onPressed: c.updateSyncTime, child: const Text("Sync")),
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// STORAGE
  /// ===============================
  Widget _storageCard() {
    final storage = GetStorage();
    final dashboardCachedData =  storage.read('simulated_dashboards');
    final UserProfileCachedData =  storage.read('user_profile');

    final usedMb = getDataSizeBytes(storage.read('user_profile')) / (1024 * 1024);

    const maxCacheMb = 10.0;

    final progress = (usedMb / maxCacheMb).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.storage_rounded, color: Color(0xFF1D5288)),
                SizedBox(width: 8),
                Text("Storage Usage", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${usedMb.toStringAsFixed(2)} MB", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("of ${maxCacheMb.toStringAsFixed(0)} MB", style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),

            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade300, color: const Color(0xFF1D5288)),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${(progress * 100).toStringAsFixed(1)}% used", style: TextStyle(color: Colors.grey.shade700)),
                Text("${(maxCacheMb - usedMb).toStringAsFixed(2)} MB free", style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  c.clearCache();
                  print("****************Cache cleared****************");
                  print(usedMb);
                  print("**********************************************");
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text("Clear Cache"),
              ),
            ),
          ],
        ),
      ),
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
    final storage = GetStorage();
    return Card(
      color: Colors.red.shade50,
      child: GestureDetector(
        onTap: () async {
          Get.find<AuthService>().logout();
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
