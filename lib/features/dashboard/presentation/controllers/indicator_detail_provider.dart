// lib/features/dashboard/presentation/controllers/indicator_detail_provider.dart

import 'package:flutter/material.dart';
import '../../data/models/analytics_payload_model.dart';

class IndicatorDetailProvider extends ChangeNotifier {
  AnalyticsPayloadModel? _payload;
  bool _isLoading = false;
  bool _showTargetLine = true;

  AnalyticsPayloadModel? get payload => _payload;
  bool get isLoading => _isLoading;
  bool get showTargetLine => _showTargetLine;

  /// Pulls individual visualization trends from the data layer service
  Future<void> loadIndicatorDetails(String visualId) async {
    _isLoading = true;
    notifyListeners();

    // Simulating deep REST endpoint analytics lookup aggregation time
    await Future.delayed(const Duration(milliseconds: 700));
    _payload = AnalyticsPayloadModel.fromMock();
    
    _isLoading = false;
    notifyListeners();
  }

  /// Toggles visibility overlay of target benchmarks inside line graphics
  void toggleTargetVisibility() {
    _showTargetLine = !_showTargetLine;
    notifyListeners();
  }
}