// lib/features/dashboard/presentation/widgets/chart_card_widget.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/analytics_response_model.dart';
import 'dart:math' as math;

class ChartCardWidget extends StatelessWidget {
  final String title;
  final List<AnalyticsDataPoint> points;
  final bool isLoading;

  const ChartCardWidget({
    Key? key,
    required this.title,
    required this.points,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2D3748)),
            ),
            const Divider(height: 24),
            SizedBox(
              height: 180,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF1D5288)))
                  : points.isEmpty
                      ? const Center(child: Text('No historical values found for this period context.', style: TextStyle(color: Colors.grey, fontSize: 12)))
                      : LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20),
                            titlesData: FlTitlesData(
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (val, meta) {
                                    int index = val.toInt();
                                    if (index >= 0 && index < points.length && index % 2 == 0) {
                                      // Return clean truncated text representations for x-axis layout aesthetics
                                      final rawName = points[index].periodName;
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 6.0),
                                        child: Text(rawName.substring(0, math.min(3, rawName.length)), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: points.asMap().entries.map((entry) {
                                  return FlSpot(entry.key.toDouble(), entry.value.value);
                                }).toList(),
                                isCurved: true,
                                color: const Color(0xFF1D5288), // DHIS2 Brand Contrast Line
                                barWidth: 3,
                                dotData: const FlDotData(show: true),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: const Color(0xFF1D5288).withOpacity(0.12), // Smooth foundational card tint gradient
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}