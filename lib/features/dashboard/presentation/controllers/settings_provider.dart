// lib/features/dashboard/presentation/controllers/settings_provider.dart

import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  // Configured default preference values
  bool _syncWifiOnly = true;
  double _cacheSizeMb = 14.24; 
  final String _connectedServerUrl = "https://play.dhis2.org/demo";

  // Getters for data binding
  bool get syncWifiOnly => _syncWifiOnly;
  double get cacheSizeMb => _cacheSizeMb;
  String get connectedServerUrl => _connectedServerUrl;

  /// Toggles background synchronization constraints
  void toggleWifiSync(bool value) {
    _syncWifiOnly = value;
    notifyListeners();
    // In production, save this preference persistently via SharedPreferences
  }

  /// Erases heavy analytics JSON tables from the local Isar/Hive database
  Future<void> clearLocalCache() async {
    // Simulating database transaction delay
    await Future.delayed(const Duration(milliseconds: 400));
    _cacheSizeMb = 0.00;
    notifyListeners();
  }

  /// Explicitly runs background background sync loops immediately
  Future<void> triggerManualSync() async {
    await Future.delayed(const Duration(seconds: 1));
    _cacheSizeMb = 18.45; // Simulates refetching fresh evaluation payloads
    notifyListeners();
  }
}