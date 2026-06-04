// lib/features/dashboard/presentation/controllers/indicator_detail_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/analytics_response_model.dart';

enum IndicatorStatus { loading, success, error }

class IndicatorDetailProvider extends ChangeNotifier {
  IndicatorStatus _status = IndicatorStatus.loading;
  String _indicatorName = 'ANC 4th+ Visit Coverage Performance (%)';
  String _indicatorDefinition = 'Percentage of pregnant women who attended at least 4 Antenatal Care visits during their pregnancy term.';
  List<AnalyticsDataPoint> _historicalPoints = [];
  Map<String, double> _regionalBreakdown = {};

  IndicatorDetailProvider() {
    loadDetailedIndicatorData();
  }

  // Getters exposed directly to the Indicator Screen layout wrapper
  IndicatorStatus get status => _status;
  bool get isLoading => _status == IndicatorStatus.loading;
  String get indicatorName => _indicatorName;
  String get indicatorDefinition => _indicatorDefinition;
  List<AnalyticsDataPoint> get historicalPoints => _historicalPoints;
  Map<String, double> get regionalBreakdown => _regionalBreakdown;

  /// Simulates fetching deeply-nested analytical matrix layouts
  Future<void> loadDetailedIndicatorData() async {
    _status = IndicatorStatus.loading;
    notifyListeners();

    // Simulate standard mobile network transport delay
    await Future.delayed(const Duration(milliseconds: 600));

    try {
      // 📈 1. Continuous 12-Month Analytical Timeline Data
      _historicalPoints = [
        AnalyticsDataPoint(periodId: '202501', periodName: 'Jan 25', value: 45.2),
        AnalyticsDataPoint(periodId: '202502', periodName: 'Feb 25', value: 48.0),
        AnalyticsDataPoint(periodId: '202503', periodName: 'Mar 25', value: 52.6),
        AnalyticsDataPoint(periodId: '202504', periodName: 'Apr 25', value: 61.1),
        AnalyticsDataPoint(periodId: '202505', periodName: 'May 25', value: 58.4),
        AnalyticsDataPoint(periodId: '202506', periodName: 'Jun 25', value: 72.3),
        AnalyticsDataPoint(periodId: '202507', periodName: 'Jul 25', value: 75.0),
        AnalyticsDataPoint(periodId: '202508', periodName: 'Aug 25', value: 81.9),
        AnalyticsDataPoint(periodId: '202509', periodName: 'Sep 25', value: 79.2),
        AnalyticsDataPoint(periodId: '202510', periodName: 'Oct 25', value: 84.5),
        AnalyticsDataPoint(periodId: '202511', periodName: 'Nov 25', value: 88.0),
        AnalyticsDataPoint(periodId: '202512', periodName: 'Dec 25', value: 92.4),
      ];

      // 🗺️ 2. Sub-Organizational Unit Breakdown (Regional Analytics Context)
      _regionalBreakdown = {
        'Dar es Salaam Zone': 89.5,
        'Mwanza Lake District': 74.2,
        'Dodoma Central Region': 68.9,
        'Arusha Northern Highlands': 81.4,
        'Mbeya Southern Highlands': 65.1,
      };

      _status = IndicatorStatus.success;
    } catch (e) {
      _status = IndicatorStatus.error;
    }
    notifyListeners();
  }
}