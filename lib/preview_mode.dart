import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/dashboard/presentation/screens/indicator_detail_screen.dart';
import 'features/dashboard/presentation/controllers/dashboard_provider.dart';
import 'features/dashboard/presentation/controllers/indicator_detail_provider.dart';
import 'features/dashboard/presentation/controllers/settings_provider.dart';
import 'features/dashboard/data/services/dhis2_api_service.dart';

class PreviewHomeScreen extends StatefulWidget {
  const PreviewHomeScreen({super.key});

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
    // Initialize providers with mock data
    final dio = Dio();
    dashboardProvider = DashboardProvider(Dhis2ApiService(dio));
    indicatorDetailProvider = IndicatorDetailProvider();
    settingsProvider = SettingsProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Dashboard Screen
          DashboardScreen(provider: dashboardProvider),
          // Indicator Detail Screen
          IndicatorDetailScreen(
            visualId: 'b0239485',
            provider: indicatorDetailProvider,
          ),
          // Settings Screen
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
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Indicator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
