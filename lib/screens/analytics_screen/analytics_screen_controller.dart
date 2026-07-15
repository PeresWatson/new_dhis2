import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsController extends GetxController {
  // Hardcoded data
  final indicators = [
    {'id': 'ind1', 'name': 'ANC 1st Visit'},
    {'id': 'ind2', 'name': 'ANC 4th Visit'},
    {'id': 'ind3', 'name': 'Family Planning'},
    {'id': 'ind4', 'name': 'Immunization'},
    {'id': 'ind5', 'name': 'Malaria Treatment'},
    {'id': 'ind6', 'name': 'HIV Testing'},
    {'id': 'ind7', 'name': 'TB Treatment'},
    {'id': 'ind8', 'name': 'Maternal Mortality'},
    {'id': 'ind9', 'name': 'Child Nutrition'},
    {'id': 'ind10', 'name': 'Water Sanitation'},
  ].obs;

  final organisationUnits = [
    {'id': 'ou1', 'name': 'Central Hospital'},
    {'id': 'ou2', 'name': 'District Hospital A'},
    {'id': 'ou3', 'name': 'District Hospital B'},
    {'id': 'ou4', 'name': 'Health Center 1'},
    {'id': 'ou5', 'name': 'Health Center 2'},
    {'id': 'ou6', 'name': 'Health Center 3'},
    {'id': 'ou7', 'name': 'Rural Clinic A'},
    {'id': 'ou8', 'name': 'Rural Clinic B'},
  ].obs;

  final selectedIndicators = <Map<String, dynamic>>[].obs;
  final selectedPeriod = 'LAST_12_MONTHS'.obs;
  final selectedOrgUnit = 'ou1'.obs;
  final aggregationType = 'SUM'.obs;
  
  final analyticsData = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  // Hardcoded analytics data
  final List<Map<String, dynamic>> _hardcodedData = [
    {'indicator': 'ANC 1st Visit', 'period': '2023-Q1', 'orgUnit': 'Central Hospital', 'value': 450},
    {'indicator': 'ANC 1st Visit', 'period': '2023-Q2', 'orgUnit': 'Central Hospital', 'value': 520},
    {'indicator': 'ANC 1st Visit', 'period': '2023-Q3', 'orgUnit': 'Central Hospital', 'value': 480},
    {'indicator': 'ANC 1st Visit', 'period': '2023-Q4', 'orgUnit': 'Central Hospital', 'value': 600},
    {'indicator': 'ANC 4th Visit', 'period': '2023-Q1', 'orgUnit': 'Central Hospital', 'value': 320},
    {'indicator': 'ANC 4th Visit', 'period': '2023-Q2', 'orgUnit': 'Central Hospital', 'value': 380},
    {'indicator': 'ANC 4th Visit', 'period': '2023-Q3', 'orgUnit': 'Central Hospital', 'value': 410},
    {'indicator': 'ANC 4th Visit', 'period': '2023-Q4', 'orgUnit': 'Central Hospital', 'value': 450},
    {'indicator': 'Family Planning', 'period': '2023-Q1', 'orgUnit': 'District Hospital A', 'value': 280},
    {'indicator': 'Family Planning', 'period': '2023-Q2', 'orgUnit': 'District Hospital A', 'value': 310},
    {'indicator': 'Family Planning', 'period': '2023-Q3', 'orgUnit': 'District Hospital A', 'value': 340},
    {'indicator': 'Family Planning', 'period': '2023-Q4', 'orgUnit': 'District Hospital A', 'value': 390},
    {'indicator': 'Immunization', 'period': '2023-Q1', 'orgUnit': 'Health Center 1', 'value': 150},
    {'indicator': 'Immunization', 'period': '2023-Q2', 'orgUnit': 'Health Center 1', 'value': 180},
    {'indicator': 'Immunization', 'period': '2023-Q3', 'orgUnit': 'Health Center 1', 'value': 200},
    {'indicator': 'Immunization', 'period': '2023-Q4', 'orgUnit': 'Health Center 1', 'value': 220},
    {'indicator': 'Malaria Treatment', 'period': '2023-Q1', 'orgUnit': 'District Hospital B', 'value': 95},
    {'indicator': 'Malaria Treatment', 'period': '2023-Q2', 'orgUnit': 'District Hospital B', 'value': 110},
    {'indicator': 'Malaria Treatment', 'period': '2023-Q3', 'orgUnit': 'District Hospital B', 'value': 85},
    {'indicator': 'Malaria Treatment', 'period': '2023-Q4', 'orgUnit': 'District Hospital B', 'value': 130},
    {'indicator': 'HIV Testing', 'period': '2023-Q1', 'orgUnit': 'Health Center 2', 'value': 200},
    {'indicator': 'HIV Testing', 'period': '2023-Q2', 'orgUnit': 'Health Center 2', 'value': 240},
    {'indicator': 'HIV Testing', 'period': '2023-Q3', 'orgUnit': 'Health Center 2', 'value': 260},
    {'indicator': 'HIV Testing', 'period': '2023-Q4', 'orgUnit': 'Health Center 2', 'value': 300},
    {'indicator': 'TB Treatment', 'period': '2023-Q1', 'orgUnit': 'Rural Clinic A', 'value': 45},
    {'indicator': 'TB Treatment', 'period': '2023-Q2', 'orgUnit': 'Rural Clinic A', 'value': 52},
    {'indicator': 'TB Treatment', 'period': '2023-Q3', 'orgUnit': 'Rural Clinic A', 'value': 48},
    {'indicator': 'TB Treatment', 'period': '2023-Q4', 'orgUnit': 'Rural Clinic A', 'value': 60},
    {'indicator': 'Maternal Mortality', 'period': '2023-Q1', 'orgUnit': 'Central Hospital', 'value': 8},
    {'indicator': 'Maternal Mortality', 'period': '2023-Q2', 'orgUnit': 'Central Hospital', 'value': 6},
    {'indicator': 'Maternal Mortality', 'period': '2023-Q3', 'orgUnit': 'Central Hospital', 'value': 10},
    {'indicator': 'Maternal Mortality', 'period': '2023-Q4', 'orgUnit': 'Central Hospital', 'value': 7},
    {'indicator': 'Child Nutrition', 'period': '2023-Q1', 'orgUnit': 'Health Center 3', 'value': 120},
    {'indicator': 'Child Nutrition', 'period': '2023-Q2', 'orgUnit': 'Health Center 3', 'value': 135},
    {'indicator': 'Child Nutrition', 'period': '2023-Q3', 'orgUnit': 'Health Center 3', 'value': 150},
    {'indicator': 'Child Nutrition', 'period': '2023-Q4', 'orgUnit': 'Health Center 3', 'value': 165},
    {'indicator': 'Water Sanitation', 'period': '2023-Q1', 'orgUnit': 'Rural Clinic B', 'value': 75},
    {'indicator': 'Water Sanitation', 'period': '2023-Q2', 'orgUnit': 'Rural Clinic B', 'value': 82},
    {'indicator': 'Water Sanitation', 'period': '2023-Q3', 'orgUnit': 'Rural Clinic B', 'value': 90},
    {'indicator': 'Water Sanitation', 'period': '2023-Q4', 'orgUnit': 'Rural Clinic B', 'value': 98},
  ];

  final periodOptions = [
    'THIS_YEAR',
    'LAST_12_MONTHS',
    'LAST_QUARTER',
    'THIS_QUARTER',
    'LAST_MONTH',
    'THIS_MONTH',
  ];

  final aggregationTypes = [
    'SUM',
    'AVERAGE',
    'COUNT',
    'MAX',
    'MIN',
    'STDDEV',
    'VARIANCE',
  ];

  // Methods
  void toggleIndicator(Map<String, dynamic> indicator) {
    final index = selectedIndicators.indexWhere((i) => i['id'] == indicator['id']);
    if (index >= 0) {
      selectedIndicators.removeAt(index);
    } else {
      selectedIndicators.add(indicator);
    }
  }

  bool isIndicatorSelected(Map<String, dynamic> indicator) {
    return selectedIndicators.any((i) => i['id'] == indicator['id']);
  }

  void setPeriod(String period) {
    selectedPeriod.value = period;
  }

  void setOrgUnit(String orgUnitId) {
    selectedOrgUnit.value = orgUnitId;
  }

  void setAggregationType(String type) {
    aggregationType.value = type;
  }

  void clearSelection() {
    selectedIndicators.clear();
    analyticsData.clear();
  }

  void fetchAnalytics() {
    if (selectedIndicators.isEmpty) {
      Get.snackbar(
        'Warning',
        'Please select at least one indicator',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    
    // Simulate API call with delay
    Future.delayed(const Duration(seconds: 1), () {
      // Filter data based on selected indicators and org unit
      final selectedIds = selectedIndicators.map((i) => i['id']).toList();
      
      analyticsData.value = _hardcodedData.where((data) {
        final indicatorName = data['indicator'] as String;
        final matchesIndicator = selectedIds.any((id) {
          final indicator = indicators.firstWhere(
            (i) => i['id'] == id,
            orElse: () => {'name': ''},
          );
          return indicator['name'] == indicatorName;
        });
        
        final matchesOrgUnit = data['orgUnit'] == organisationUnits.firstWhere(
          (ou) => ou['id'] == selectedOrgUnit.value,
          orElse: () => {'name': ''},
        )['name'];
        
        return matchesIndicator && matchesOrgUnit;
      }).toList();
      
      isLoading.value = false;
      
      if (analyticsData.isEmpty) {
        Get.snackbar(
          'Info',
          'No data found for selected filters',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Success',
          'Loaded ${analyticsData.length} records',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    });
  }

  // Data processing methods
  List<Map<String, dynamic>> getFormattedRows() {
    if (analyticsData.isEmpty) return [];
    return analyticsData;
  }

  List<Map<String, dynamic>> getChartData() {
    if (analyticsData.isEmpty) return [];
    return analyticsData;
  }

  int get totalRecords => analyticsData.length;

  String get selectedIndicatorCount {
    return '${selectedIndicators.length} indicator${selectedIndicators.length > 1 ? 's' : ''} selected';
  }

  double calculateAverage() {
    if (analyticsData.isEmpty) return 0;
    final sum = analyticsData.fold(0.0, (sum, item) => sum + (item['value'] as num).toDouble());
    return sum / analyticsData.length;
  }

  double calculateMax() {
    if (analyticsData.isEmpty) return 0;
    return analyticsData.fold(0.0, (max, item) => 
      (item['value'] as num).toDouble() > max ? (item['value'] as num).toDouble() : max
    );
  }

  double calculateMin() {
    if (analyticsData.isEmpty) return 0;
    return analyticsData.fold(
      (analyticsData[0]['value'] as num).toDouble(), 
      (min, item) => 
        (item['value'] as num).toDouble() < min ? (item['value'] as num).toDouble() : min
    );
  }

  double calculateTotal() {
    if (analyticsData.isEmpty) return 0;
    return analyticsData.fold(0.0, (sum, item) => sum + (item['value'] as num).toDouble());
  }

  double calculateAvgPerIndicator() {
    if (analyticsData.isEmpty || selectedIndicators.isEmpty) return 0;
    final total = calculateTotal();
    return total / selectedIndicators.length;
  }
}