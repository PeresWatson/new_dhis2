import 'dart:convert';
import '../models/dashboard_model.dart';
import '../models/dashboard_item_model.dart';

class Dhis2ApiService {
  // Simulating an authenticated HTTP client base for this layer
  final dynamic _httpClient; 

  Dhis2ApiService(this._httpClient);

  /// Hits /api/dashboards to retrieve available selections
  Future<List<Dhis2Dashboard>> getDashboards() async {
    // In production, your client appends the full base URL: https://your-instance.org/api/dashboards...
    const endpoint = '/api/dashboards?fields=id,displayName,starred&paging=false';
    
    // Simulating a network handshake delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // This mock string perfectly mirrors a live production response payload format from DHIS2
    const mockJsonRaw = '''
    {
      "dashboards": [
        {"id": "vUreYmYr628", "displayName": "Maternal Health Indicators", "starred": true},
        {"id": "ed7v5g7V243", "displayName": "HIV/AIDS Program", "starred": false},
        {"id": "qFX6Uh0B2W6", "displayName": "Immunization Coverage", "starred": true}
      ]
    }
    ''';

    final data = jsonDecode(mockJsonRaw);
    final List listData = data['dashboards'] ?? [];
    return listData.map((item) => Dhis2Dashboard.fromJson(item)).toList();
  }

  /// Hits /api/dashboards/{id} to ingest a single layout blueprint setup
  Future<List<Dhis2DashboardItem>> getDashboardLayout(String dashboardId) async {
    final endpoint = '/api/dashboards/$dashboardId?fields=dashboardItems[id,type,shape,chart[id,displayName],visualization[id,displayName],map[id,displayName]]';
    
    await Future.delayed(const Duration(milliseconds: 800));

    // Dynamic mock response simulating the elements nested inside "Maternal Health Indicators"
    const mockLayoutRaw = '''
    {
      "dashboardItems": [
        {
          "id": "c103245455",
          "type": "CHART",
          "shape": "NORMAL",
          "chart": {"id": "b0239485", "displayName": "ANC 1st Visit Coverage (Last 12 Months)"}
        },
        {
          "id": "t932482344",
          "type": "REPORT_TABLE",
          "shape": "NORMAL",
          "reportTable": {"id": "g3942384", "displayName": "OPD Visits Trend by Age Group"}
        }
      ]
    }
    ''';

    final data = jsonDecode(mockLayoutRaw);
    final List itemsList = data['dashboardItems'] ?? [];
    return itemsList.map((item) => Dhis2DashboardItem.fromJson(item)).toList();
  }
}