// lib/features/dashboard/presentation/screens/gis_map_screen.dart

import 'package:flutter/material.dart';
import '../controllers/gis_map_provider.dart';

class GisMapScreen extends StatefulWidget {
  final GisMapProvider provider;

  const GisMapScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<GisMapScreen> createState() => _GisMapScreenState();
}

class _GisMapScreenState extends State<GisMapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.loadGeoData();
    });
    widget.provider.addListener(_updateMapUi);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_updateMapUi);
    super.dispose();
  }

  void _updateMapUi() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.provider;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D5288),
        title: const Text('GIS Regional Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          // 1. Base Map Layer Mock Area (In prod, wrap 'flutter_map' tile layer here)
          Container(
            color: const Color(0xFFE5E9F0), // Standard geographic background canvas tint
            child: Center(
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF1D5288))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          state.activeLayer == MapLayerType.choroplethRegions 
                              ? Icons.map_rounded 
                              : Icons.location_on_rounded, 
                          size: 72, 
                          color: const Color(0xFF1D5288).withOpacity(0.6),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.activeLayer == MapLayerType.choroplethRegions
                              ? 'Rendering District Boundary Polygons...'
                              : 'Plotting Health Facility GPS Coordinates...',
                          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
            ),
          ),

          // 2. Floating Zoom Controllers (Top Left)
          Positioned(
            top: 16,
            left: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'zoom_in',
                  backgroundColor: Colors.white,
                  onPressed: () {},
                  child: const Icon(Icons.add, color: Color(0xFF1D5288)),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom_out',
                  backgroundColor: Colors.white,
                  onPressed: () {},
                  child: const Icon(Icons.remove, color: Color(0xFF1D5288)),
                ),
              ],
            ),
          ),

          // 3. Floating Dynamic Legend Card (Top Right)
          Positioned(
            top: 16,
            right: 16,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Legend: BCG Coverage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                    const SizedBox(height: 8),
                    _buildLegendItem(Colors.green.shade600, 'Target Achieved (>90%)'),
                    const SizedBox(height: 4),
                    _buildLegendItem(Colors.amber.shade600, 'Warning Zone (50% - 80%)'),
                    const SizedBox(height: 4),
                    _buildLegendItem(Colors.red.shade600, 'Critical Drop Alert (<50%)'),
                  ],
                ),
              ),
            ),
          ),

          // 4. Floating Layer Action Button (Bottom Right)
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              backgroundColor: const Color(0xFF1D5288),
              icon: const Icon(Icons.layers_rounded, color: Colors.white),
              label: const Text('Switch Layer', style: TextStyle(color: Colors.white)),
              onPressed: () {
                final nextLayer = state.activeLayer == MapLayerType.choroplethRegions
                    ? MapLayerType.facilityMarkers
                    : MapLayerType.choroplethRegions;
                state.switchLayer(nextLayer);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 11, color: Color(0xFF2D3748))),
      ],
    );
  }
}