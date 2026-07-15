import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatelessWidget {
  LineChartWidget({super.key, required this.item});

  final HomeController homeController = Get.find<HomeController>();

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    homeController.selectedVisualizationIndex.value = homeController.dashboardVisualizations.indexOf(item);

    return Container(
      height: 400, // ← You can increase this safely now
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Text(
                item['description'],
                style: TextStyle(color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.normal, fontSize: 14),
              ),
              const SizedBox(height: 12),
            ],
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                tooltipBehavior: TooltipBehavior(enable: true, header: '', format: 'point.x : point.y'),
                primaryXAxis: CategoryAxis(
                   edgeLabelPlacement: EdgeLabelPlacement.shift,
                  title: AxisTitle(text: item['data']["xAxisLabel"] ?? ''),
                  labelRotation: -80,
                  interval: 1,
                ),

                primaryYAxis: NumericAxis(title: AxisTitle(text: item['data']["yAxisLabel"] ?? ''), minimum: 0, numberFormat: null),

                series: <CartesianSeries>[
                  LineSeries<Map<String, dynamic>, String>(
                    name: '',
                    enableTooltip: true,
                    dataSource: List<Map<String, dynamic>>.from(item['data']["series"][0]['data'] ?? []),
                    xValueMapper: (data, _) => data['label']?.toString() ?? '',
                    yValueMapper: (data, _) => (data['value'] as num?)?.toDouble() ?? 0,
                    markerSettings: const MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
            child: LineChartWidget(item: item), // Reuse your existing chart
          ),
        ),
      ),
    ),
  );
}
