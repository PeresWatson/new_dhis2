import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var dashboards = jsonDecode('{}');
  var dashboardItems = jsonDecode('{}');

  var visualizationDetails = jsonDecode('{}');
  var selectedDashboardName = ''.obs;
  var selectedDashboardId = ''.obs;
  var isfetchingDashboards = false.obs;
  var isfetchingDashboardItems = false.obs;

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

    print("8888888888888--------LINK---------*****************");
    print(url);
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
}
