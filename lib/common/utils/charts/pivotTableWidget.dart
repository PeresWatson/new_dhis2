import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:dhis_2/screens/home/home_screen_controller.dart';

class PivotTableWidget extends StatelessWidget {
  const PivotTableWidget({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    controller.selectedVisualizationIndex.value = controller.dashboardVisualizations.indexOf(item);

    final List<dynamic> columns = item['data']['columns'] ?? [];

    final List<dynamic> rows = item['data']['rows'] ?? [];

    final List<dynamic> tableData = item['data']['data'] ?? [];

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
              Get.find<HomeController>().isfullScreenTable.value
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Get.find<HomeController>().isfullScreenTable.value = false;
                        // Restore to Portrait when closing
                        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                        Navigator.pop(context);
                      },
                    )
                  : PopupMenuButton<String>(
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
            child: Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey.shade200),

                    columns: [
                      const DataColumn(
                        label: Text('District', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),

                      ...columns.map(
                        (column) => DataColumn(
                          label: Text(column.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],

                    rows: List.generate(rows.length, (rowIndex) {
                      return DataRow(
                        cells: [
                          DataCell(Text(rows[rowIndex].toString(), style: const TextStyle(fontWeight: FontWeight.w600))),

                          ...List.generate(columns.length, (columnIndex) {
                            return DataCell(Text(tableData[rowIndex][columnIndex].toString()));
                          }),
                        ],
                      );
                    }),
                  ),
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
  Get.find<HomeController>().isfullScreenLineChart.value = true;
  Get.find<HomeController>().isfullScreenBarChart.value = true;
  Get.find<HomeController>().isfullScreenPieChart.value = true;
  Get.find<HomeController>().isfullScreenTable.value = true;
  Get.find<HomeController>().isfullScreenMap.value = true;
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (context) => Dialog.fullscreen(
      child: PivotTableWidget(item: item), // Reuse your existing chart
    ),
  );
}
