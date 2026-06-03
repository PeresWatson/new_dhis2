// In lib/features/dashboard/data/services/dhis2_api_service.dart

import 'package:dio/dio.dart';
import '../models/dashboard_model.dart';

class Dhis2ApiService {
  final Dio _dio; // Concrete Authenticated Dio Client Dependency

  Dhis2ApiService(this._dio);

  Future<List<Dhis2Dashboard>> getDashboards() async {
    // Notice how we don't pass headers or base URLs here anymore! The interceptor adds them.
    final response = await _dio.get('/api/dashboards?fields=id,displayName,starred&paging=false');
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;
      final List listData = data['dashboards'] ?? [];
      return listData.map((item) => Dhis2Dashboard.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch dashboard collections from instance server.');
    }
  }
}