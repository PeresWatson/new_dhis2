import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:dhis_2/screens/home/home_screen_controller.dart';

class MapVisualizationWidget extends StatelessWidget {
   MapVisualizationWidget({super.key, required this.item});

  final Map<String, dynamic> item;
  final MapController mapController = MapController();
  final List<Color> _markerColors = [
  Colors.blue,
  Colors.orange,
  Colors.red,
  Colors.green,
  Colors.purple,
  Colors.teal,
  Colors.indigo,
  Colors.pink,
];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    controller.selectedVisualizationIndex = controller.dashboardVisualizations.indexOf(item);

    final List<dynamic> layers = item['data']?['layers'] ?? [];

    return Container(
      height: 450,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // You can add your PopupMenuButton here later
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'pie',
                    child: ListTile(leading: Icon(Icons.pie_chart), title: Text('View as Pie Chart')),
                  ),
                  const PopupMenuItem<String>(
                    value: 'bar',
                    child: ListTile(leading: Icon(Icons.bar_chart), title: Text('View as Bar Chart')),
                  ),
                  const PopupMenuItem<String>(
                    value: 'pivot',
                    child: ListTile(leading: Icon(Icons.table_chart), title: Text('View as Pivot Table')),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'fullscreen',
                    child: ListTile(leading: Icon(Icons.fullscreen), title: Text('Show in Full Screen')),
                  ),
                ],
                onSelected: (String value) {
                  switch (value) {
                    case 'pie':
                      // TODO: Navigate or change visualization to Pie Chart
                      // Get.find<HomeController>().changeVisualization(item, 'pie');
                      break;
                    case 'bar':
                      // TODO: Change to Bar Chart
                      // Get.find<HomeController>().changeVisualization(item, 'bar');
                      break;
                    case 'pivot':
                      // TODO: Show as Pivot Table
                      // Get.find<HomeController>().changeVisualization(item, 'pivot');
                      break;
                    case 'fullscreen':
                      // TODO: Open full screen view
                      _showFullScreenDialog(context, item);
                      break;
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 6),

          Text(item['description'] ?? '', style: TextStyle(color: Colors.grey.shade700)),

          const SizedBox(height: 12),

          Expanded(
  child: Column(
    children: [
      Expanded(
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(
                  layers.isNotEmpty
                      ? layers.first['latitude']
                      : 8.5,
                  layers.isNotEmpty
                      ? layers.first['longitude']
                      : -11.5,
                ),
                zoom: 7,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.dhis2',
                ),

                MarkerLayer(
                  markers: List.generate(
                    layers.length,
                    (index) {
                      final layer = layers[index];
                      final value =
                          (layer['value'] as num).toDouble();

                      final markerColor =
                          _markerColors[
                              index %
                              _markerColors.length];

                      return Marker(
                        point: LatLng(
                          layer['latitude'],
                          layer['longitude'],
                        ),
                        width: 70,
                        height: 70,
                        builder: (context) => Tooltip(
                          message:
                              '${layer['district']}\n${value.toStringAsFixed(0)}%',
                          child: Container(
                            decoration: BoxDecoration(
                              color: markerColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${value.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              right: 12,
              top: 12,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        mapController.move(
                          mapController.center,
                          mapController.zoom + 1,
                        );
                      },
                    ),
                    const Divider(height: 1),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        mapController.move(
                          mapController.center,
                          mapController.zoom - 1,
                        );
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Wrap(
          spacing: 24,
          runSpacing: 12,
          children: List.generate(
            layers.length,
            (index) {
              final layer = layers[index];

              final markerColor =
                  _markerColors[
                      index % _markerColors.length];

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: markerColor,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    '${layer['district']} (${layer['value']}%)',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ],
  ),
)
        ],
      ),
    );
  }

  Color _getColor(double value) {
    if (value >= 90) {
      return Colors.green;
    }

    if (value >= 80) {
      return Colors.orange;
    }

    return Colors.red;
  }
}

void _showFullScreenDialog(BuildContext context, Map<String, dynamic> item) {
  // Force Landscape mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (context) => Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Restore to Portrait when closing
                SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.grey[100],
          child: Center(
            child: MapVisualizationWidget(item: item), // Reuse your existing chart
          ),
        ),
      ),
    ),
  );
}
