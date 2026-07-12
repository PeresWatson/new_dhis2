import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/utils/findMaximunInteger.dart';
import 'package:dhis_2/utils/stringShortForm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // if you're using GetX

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    Get.find<HomeController>().selectedVisualizationIndex = Get.find<HomeController>().dashboardVisualizations.indexOf(item);

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
          (1 == 1)
              ? Expanded(
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
                )
              : Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
                        ),
                        alignment: BarChartAlignment.spaceAround,
                        maxY:
                            (double.tryParse(findMaxValue(item['data']["series"][0]['data']).toString())! * 1.1), // Add some padding to the max value
                        minY: 0,
                        gridData: FlGridData(show: true, drawHorizontalLine: true),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipPadding: const EdgeInsets.all(2),
                            tooltipMargin: 3,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${item['data']["categories"][group.x.toInt()] ?? "Category"}\n${rod.toY}',
                                const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            axisNameWidget: Text(
                              '${item['data']["series"][0]['name'] ?? "Value"}',
                              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                            ),
                            axisNameSize: 35,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, meta) => value.toString() == '0' ? const Text('') : Text(formatNumberShort(value.toString())),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            axisNameWidget: Text('${item["indicatorName"] ?? "Category"}'),
                            axisNameSize: 35,
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                var dataList = item['data']["categories"] ?? [];
                                if (index >= 0 && index < dataList.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(dataList[index].toString(), style: const TextStyle(fontSize: 11)),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        barGroups: [
                          for (var i = 0; i < (item['data']["series"][0]['data']?.length ?? 0); i++)
                            BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: double.tryParse(item['data']["series"][0]['data'][i].toString()) ?? 0,
                                  color: Colors.blueAccent,
                                  width: 20,
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                ),
                              ],
                            ),
                        ],
                      ),
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
