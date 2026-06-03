// lib/features/dashboard/presentation/controllers/gis_map_provider.dart

import 'package:flutter/material.dart';

enum MapLayerType { choroplethRegions, facilityMarkers }

class GisMapProvider extends ChangeNotifier {
  bool _isLoading = false;
  MapLayerType _activeLayer = MapLayerType.choroplethRegions;
  
  bool get isLoading => _isLoading;
  MapLayerType get activeLayer => _activeLayer;

  /// Switches visual layers between polygon boundaries and coordinate dots
  void switchLayer(MapLayerType layer) {
    _activeLayer = layer;
    notifyListeners();
  }

  /// Simulates fetching geographic boundary coordinates (GeoJSON arrays) from DHIS2
  Future<void> loadGeoData() async {
    _isLoading = true;
    notifyListeners();

    // Simulating heavy GeoJSON coordinate parsing time
    await Future.delayed(const Duration(milliseconds: 900));

    _isLoading = false;
    notifyListeners();
  }
}