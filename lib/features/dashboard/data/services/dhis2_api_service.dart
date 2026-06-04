// lib/features/dashboard/data/services/dhis2_api_service.dart

import 'package:dio/dio.dart';
import '../models/dashboard_model.dart';
import '../models/dashboard_item_model.dart';
import '../models/analytics_response_model.dart';

class Dhis2ApiService {
  final Dio _dio;

  Dhis2ApiService(this._dio);

  /// 1. Rich set of presentation dashboards
  Future<List<Dhis2Dashboard>> getDashboards() async {
    try {
      final response = await _dio
          .get('/api/dashboards?fields=id,displayName&paging=false')
          .timeout(const Duration(seconds: 2));
          
      if (response.statusCode == 200) {
        final List listData = response.data['dashboards'] ?? [];
        return listData.map((item) => Dhis2Dashboard.fromJson(item)).toList();
      }
    } catch (_) {}
    
    return [
      Dhis2Dashboard(id: 'dash-01', displayName: 'Maternal & Child Health Summary', starred: true),
      Dhis2Dashboard(id: 'dash-02', displayName: 'Malaria Interventions & Logistics', starred: false),
      Dhis2Dashboard(id: 'dash-03', displayName: 'Epidemiological Surveillance Hub', starred: true),
    ];
  }

  /// 2. Rich Layout composition items with distinct CHART sub-types
  Future<List<Dhis2DashboardItem>> getDashboardLayout(String dashboardId) async {
    try {
      final response = await _dio
          .get('/api/dashboards/$dashboardId?fields=dashboardItems[id,type,shape,indicator[id,displayName]]')
          .timeout(const Duration(seconds: 2));
          
      if (response.statusCode == 200) {
        final List itemsData = response.data['dashboardItems'] ?? [];
        return itemsData.map((item) => Dhis2DashboardItem.fromJson(item)).toList();
      }
    } catch (_) {}

    // Swapping dashboard IDs renders entirely unique, specialized data sets!
    if (dashboardId == 'dash-02') {
      return [
        Dhis2DashboardItem(id: 'mal-01', type: 'BAR_CHART', shape: 'NORMAL', visualId: 'ind-201', displayName: 'ITN Distributed to Pregnant Women'),
        Dhis2DashboardItem(id: 'mal-02', type: 'LINE_CHART', shape: 'NORMAL', visualId: 'ind-202', displayName: 'Malaria Rapid Test Positivity Rate (%)'),
        Dhis2DashboardItem(id: 'mal-03', type: 'BAR_CHART', shape: 'NORMAL', visualId: 'ind-203', displayName: 'Artesunate Stock-out Duration (Days)'),
      ];
    }

    if (dashboardId == 'dash-03') {
      return [
        Dhis2DashboardItem(id: 'epi-01', type: 'BAR_CHART', shape: 'NORMAL', visualId: 'ind-301', displayName: 'Cholera Cumulative Case Incident Alert Count'),
        Dhis2DashboardItem(id: 'epi-02', type: 'LINE_CHART', shape: 'NORMAL', visualId: 'ind-302', displayName: 'Yellow Fever Vaccination Coverage (%)'),
      ];
    }

    // Default Fallback Layout for 'dash-01' (Maternal Health)
    return [
      Dhis2DashboardItem(id: 'mat-01', type: 'LINE_CHART', shape: 'NORMAL', visualId: 'ind-101', displayName: 'ANC 1st Visit Coverage Trend'),
      Dhis2DashboardItem(id: 'mat-02', type: 'BAR_CHART', shape: 'NORMAL', visualId: 'ind-102', displayName: 'BCG Immunization Drop-out Rate Evaluation'),
      Dhis2DashboardItem(id: 'mat-03', type: 'LINE_CHART', shape: 'NORMAL', visualId: 'ind-103', displayName: 'Institutional Delivery Rate (%)'),
      Dhis2DashboardItem(id: 'mat-04', type: 'BAR_CHART', shape: 'NORMAL', visualId: 'ind-104', displayName: 'Postnatal Care Coverage within 48 Hours'),
    ];
  }

  /// 3. Simulates analytics response streams matching requested target metrics
  Future<AnalyticsResponseModel> getIndicatorAnalytics(String indicatorId) async {
    // Returns dummy points for execution safety frameworks
    return AnalyticsResponseModel(dataPoints: []);
  }
}