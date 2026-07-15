import 'package:dhis_2/common/utils/methods/network_manager.dart';
import 'package:dhis_2/features/Notifications/app_snackbars.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final storage = GetStorage();
  var dashboards = jsonDecode('{}');
  var simulatedDashboards = jsonDecode('{}');
  var selectedDashboardIndex = (-1).obs;
  var selectedVisualizationIndex = (-1).obs;
  var selectedDashboard = jsonDecode('{}');
  var dashboardItems = jsonDecode('{}');
  final MapController mapController = MapController();

  final dashboardVisualizations = <Map<String, dynamic>>[].obs;
  final String baseUrl = "https://play.im.dhis2.org/dev";
  final String username = "admin";
  final String password = "district";

  var visualizationDetails = jsonDecode('{}');
  var selectedDashboardName = ''.obs;
  var selectedDashboardId = ''.obs;
  var isfetchingDashboards = false.obs;
  var isfetchingDashboardItems = false.obs;

  var isfullScreenLineChart = false.obs;
  var isfullScreenBarChart = false.obs;
  var isfullScreenPieChart = false.obs;
  var isfullScreenMap = false.obs;
  var isfullScreenTable = false.obs;
  
  // FETCHING SIMULATED DATA FROM ASSETS FOLDER

  Future<void> fetchSimulatedData() async {
    isfetchingDashboards.value = true;

    try {
      final cachedData = storage.read('simulated_dashboards');

      if (cachedData != null) {
        simulatedDashboards = cachedData;
      } else {
        if (Get.find<NetworkController>().isOnline.value == false) {
          AppSnackbars.showNoInternet();
          return;
        }

        final responseBody = await rootBundle.loadString('assets/data/dashboards.json');

        simulatedDashboards = jsonDecode(responseBody);

        await storage.write('simulated_dashboards', simulatedDashboards);
      }
    } catch (e) {
      print("Error fetching simulated dashboards: $e");
    } finally {
      isfetchingDashboards.value = false;
    }
  }
}
