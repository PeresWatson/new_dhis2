// lib/features/dashboard/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import '../controllers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsProvider provider;

  const SettingsScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    widget.provider.addListener(_updateUi);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_updateUi);
    super.dispose();
  }

  void _updateUi() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final settings = widget.provider;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D5288), // Consistent DHIS2 Corporate Blue
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('User Profile & Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. User Info Header Block
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF1D5288),
                    child: Icon(Icons.person, size: 36, color: Colors.white),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Abdullatif Heri Mnyamisi',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'brillianttonsa@gmail.com',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. System Server Settings Section
          _buildSectionHeader('SYSTEM CONTEXT'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.dns_rounded, color: Color(0xFF1D5288)),
              title: const Text('Connected Server Endpoint', style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(settings.connectedServerUrl, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
            ),
          ),
          const SizedBox(height: 16),

          // 3. Offline Capabilities & Sync Configurations Section
          _buildSectionHeader('OFFLINE STORAGE & SYNC'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Column(
              children: [
                SwitchListTile(
                  activeColor: const Color(0xFF1D5288),
                  secondary: const Icon(Icons.wifi_rounded, color: Color(0xFF1D5288)),
                  title: const Text('Sync over Wi-Fi only'),
                  subtitle: const Text('Prevents background updates over cellular networks'),
                  value: settings.syncWifiOnly,
                  onChanged: (val) => settings.toggleWifiSync(val),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage_rounded, color: Color(0xFF1D5288)),
                  title: const Text('Local Data Cache Size'),
                  trailing: Text(
                    '${settings.cacheSizeMb.toStringAsFixed(2)} MB',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2D3748)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 4.0),
                  child: Row(
  children: [
    Expanded(
      child: OutlinedButton.icon(
        onPressed: () => settings.clearLocalCache(),
        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
        label: const Text(
          'Clear Cache',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
        ),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton.icon(
        onPressed: () => settings.triggerManualSync(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D5288),
        ),
        icon: const Icon(Icons.sync_rounded, size: 18, color: Colors.white),
        label: const Text(
          'Sync Now',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
)
                )
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Security Framework Section
          _buildSectionHeader('SECURITY'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('Log Out From Profile Session', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                // Implement authentication session clear and login route replacement
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
        letterSpacing: 0.8,
      ),
    ),
  );
}
}