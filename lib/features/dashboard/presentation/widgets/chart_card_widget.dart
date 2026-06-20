// lib/features/dashboard/presentation/widgets/chart_card_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/analytics_response_model.dart';

class ChartCardWidget extends StatelessWidget {
  final String title;
  final String chartType; // e.g., 'LINE_CHART' or 'BAR_CHART'
  final List<AnalyticsDataPoint> points;

  const ChartCardWidget({
    super.key,
    required this.title,
    required this.chartType,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBarChart = chartType == 'BAR_CHART';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header Label Block
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isBarChart ? const Color(0xFFE67E22) : const Color(0xFF1D5288),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isBarChart ? 'Bar Chart Representation' : 'Continuous Line Progression',
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Core Visual Canvas Matrix
            SizedBox(
              height: 180,
              child: points.isEmpty
                  ? const Center(child: Text('No analytical tracking data available.'))
                  : isBarChart
                      ? _buildBarGraphCanvas() // Render Bar Stacks
                      : _buildLineGraphCanvas(), // Render Line Vectors
            ),
          ],
        ),
      ),
    );
  }

  // 📈 Renders standard line trends
  Widget _buildLineGraphCanvas() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
        titlesData: _buildSharedAxisTitles(),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
            isCurved: true,
            color: const Color(0xFF1D5288),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: const Color(0xFF1D5288).withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }

  // 📊 Renders high-performance corporate bar graphs
  Widget _buildBarGraphCanvas() {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
        titlesData: _buildSharedAxisTitles(),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: 100,
        barGroups: points.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
  toY: e.value.value,
  color: const Color(0xFFE67E22),
  width: 14,
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(4),
    topRight: Radius.circular(4),
  ),
  backDrawRodData: BackgroundBarChartRodData(
    show: true,
    toY: 100,
    color: Colors.grey.withOpacity(0.1),
  ),
),
            ],
          );
        }).toList(),
      ),
    );
  }

  // 🛠️ Shared axis ticks styling rules
  FlTitlesData _buildSharedAxisTitles() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          getTitlesWidget: (val, _) => Text('${val.toInt()}%', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          reservedSize: 32,
        ),
      ),
      // Inside lib/features/dashboard/presentation/widgets/chart_card_widget.dart

      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (val, _) {
            int index = val.toInt();
            if (index >= 0 && index < points.length) {
              return Padding(
                // 🔑 CHANGE THIS LINE:
                padding: const EdgeInsets.only(top: 6.0), 
                child: Text(
                  points[index].periodName, 
                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              );
            }
            return const Text('');
          },
          reservedSize: 24,
        ),
      ),
    );
  }
}