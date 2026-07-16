import 'package:dhis_2/common/utils/methods/dataSize.dart';
import 'package:dhis_2/common/utils/methods/lastTime.dart';
import 'package:dhis_2/common/utils/methods/network_manager.dart';
import 'package:dhis_2/features/Authentication/auth.dart';
import 'package:dhis_2/screens/setting_screen/setting_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const Color kBrandColor = Color(0xFF1D5288);
const Color kScaffoldBg = Color(0xFFF4F6F9);

/// ===============================
/// SCREEN
/// ===============================
class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final c = Get.find<SettingScreenController>();
  final GetStorage _storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBg,
      appBar: AppBar(
        backgroundColor: kBrandColor,
        title: const Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _profileCard(),
          const SizedBox(height: 24),
          _section('System'),
          _serverCard(),
          const SizedBox(height: 24),
          _section('Sync'),
          _syncCard(),
          const SizedBox(height: 24),
          _section('Storage'),
          _storageCard(),
          const SizedBox(height: 24),
          _section('Support'),
          _supportCard(),
          const SizedBox(height: 28),
          _aboutTile(),
          const SizedBox(height: 24),
          _logoutButton(),
        ],
      ),
    );
  }

  /// ===============================
  /// SHARED CARD SHELL
  /// ===============================
  /// One consistent card style (flat, subtle border, no shadow) used across
  /// every section so the page reads as a single system instead of a mix of
  /// elevated and bordered cards.
  Widget _card({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: padding != null ? Padding(padding: padding, child: child) : child,
    );
  }

  /// ===============================
  /// SECTION TITLE
  /// ===============================
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade500, letterSpacing: 0.6),
      ),
    );
  }

  /// ===============================
  /// PROFILE
  /// ===============================
  Widget _profileCard() {
    final profile = _storage.read('user_profile');

    return _card(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundColor: kBrandColor,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?['fullName'] ?? 'User',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  profile?['email'] ?? 'user@example.com',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: kBrandColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile?['jobTitle'] ?? 'User Role',
                    style: const TextStyle(color: kBrandColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// SERVER
  /// ===============================
  Widget _serverCard() {
    final profile = _storage.read('user_profile');

    return Obx(() {
      final isOnline = Get.find<NetworkController>().isOnline.value;
      return _card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: const Icon(Icons.cloud_outlined, color: kBrandColor),
          title: const Text('Server Endpoint'),
          subtitle: Text(
            profile?['serverUrl'] ?? 'Not specified',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: isOnline ? Colors.green : Colors.red),
              ),
              const SizedBox(width: 6),
              Text(
                isOnline ? 'Online' : 'Offline',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isOnline ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// ===============================
  /// SYNC
  /// ===============================
  Widget _syncCard() {
    return _card(
      child: Column(
        children: [
          Obx(
            () => SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              activeColor: kBrandColor,
              title: const Text('Wi-Fi Only Sync'),
              subtitle: const Text('Avoid using mobile data', style: TextStyle(fontSize: 12)),
              value: c.wifiOnly.value,
              onChanged: c.toggleWifi,
            ),
          ),
          const Divider(height: 1),
          Obx(
            () => SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              activeColor: kBrandColor,
              title: const Text('Auto Sync'),
              subtitle: const Text('Sync automatically in the background', style: TextStyle(fontSize: 12)),
              value: c.autoSync.value,
              onChanged: c.toggleAutoSync,
            ),
          ),
          const Divider(height: 1),
          Obx(
            () => ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(Icons.history, color: kBrandColor),
              title: const Text('Last Sync'),
              subtitle: Text(c.lastSync.value == 'Never' ? 'Never' : lastTime(c.lastSync.value)),
              trailing: TextButton(
                onPressed: c.updateSyncTime,
                style: TextButton.styleFrom(foregroundColor: kBrandColor),
                child: const Text('Sync now'),
              ),
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
    // Total local footprint = cached dashboards + cached profile data.
    final profileData = _storage.read('user_profile');
    final dashboardData = _storage.read('simulated_dashboards');
    final usedBytes = getDataSizeBytes(profileData) + getDataSizeBytes(dashboardData);
    final usedMb = usedBytes / (1024 * 1024);

    const maxCacheMb = 10.0;
    final progress = (usedMb / maxCacheMb).clamp(0.0, 1.0);

    return _card(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storage_rounded, color: kBrandColor),
              const SizedBox(width: 8),
              const Text('Storage Usage', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 8,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                color: kBrandColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${usedMb.toStringAsFixed(2)} MB used of ${maxCacheMb.toStringAsFixed(0)} MB',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _confirmClearCache,
              style: OutlinedButton.styleFrom(
                foregroundColor: kBrandColor,
                side: BorderSide(color: Colors.grey.shade300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear Cache'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClearCache() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear cache?'),
        content: const Text('This removes locally stored dashboard data. You can sync again anytime.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      c.clearCache();
      Get.snackbar(
        'Cache cleared',
        'Local dashboard data has been removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// ===============================
  /// SUPPORT
  /// ===============================
  Widget _supportCard() {
    return _card(
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: const Icon(Icons.help_outline, color: kBrandColor),
            title: const Text('Help Center'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: const Icon(Icons.bug_report_outlined, color: kBrandColor),
            title: const Text('Report Issue'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// ABOUT
  /// ===============================
  /// Kept as plain centered text rather than another bordered card — two
  /// lines of metadata don't need a container of their own.
  Widget _aboutTile() {
    return Center(
      child: Column(
        children: [
          Text(
            'DHIS2 Mobile Dashboard',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 2),
          Text('Version 1.0.0', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
        ],
      ),
    );
  }

  /// ===============================
  /// LOGOUT
  /// ===============================
  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _confirmLogout,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: BorderSide(color: Colors.red.shade200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        icon: const Icon(Icons.logout),
        label: const Text('Logout', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to access your dashboards.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Get.find<AuthService>().logout();
    }
  }
}