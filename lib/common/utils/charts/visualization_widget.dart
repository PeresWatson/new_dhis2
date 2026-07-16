import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class VisualizationWidget extends StatefulWidget {
  final Map<String, dynamic> item;

  VisualizationWidget({super.key, required this.item});

  @override
  State<VisualizationWidget> createState() => _VisualizationWidgetState();
}

class _VisualizationWidgetState extends State<VisualizationWidget> {
  late String currentType;

  @override
  void initState() {
    super.initState();

    currentType = widget.item['defaultRenderType'] ?? 'line';
  }

  @override
  Widget build(BuildContext context) {
    final availableTypes = List<String>.from(widget.item['availableRenderTypes'] ?? []);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.item['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(widget.item['description'] ?? ''),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                setState(() {
                  currentType = value;
                });
              },
              itemBuilder: (_) => availableTypes.map((type) {
                return PopupMenuItem<String>(
                  value: type,
                  child: Row(children: [Icon(_icon(type), size: 18), const SizedBox(width: 8), Text(_title(type))]),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          SizedBox(
            height: 400,
            child: Padding(padding: const EdgeInsets.all(12), child: _buildVisualization()),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualization() {
    switch (currentType) {
      case 'line':
        return _buildLineChart();

      case 'bar':
        return _buildBarChart();

      case 'pie':
        return _buildPieChart();

      case 'map':
        return _buildMap();

      case 'pivot':
      case 'table':
        return _buildPivot();

      default:
        return const Center(child: Text('Unsupported visualization'));
    }
  }

  Widget _buildLineChart() {
    final categories = List<String>.from(widget.item['data']['categories']);

    final series = List<Map<String, dynamic>>.from(widget.item['data']['series']);

    return SfCartesianChart(
      legend: const Legend(isVisible: true,position: LegendPosition.bottom,),
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: series.map((s) {
        final values = List<num>.from(s['values']);

        return LineSeries<_ChartPoint, String>(
          name: s['name'],
          dataSource: List.generate(categories.length, (i) => _ChartPoint(categories[i], values[i].toDouble())),
          xValueMapper: (p, _) => p.label,
          yValueMapper: (p, _) => p.value,
          markerSettings: const MarkerSettings(isVisible: true),
        );
      }).toList(),
    );
  }

  Widget _buildBarChart() {
    final categories = List<String>.from(widget.item['data']['categories']);

    final series = List<Map<String, dynamic>>.from(widget.item['data']['series']);

    return SfCartesianChart(
      legend: const Legend(isVisible: true,position: LegendPosition.bottom,),
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: series.map((s) {
        final values = List<num>.from(s['values']);

        return ColumnSeries<_ChartPoint, String>(
          name: s['name'],
          dataSource: List.generate(categories.length, (i) => _ChartPoint(categories[i], values[i].toDouble())),
          xValueMapper: (p, _) => p.label,
          yValueMapper: (p, _) => p.value,
        );
      }).toList(),
    );
  }

  Widget _buildPieChart() {
    final series = List<Map<String, dynamic>>.from(widget.item['data']['series']);

    final pieData = series.map((s) {
      final values = List<num>.from(s['values']);

      return _PieData(s['name'], values.last.toDouble());
    }).toList();

    return SfCircularChart(
      legend: const Legend(isVisible: true,position: LegendPosition.bottom,),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <PieSeries<_PieData, String>>[
        PieSeries<_PieData, String>(
          dataSource: pieData,
          xValueMapper: (d, _) => d.name,
          yValueMapper: (d, _) => d.value,
          dataLabelMapper: (d, _) => '${d.name} (${d.value.toStringAsFixed(0)})',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildMap() {
    final MapController mapController = MapController();

    final List<Color> _markerColors = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal, Colors.brown, Colors.pink];

    final locations = List<Map<String, dynamic>>.from(widget.item['data']['locations'] ?? []);

    if (locations.isEmpty) {
      return const Center(child: Text('No map data available'));
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(initialCenter: LatLng(locations.first['latitude'], locations.first['longitude']), initialZoom: 7),
                children: [
                  TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.example.dhis2'),

                  MarkerLayer(
                    markers: List.generate(locations.length, (index) {
                      final location = locations[index];

                      final value = (location['value'] as num).toDouble();

                      final markerColor = _markerColors[index % _markerColors.length];

                      return Marker(
                        point: LatLng(location['latitude'], location['longitude']),
                        width: 70,
                        height: 70,
                        child: Tooltip(
                          message: '${location['name']}\n${value.toStringAsFixed(0)}%',
                          child: Container(
                            decoration: BoxDecoration(
                              color: markerColor,
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${value.toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              Positioned(
                right: 12,
                top: 12,
                child: Card(
                  elevation: 3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          mapController.move(mapController.camera.center, mapController.camera.zoom + 1);
                        },
                      ),

                      const Divider(height: 1),

                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          mapController.move(mapController.camera.center, mapController.camera.zoom - 1);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            children: List.generate(locations.length, (index) {
              final location = locations[index];

              final markerColor = _markerColors[index % _markerColors.length];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(color: markerColor, shape: BoxShape.circle),
                  ),

                  const SizedBox(width: 8),

                  Text(location['name'], style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPivot() {
    final categories = List<String>.from(widget.item['data']['categories']);

    final series = List<Map<String, dynamic>>.from(widget.item['data']['series']);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text('District')),
          ...categories.map((e) => DataColumn(label: Text(e))),
        ],
        rows: series.map((s) {
          final values = List<num>.from(s['values']);

          return DataRow(cells: [DataCell(Text(s['name'])), ...values.map((v) => DataCell(Text(v.toString())))]);
        }).toList(),
      ),
    );
  }

  Widget _legend(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  Color _getColor(double value) {
    if (value >= 85) {
      return Colors.green;
    }

    if (value >= 75) {
      return Colors.orange;
    }

    return Colors.red;
  }

  IconData _icon(String type) {
    switch (type) {
      case 'line':
        return Icons.show_chart;

      case 'bar':
        return Icons.bar_chart;

      case 'pie':
        return Icons.pie_chart;

      case 'map':
        return Icons.map;

      case 'pivot':
      case 'table':
        return Icons.table_chart;

      default:
        return Icons.insert_chart;
    }
  }

  String _title(String type) {
    switch (type) {
      case 'line':
        return 'Line Chart';

      case 'bar':
        return 'Bar Chart';

      case 'pie':
        return 'Pie Chart';

      case 'map':
        return 'Map';

      case 'pivot':
      case 'table':
        return 'Pivot Table';

      default:
        return type;
    }
  }
}

class _ChartPoint {
  final String label;
  final double value;

  _ChartPoint(this.label, this.value);
}

class _PieData {
  final String name;
  final double value;

  _PieData(this.name, this.value);
}
