import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:dhis_2/screens/home/home_screen_controller.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    controller.selectedVisualizationIndex.value =
        controller.dashboardVisualizations.indexOf(item);

    final List<dynamic> categories =
        item['data']?['categories'] ?? [];

    return Container(
      height: 400,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item['title'] ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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

          Text(
            item['description'] ?? '',
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: SfCircularChart(
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                format: 'point.x : point.y%',
              ),

              legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),

              series: <CircularSeries>[
                PieSeries<Map<String, dynamic>, String>(
                  dataSource:
                      List<Map<String, dynamic>>.from(categories),

                  xValueMapper: (data, _) =>
                      data['name']?.toString() ?? '',

                  yValueMapper: (data, _) =>
                      (data['value'] as num?)?.toDouble() ?? 0,

                  dataLabelMapper: (data, _) =>
                      '${data['name']} (${data['value']}%)',

                  dataLabelSettings:
                      const DataLabelSettings(
                    isVisible: true,
                    labelPosition:
                        ChartDataLabelPosition.outside,
                  ),

                  enableTooltip: true,

                  explode: true,
                  explodeIndex: 0,
                ),
              ],
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
            child: PieChartWidget(item: item), // Reuse your existing chart
          ),
        ),
      ),
    ),
  );
}
