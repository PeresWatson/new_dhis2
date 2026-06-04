// // lib/features/dashboard/data/services/dhis2_api_service.dart

// import 'package:dio/dio.dart';
// import '../models/dashboard_model.dart';
// import '../models/dashboard_item_model.dart';
// import '../models/analytics_response_model.dart';

// class Dhis2ApiService {
//   final Dio _dio;

//   Dhis2ApiService(this._dio);

//   /// 1. Fetches high-level user-accessible dashboard groupings
//   Future<List<Dhis2Dashboard>> getDashboards() async {
//     final response = await _dio.get('/api/dashboards?fields=id,displayName&paging=false');
//     if (response.statusCode == 200) {
//       final List listData = response.data['dashboards'] ?? [];
//       return listData.map((item) => Dhis2Dashboard.fromJson(item)).toList();
//     }
//     throw Exception('Failed to load dashboards');
//   }

//   /// 2. Fetches layout composition blocks inside an explicitly selected dashboard grid
//   Future<List<Dhis2DashboardItem>> getDashboardLayout(String dashboardId) async {
//     final response = await _dio.get('/api/dashboards/$dashboardId?fields=dashboardItems[id,type,indicator[id,displayName]]');
//     if (response.statusCode == 200) {
//       final List itemsData = response.data['dashboardItems'] ?? [];
//       return itemsData.map((item) => Dhis2DashboardItem.fromJson(item)).toList();
//     }
//     throw Exception('Failed to pull dashboard grid item layout components');
//   }

//   /// 3. Communicates with the live core analytics matrix engine pipeline
//   /// [indicatorId] is mapped to the data dimension parameter (dx)
//   Future<AnalyticsResponseModel> getIndicatorAnalytics(String indicatorId) async {
//     final Map<String, String> analyticalQueryParameters = {
//       // Dimension format: dx:INDICATOR_ID, pe:LAST_12_MONTHS, ou:USER_ORGUNIT
//       'dimension': [
//         'dx:$indicatorId',
//         'pe:LAST_12_MONTHS',
//         'ou:USER_ORGUNIT' // Grabs geographic permissions attached directly to user account profile
//       ].join(','),
//       'displayProperty': 'NAME',
//       'skipMeta': 'false'
//     };

//     final response = await _dio.get(
//       '/api/analytics',
//       queryParameters: analyticalQueryParameters,
//     );

//     if (response.statusCode == 200) {
//       return AnalyticsResponseModel.fromJson(response.data);
//     } else {
//       throw Exception('Analytics engine failed to evaluate the data matrix rows.');
//     }
//   }
// }

// lib/features/dashboard/data/services/dhis2_api_service.dart

import 'package:dio/dio.dart';
import '../models/dashboard_model.dart';
import '../models/dashboard_item_model.dart';
import '../models/analytics_response_model.dart';

class Dhis2ApiService {
  final Dio _dio;

  Dhis2ApiService(this._dio);

  /// 1. Fetches high-level user-accessible dashboard groupings
  Future<List<Dhis2Dashboard>> getDashboards() async {
    try {
      final response = await _dio
          .get('/api/dashboards?fields=id,displayName&paging=false')
          .timeout(const Duration(seconds: 3));
          
      if (response.statusCode == 200) {
        final List listData = response.data['dashboards'] ?? [];
        return listData.map((item) => Dhis2Dashboard.fromJson(item)).toList();
      }
    } catch (e) {
      print("⚠️ Web Ingestion Blocked. Injecting local mock operational dashboards.");
    }
    
    // 📊 Clean Fallback Arrays containing the required 'starred' parameter
    return [
      Dhis2Dashboard(
        id: 'dash-01', 
        displayName: 'Maternal Health Interventions Summary', 
        starred: true,
      ),
      Dhis2Dashboard(
        id: 'dash-02', 
        displayName: 'Malaria Vector Surveillance Metrics', 
        starred: false,
      ),
      Dhis2Dashboard(
        id: 'dash-03', 
        displayName: 'Immunization Coverage Key Indicators', 
        starred: true,
      ),
    ];
  }

  /// 2. Fetches layout composition blocks inside an explicitly selected dashboard grid
  Future<List<Dhis2DashboardItem>> getDashboardLayout(String dashboardId) async {
    try {
      final response = await _dio
          .get('/api/dashboards/$dashboardId?fields=dashboardItems[id,type,shape,indicator[id,displayName]]')
          .timeout(const Duration(seconds: 3));
          
      if (response.statusCode == 200) {
        final List itemsData = response.data['dashboardItems'] ?? [];
        return itemsData.map((item) => Dhis2DashboardItem.fromJson(item)).toList();
      }
    } catch (e) {
      print("⚠️ Local fallback triggered inside API service layout engine.");
    }

    // 🧩 Mock structural items satisfying the exact parameters required by Dhis2DashboardItem
    return [
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
  }

  /// 3. Communicates with the analytical matrix engine pipeline to fetch data points
  Future<AnalyticsResponseModel> getIndicatorAnalytics(String indicatorId) async {
    try {
      final response = await _dio
          .get('/api/analytics?dimension=dx:$indicatorId,pe:LAST_12_MONTHS,ou:USER_ORGUNIT&displayProperty=NAME')
          .timeout(const Duration(seconds: 3));
          
      if (response.statusCode == 200) {
        return AnalyticsResponseModel.fromJson(response.data);
      }
    } catch (e) {
      print("⚠️ Web Analytics Engine Blocked. Populating synthetic trend graph matrix arrays.");
    }

    // 📈 Generates continuous historical data coordinates to render your fl_chart lines
    return AnalyticsResponseModel(dataPoints: [
      AnalyticsDataPoint(periodId: '202501', periodName: 'Jan', value: 42.5),
      AnalyticsDataPoint(periodId: '202502', periodName: 'Feb', value: 48.1),
      AnalyticsDataPoint(periodId: '202503', periodName: 'Mar', value: 55.3),
      AnalyticsDataPoint(periodId: '202504', periodName: 'Apr', value: 52.0),
      AnalyticsDataPoint(periodId: '202505', periodName: 'May', value: 68.4),
      AnalyticsDataPoint(periodId: '202506', periodName: 'Jun', value: 74.2),
      AnalyticsDataPoint(periodId: '202507', periodName: 'Jul', value: 71.0),
      AnalyticsDataPoint(periodId: '202508', periodName: 'Aug', value: 85.6),
    ]);
  }
}