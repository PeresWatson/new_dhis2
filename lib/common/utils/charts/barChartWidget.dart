import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/common/utils/methods/findMaximunInteger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // if you're using GetX

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key, required this.item});
  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    Get.find<HomeController>().selectedVisualizationIndex.value = Get.find<HomeController>().dashboardVisualizations.indexOf(item);

    return Container(
      height: 400,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Header with Title + Three-dot Menu
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
          Text(
            item['description'],
            style: TextStyle(color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.normal, fontSize: 14),
          ),
          const SizedBox(height: 12),

          // Bar Chart Area
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                tooltipBehavior: TooltipBehavior(enable: true, header: '', format: 'point.x : point.y'),
                primaryXAxis: CategoryAxis(title: AxisTitle(text: item["indicatorName"] ?? "Category"), labelRotation: -65),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: item['data']["series"][0]['name'] ?? "Value"),
                  minimum: 0,
                  maximum: (double.tryParse(findMaxValue(item['data']["series"][0]['data']).toString()) ?? 0) * 1.1,
                ),
                series: <CartesianSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: List.generate(
                      item['data']["series"][0]['data'].length,
                      (index) => {
                        'category': item['data']["categories"][index].toString(),
                        'value': double.tryParse(item['data']["series"][0]['data'][index].toString()) ?? 0,
                      },
                    ),
                    xValueMapper: (data, _) => data['category'],
                    yValueMapper: (data, _) => data['value'],
                    dataLabelSettings: const DataLabelSettings(isVisible: false),
                    enableTooltip: true,
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
            child: BarChartWidget(item: item), // Reuse your existing chart
          ),
        ),
      ),
    ),
  );
}
