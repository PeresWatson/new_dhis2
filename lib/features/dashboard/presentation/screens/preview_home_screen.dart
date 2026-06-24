// lib/features/dashboard/presentation/screens/preview_home_screen.dart

import 'package:flutter/material.dart';
import '../../../../core/network/dhis2_http_client.dart';
import 'dashboard_screen.dart'; // 🔓 This will now resolve perfectly
import 'indicator_detail_screen.dart';
import '../controllers/dashboard_provider.dart';
import '../controllers/indicator_detail_provider.dart';
import '../controllers/settings_provider.dart';
import '../../data/services/dhis2_api_service.dart';

class PreviewHomeScreen extends StatefulWidget {
  final Dhis2HttpClient networkClient;

  const PreviewHomeScreen({super.key, required this.networkClient});

  @override
  State<PreviewHomeScreen> createState() => _PreviewHomeScreenState();
}

class _PreviewHomeScreenState extends State<PreviewHomeScreen> {
  int _selectedIndex = 0;
  late DashboardProvider dashboardProvider;
  late IndicatorDetailProvider indicatorDetailProvider;
  late SettingsProvider settingsProvider;

  @override
  void initState() {
    super.initState();
    
    dashboardProvider = DashboardProvider(
      Dhis2ApiService(widget.networkClient.client),
    );
    
    indicatorDetailProvider = IndicatorDetailProvider();
    settingsProvider = SettingsProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          DashboardScreen(provider: dashboardProvider), // ✅ Clear compilation target
          IndicatorDetailScreen(
            visualId: 'b0239485',
            provider: indicatorDetailProvider,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF1D5288),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Indicator'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}