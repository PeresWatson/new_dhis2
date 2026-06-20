import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
   var dashboardsData = jsonDecode('{}');
   var selectedDashboardName = ''.obs;
   var selectedDashboardId = ''.obs;
   var isfetchingDashboards = false.obs;

  Future<void> fetchDashboards() async {
    isfetchingDashboards.value = true;
    String username = "admin";
    String password = "district";

    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));

    final response = await http.get(
      Uri.parse("https://play.im.dhis2.org/dev/api/dashboards.json"),
      headers: {"Authorization": basicAuth, "Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      dashboardsData = jsonDecode(response.body);
      selectedDashboardName.value = dashboardsData['dashboards'][1]['displayName'];
      selectedDashboardId.value = dashboardsData['dashboards'][1]['id'];
      isfetchingDashboards.value = false;
    } else {
      print("Failed: ${response.statusCode}");
      isfetchingDashboards.value = false;
    }
  }
}
