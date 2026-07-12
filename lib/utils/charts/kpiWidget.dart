import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:dhis_2/screens/home/home_screen_controller.dart';

class KPIWidget extends StatelessWidget {
  const KPIWidget({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    controller.selectedVisualizationIndex =
        controller.dashboardVisualizations.indexOf(item);

    final data = item['data'];

    final double value =
        (data['value'] as num?)?.toDouble() ?? 0;

    final double previousValue =
        (data['previousValue'] as num?)?.toDouble() ?? 0;

    final double target =
        (data['target'] as num?)?.toDouble() ?? 0;

    final String unit =
        data['unit']?.toString() ?? '';

    final String trend =
        data['trend']?.toString() ?? '';

    IconData trendIcon = Icons.remove;

    Color trendColor = Colors.grey;

    if (trend == 'up') {
      trendIcon = Icons.arrow_upward;
      trendColor = Colors.green;
    } else if (trend == 'down') {
      trendIcon = Icons.arrow_downward;
      trendColor = Colors.red;
    }

    final progress =
        target > 0 ? (value / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      height: 260,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            item['title'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            item['description'] ?? '',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),

          const Spacer(),

          Center(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  trendIcon,
                  color: trendColor,
                  size: 30,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius:
                BorderRadius.circular(20),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    previousValue
                        .toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Previous',
                  ),
                ],
              ),

              Column(
                children: [
                  Text(
                    target.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Target',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
