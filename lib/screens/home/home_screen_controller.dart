import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var dashboards = jsonDecode('{}');
  var simulatedDashboards = jsonDecode('{}');
  var selectedDashboardIndex = 0;
  var selectedVisualizationIndex = 0;
  var selectedDashboard = jsonDecode('{}');
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
  // FETCHING SIMULATED DATA FROM ASSETS FOLDER

  Future<void> fetchSimulatedData() async {
    isfetchingDashboards.value = true;
    try {
      // 1. Read the file directly from your local assets bundle
      final String responseBody = await rootBundle.loadString('assets/data/dashboards.json');

      // 2. Decode the string data into your variable
      simulatedDashboards = jsonDecode(responseBody);

      isfetchingDashboards.value = false;
    } catch (e) {
      print("Error fetching simulated dashboards: $e");
      isfetchingDashboards.value = false;
    } finally {
      isfetchingDashboards.value = false;
    }
  }
}
