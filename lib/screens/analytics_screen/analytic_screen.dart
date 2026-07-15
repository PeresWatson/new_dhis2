import 'package:dhis_2/screens/analytics_screen/analytics_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalyticsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('DHIS2 Analytics'),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        actions: [
          Obx(() => IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.isLoading.value ? null : controller.fetchAnalytics,
          )),
          Obx(() => IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: controller.selectedIndicators.isEmpty ? null : controller.clearSelection,
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading analytics data...'),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildFilterSection(controller),
            Expanded(
              child: _buildResultsSection(controller),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterSection(AnalyticsController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Organisation Unit Selection
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedOrgUnit.value,
            decoration: const InputDecoration(
              labelText: 'Organisation Unit',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              prefixIcon: Icon(Icons.apartment),
            ),
            items: controller.organisationUnits.map((unit) {
              return DropdownMenuItem<String>(
                value: unit['id'],
                child: Text(unit['name']!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setOrgUnit(value);
              }
            },
          )),
          
          const SizedBox(height: 12),
          
          // Period Selection
          Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedPeriod.value,
            decoration: const InputDecoration(
              labelText: 'Period',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            items: controller.periodOptions.map((period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(period.replaceAll('_', ' ')),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setPeriod(value);
              }
            },
          )),
          
          const SizedBox(height: 12),
          
          // Aggregation Type Selection
          Obx(() => DropdownButtonFormField<String>(
            value: controller.aggregationType.value,
            decoration: const InputDecoration(
              labelText: 'Aggregation Type',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              prefixIcon: Icon(Icons.calculate),
            ),
            items: controller.aggregationTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.setAggregationType(value);
              }
            },
          )),
          
          const SizedBox(height: 12),
          
          // Indicator Selection
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Select Indicators',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        controller.selectedIndicators.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() => Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: controller.indicators.map((indicator) {
                    final bool isSelected = controller.isIndicatorSelected(indicator);
                    return FilterChip(
                      label: Text(
                        indicator['name']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => controller.toggleIndicator(indicator),
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Colors.blue,
                      checkmarkColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    );
                  }).toList(),
                )),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : controller.fetchAnalytics,
                  icon: const Icon(Icons.search),
                  label: const Text('Fetch Analytics'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.blue,
                  ),
                )),
              ),
              const SizedBox(width: 12),
              Obx(() => OutlinedButton.icon(
                onPressed: controller.selectedIndicators.isEmpty ? null : controller.clearSelection,
                icon: const Icon(Icons.clear),
                label: const Text('Clear'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection(AnalyticsController controller) {
    return Obx(() {
      if (controller.analyticsData.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No analytics data',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select indicators and click "Fetch Analytics"',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        );
      }

      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Summary bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.grey.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Records: ${controller.totalRecords}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    controller.selectedIndicatorCount,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Data Table', icon: Icon(Icons.table_chart)),
                Tab(text: 'Summary', icon: Icon(Icons.summarize)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDataTable(controller),
                  _buildSummaryView(controller),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDataTable(AnalyticsController controller) {
    final rows = controller.getFormattedRows();
    
    if (rows.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final headers = rows.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.blue.shade50,
            ),
            columns: headers.map((header) {
              return DataColumn(
                label: Text(
                  header.replaceAll('_', ' ').toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              );
            }).toList(),
            rows: rows.map((row) {
              return DataRow(
                cells: headers.map((header) {
                  return DataCell(
                    Text(row[header]?.toString() ?? '-'),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryView(AnalyticsController controller) {
    final chartData = controller.getChartData();
    
    if (chartData.isEmpty) {
      return const Center(child: Text('No data available for summary'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Summary Statistics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    title: 'Total Records',
                    value: controller.totalRecords.toString(),
                    icon: Icons.numbers,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Indicators Selected',
                    value: controller.selectedIndicators.length.toString(),
                    icon: Icons.bar_chart,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Average Value',
                    value: controller.calculateAverage().toStringAsFixed(2),
                    icon: Icons.trending_up,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Maximum Value',
                    value: controller.calculateMax().toStringAsFixed(2),
                    icon: Icons.arrow_upward,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Minimum Value',
                    value: controller.calculateMin().toStringAsFixed(2),
                    icon: Icons.arrow_downward,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Quick Stats Grid
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Stats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildQuickStatCard(
                        title: 'Total Value',
                        value: controller.calculateTotal().toStringAsFixed(2),
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                      _buildQuickStatCard(
                        title: 'Data Points',
                        value: controller.totalRecords.toString(),
                        icon: Icons.data_usage,
                        color: Colors.blue,
                      ),
                      _buildQuickStatCard(
                        title: 'Avg per Indicator',
                        value: controller.calculateAvgPerIndicator().toStringAsFixed(2),
                        icon: Icons.equalizer,
                        color: Colors.orange,
                      ),
                      _buildQuickStatCard(
                        title: 'Range',
                        value: (controller.calculateMax() - controller.calculateMin()).toStringAsFixed(2),
                        icon: Icons.compare_arrows,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}