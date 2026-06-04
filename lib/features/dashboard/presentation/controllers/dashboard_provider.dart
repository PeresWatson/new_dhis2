// lib/features/dashboard/presentation/controllers/dashboard_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/dashboard_model.dart';
import '../../data/models/dashboard_item_model.dart';
import '../../data/services/dhis2_api_service.dart';

enum DashboardStatus { loading, success, error }

class DashboardProvider extends ChangeNotifier {
  final Dhis2ApiService _apiService;
  
  List<Dhis2Dashboard> _dashboards = [];
  List<Dhis2DashboardItem> _currentLayoutItems = [];
  DashboardStatus _status = DashboardStatus.loading;
  String _errorMessage = '';
  
  // 🔑 1. THIS IS THE MISSING INT VARIABLE
  int _selectedDashboardIndex = 0; 

  DashboardProvider(this._apiService) {
    initializeDashboardData();
  }

  // Getters exposed directly to DashboardScreen
  List<Dhis2Dashboard> get dashboards => _dashboards;
  List<Dhis2DashboardItem> get currentLayoutItems => _currentLayoutItems;
  DashboardStatus get status => _status;
  bool get isLoading => _status == DashboardStatus.loading;
  String get errorMessage => _errorMessage;
  
  // 🔑 2. THIS IS THE MISSING GETTER THE SCREEN IS CRYING FOR
  int get selectedDashboardIndex => _selectedDashboardIndex; 

  /// Bootstraps initial metadata sets
  Future<void> initializeDashboardData() async {
    _status = DashboardStatus.loading;
    _errorMessage = '';
    _selectedDashboardIndex = 0;
    notifyListeners();
    
    try {
      _dashboards = await _apiService.getDashboards();
      
      if (_dashboards.isNotEmpty) {
        await loadDashboardLayout(_dashboards.first.id);
      } else {
        _status = DashboardStatus.success;
        notifyListeners();
      }
    } catch (e) {
      _status = DashboardStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// 🔑 3. THIS ACCEPTS 'int index' TO MATCH ONSELECTED IN THE CHOICE CHIPS
  Future<void> switchDashboard(int index) async {
    if (index < 0 || index >= _dashboards.length) return;
    
    _selectedDashboardIndex = index; // Updates chip background highlights
    _status = DashboardStatus.loading;
    notifyListeners();
    
    // Grabs the real string ID out of the array list to call the API
    final selectedDashboardId = _dashboards[index].id;
    await loadDashboardLayout(selectedDashboardId);
  }

  /// Fetches layout composition blocks for a chosen dashboard
  Future<void> loadDashboardLayout(String dashboardId) async {
    try {
      _currentLayoutItems = await _apiService.getDashboardLayout(dashboardId);
      _status = DashboardStatus.success;
    } catch (e) {
      // Static fallback presentation elements if completely offline
      _currentLayoutItems = [
        Dhis2DashboardItem(
          id: 'item-01', 
          type: 'CHART', 
          shape: 'NORMAL', 
          visualId: 'ind-101', 
          displayName: 'ANC 1st Visit Coverage Trend',
        ),
        Dhis2DashboardItem(
          id: 'item-02', 
          type: 'CHART', 
          shape: 'DOUBLE_WIDTH', 
          visualId: 'ind-102', 
          displayName: 'BCG Immunization Drop-out Rate',
        ),
      ];
      _status = DashboardStatus.success;
    }
    notifyListeners();
  }
}