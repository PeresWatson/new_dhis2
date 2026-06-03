// lib/features/dashboard/presentation/screens/indicator_detail_screen.dart

import 'package:flutter/material.dart';
import '../controllers/indicator_detail_provider.dart';

class IndicatorDetailScreen extends StatefulWidget {
  final String visualId;
  final IndicatorDetailProvider provider;

  const IndicatorDetailScreen({
    Key? key,
    required this.visualId,
    required this.provider,
  }) : super(key: key);

  @override
  State<IndicatorDetailScreen> createState() => _IndicatorDetailScreenState();
}

class _IndicatorDetailScreenState extends State<IndicatorDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.loadIndicatorDetails(widget.visualId);
    });
    widget.provider.addListener(_refreshUi);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_refreshUi);
    super.dispose();
  }

  void _refreshUi() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.provider;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D5288),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Detailed Indicator View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(state.showTargetLine ? Icons.visibility_rounded : Icons.visibility_off_rounded, color: Colors.white),
            tooltip: 'Toggle Benchmark Target Line',
            onPressed: () => state.toggleTargetVisibility(),
          ),
        ],
      ),
      body: state.isLoading || state.payload == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1D5288)))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. KPI Title Metadata Block
                Text(
                  state.payload!.indicatorName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                ),
                const SizedBox(height: 16),

                // 2. High-Resolution Visual Trend Chart Mock Container
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('VISUAL TREND CHART', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                        const SizedBox(height: 24),
                        Container(
                          height: 220,
                          color: Colors.grey.shade50,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.show_chart_rounded, size: 64, color: const Color(0xFF1D5288).withOpacity(0.7)),
                                const SizedBox(height: 12),
                                Text(
                                  'Line Graph Render Engine Area',
                                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  state.showTargetLine ? '(Target Overlay Enabled)' : '(Target Overlay Hidden)',
                                  style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Tabular Matrix Aggregation Table
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.grey.shade100,
                        child: const Text('AGGREGATED DATA TABLE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Period Framework', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Target', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Actual Performance', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: state.payload!.rows.map((row) {
                            final dynamicDropAlert = row.actualValue < row.targetValue;
                            return DataRow(
                              cells: [
                                DataCell(Text(row.period)),
                                DataCell(Text('${row.targetValue.toStringAsFixed(1)}%')),
                                DataCell(
                                  Text(
                                    '${row.actualValue.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      color: dynamicDropAlert ? Colors.red.shade700 : Colors.green.shade700,
                                      fontWeight: dynamicDropAlert ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}