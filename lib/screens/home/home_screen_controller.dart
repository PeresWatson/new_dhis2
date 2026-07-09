import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final dashboards = <String, dynamic>{}.obs;
  final dashboardItems = <String, dynamic>{}.obs;
  final dashboardVisualizations = <Map<String, dynamic>>[].obs;

  final visualizations = <Map<String, dynamic>>[].obs;
  final visualizationDetails = <String, dynamic>{}.obs;
  final selectedDashboardName = ''.obs;
  final selectedDashboardId = ''.obs;
  final isfetchingDashboards = false.obs;
  final isfetchingDashboardItems = false.obs;

  Future<void> fetchDashboards() async {
    if (dashboards.isNotEmpty) {
      return;
    }

    isfetchingDashboards.value = true;
    try {
      final seedJson = await rootBundle.loadString('assets/data/dhis2_dashboard_seed.json');
      final decoded = jsonDecode(seedJson) as Map<String, dynamic>;
      dashboards.value = decoded;

      final dashboardList = decoded['dashboards'] as List? ?? <dynamic>[];
      if (dashboardList.isNotEmpty) {
        final firstDashboard = dashboardList.first as Map<String, dynamic>;
        selectedDashboardId.value = firstDashboard['id'].toString();
        selectedDashboardName.value = firstDashboard['name'].toString();
        await fetchDashboardItems(firstDashboard['id'].toString());
      }
    } catch (e) {
      dashboards.value = {
        'dashboards': [
          {
            'id': 'fallback',
            'name': 'Fallback Dashboard',
            'description': 'Seed data is temporarily unavailable.',
            'visualizationCount': 1,
            'category': 'Health',
            'visualizations': [
              {
                'id': 'fallback-viz',
                'dashboardId': 'fallback',
                'title': 'Fallback Visualization',
                'description': 'The local seed file could not be loaded.',
                'indicatorCode': 'FALLBACK',
                'indicatorName': 'Fallback KPI',
                'defaultRenderType': 'kpi',
                'availableRenderTypes': ['kpi', 'table'],
                'allowDrillDown': false,
                'data': {'type': 'kpi', 'value': 100, 'unit': '%', 'trend': 'up', 'previousValue': 90, 'target': 100},
              },
            ],
          },
        ],
      };
      selectedDashboardId.value = 'fallback';
      selectedDashboardName.value = 'Fallback Dashboard';
      await fetchDashboardItems('fallback');
    }

    isfetchingDashboards.value = false;
  }

  Future<void> fetchDashboardItems(String dashboardId) async {
    isfetchingDashboardItems.value = true;
    final dashboardList = dashboards['dashboards'] as List? ?? <dynamic>[];
    final currentDashboard = dashboardList.cast<Map<String, dynamic>>().firstWhere(
      (dashboard) => dashboard['id'] == dashboardId,
      orElse: () => <String, dynamic>{},
    );

    if (currentDashboard.isNotEmpty) {
      dashboardItems.value = currentDashboard;
      selectedDashboardId.value = dashboardId;
      selectedDashboardName.value = currentDashboard['name']?.toString() ?? '';
      visualizations.value = List<Map<String, dynamic>>.from((currentDashboard['visualizations'] ?? []).cast<Map<String, dynamic>>());
    } else {
      dashboardItems.value = <String, dynamic>{};
      visualizations.clear();
    }

    isfetchingDashboardItems.value = false;
  }

  Future<Map<String, dynamic>> fetchVisualizationDetails(String visualizationId) async {
    final match = visualizations.firstWhere((visualization) => visualization['id'] == visualizationId, orElse: () => <String, dynamic>{});

    if (match.isNotEmpty) {
      visualizationDetails.value = match;
      return match;
    }

    return <String, dynamic>{};
  }
}
