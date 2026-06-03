// lib/features/dashboard/presentation/controllers/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/dashboard_item_model.dart';
import '../../data/services/dhis2_api_service.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardProvider extends ChangeNotifier {
  final Dhis2ApiService _apiService;

  DashboardProvider(this._apiService);

  // Operational States
  DashboardStatus _status = DashboardStatus.initial;
  List<Dhis2Dashboard> _dashboards = [];
  List<Dhis2DashboardItem> _currentLayoutItems = [];
  int _selectedDashboardIndex = 0;
  String _errorMessage = '';

  // Getters for UI binding
  DashboardStatus get status => _status;
  List<Dhis2Dashboard> get dashboards => _dashboards;
  List<Dhis2DashboardItem> get currentLayoutItems => _currentLayoutItems;
  int get selectedDashboardIndex => _selectedDashboardIndex;
  String get errorMessage => _errorMessage;

  /// Entry point method to bootstrap the app data requirements on startup
  Future<void> initializeDashboardData() async {
    _status = DashboardStatus.loading;
    notifyListeners();

    try {
      // Step 1: Pull high level dashboard targets
      _dashboards = await _apiService.getDashboards();
      
      if (_dashboards.isNotEmpty) {
        // Step 2: Immediately load details for the first active selection
        _selectedDashboardIndex = 0;
        await _loadActiveLayout(_dashboards[_selectedDashboardIndex].id);
      } else {
        _status = DashboardStatus.loaded;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to connect to DHIS2 instance. Please check your offline status.';
      _status = DashboardStatus.error;
      notifyListeners();
    }
  }

  /// Changes the dashboard selection when a user taps a top choice chip element
  Future<void> switchDashboard(int index) async {
    if (_selectedDashboardIndex == index && _status == DashboardStatus.loaded) return;
    
    _selectedDashboardIndex = index;
    _status = DashboardStatus.loading;
    notifyListeners();

    try {
      await _loadActiveLayout(_dashboards[index].id);
    } catch (e) {
      _errorMessage = 'Could not load layout elements.';
      _status = DashboardStatus.error;
      notifyListeners();
    }
  }

  /// Internal isolated data fetch utility
  Future<void> _loadActiveLayout(String id) async {
    _currentLayoutItems = await _apiService.getDashboardLayout(id);
    _status = DashboardStatus.loaded;
    notifyListeners();
  }
}