// lib/features/dashboard/presentation/widgets/chart_card_widget.dart

import 'package:flutter/material.dart';

class ChartCardWidget extends StatelessWidget {
  final String title;

  const ChartCardWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      clipBehavior: Clip.antiAlias, // Ensures clean rounded edges
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card Upper Header Band
          Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  decoration: BoxDecoration(
    color: const Color(0xFFF8FAFC),
    border: Border(
      bottom: BorderSide(color: Colors.grey.shade200),
    ),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
            fontSize: 14,
          ),
        ),
      ),
      Icon(Icons.more_horiz, color: Colors.grey, size: 20),
    ],
  ),
),
          
          // Card Inner Visual Component Field
          Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded, size: 48, color: Colors.blue.shade300),
                  const SizedBox(height: 8),
                  Text(
                    'Chart Visual Engine Canvas',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500),
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