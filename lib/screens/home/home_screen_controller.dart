import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var dashboards = jsonDecode('{}');
  var dashboardItems = jsonDecode('{}');

  final dashboardVisualizations = <Map<String, dynamic>>[].obs;
  final String baseUrl = "https://play.im.dhis2.org/dev";
  final String username = "admin";
  final String password = "district";
  Map<String, String> get headers => {
    "Authorization": "Basic ${base64Encode(utf8.encode('$username:$password'))}",
    "Content-Type": "application/json",
  };

  var visualizationDetails = jsonDecode('{}');
  var selectedDashboardName = ''.obs;
  var selectedDashboardId = ''.obs;
  var isfetchingDashboards = false.obs;
  var isfetchingDashboardItems = false.obs;

  // ***********************Fetching dasboards details by its id************************************
  Future<Map<String, dynamic>> getDashboard(String dashboardId) async {
    final response = await http.get(Uri.parse("$baseUrl/api/dashboards/$dashboardId.json"), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load dashboard");
  }

  // ***********************Fetching visualization details by its id************************************
  Future<Map<String, dynamic>> getVisualization(String visualizationId) async {
    final response = await http.get(Uri.parse("$baseUrl/api/visualizations/$visualizationId.json"), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load visualization");
  }

  // ***********************Fetching analytics details by its url************************************
  Future<Map<String, dynamic>> getAnalytics(String url) async {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception("Failed to load analytics");
  }


  Future<void> fetchDashboards() async {
    isfetchingDashboards.value = true;
    String username = "admin";
    String password = "district";

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse("https://play.im.dhis2.org/dev/api/dashboards.json"),
      headers: {"Authorization": basicAuth, "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      dashboards = jsonDecode(response.body);
      selectedDashboardName.value = dashboards['dashboards'][0]['displayName'];
      selectedDashboardId.value = dashboards['dashboards'][0]['id'];
      isfetchingDashboards.value = false;
    } else {
      print("Failed: ${response.statusCode}");
      isfetchingDashboards.value = false;
    }
  }

  Future<void> fetchDashboardItems(String dashboardId) async {
    isfetchingDashboardItems.value = true;
    String username = "admin";
    String password = "district";

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(
      Uri.parse("https://play.im.dhis2.org/dev/api/dashboards/$dashboardId.json"),
      headers: {"Authorization": basicAuth, "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      dashboardItems = jsonDecode(response.body);
      isfetchingDashboardItems.value = false;
      print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
      print('DASHBOARD DETAILS AND ITS CONTENT HAS BEEN FETCHED');
      print(dashboardItems);
    } else {
      print("Failed: ${response.statusCode}");
      isfetchingDashboardItems.value = false;
    }
  }

  Future<void> fetchVisualizationDetails(String visualizationId) async {
    isfetchingDashboardItems.value = true;
    String username = "admin";
    String password = "district";
    final url = Uri.parse("https://play.im.dhis2.org/dev/api/$visualizationId");

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    final response = await http.get(url, headers: {"Authorization": basicAuth, "Content-Type": "application/json"});
    if (response.statusCode == 200) {
      visualizationDetails = jsonDecode(response.body);

      print("Visualization Item detail: $visualizationDetails");
      isfetchingDashboardItems.value = false;
      return visualizationDetails;
    } else {
      print("Failed: ${response.statusCode}");
      isfetchingDashboardItems.value = false;
    }
  }

  // ********************************************

  Future<void> loadDashboardData(String dashboardId) async {
    final dashboard = await getDashboard(dashboardId);

    final items = dashboard['dashboardItems'];

    for (final item in items) {
      if (item['visualization'] == null) {
        continue;
      }

      final visId = item['visualization']['id'];

      final visualization = await getVisualization(visId);

      final analytics = await getAnalytics(visualization['href']);

      dashboardVisualizations.add({'visualization': visualization, 'analytics': analytics});
      print('**************************************************');
      print('Dashboard Visualizations:');
      Get.dialog(
        AlertDialog(
        title: Text('Dashboard Visualizations'),
        content: Text('Visualization: ${dashboardVisualizations}'),
      ));
      print(dashboardVisualizations);
    }
  }

  
}
