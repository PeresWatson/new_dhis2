// lib/features/dashboard/presentation/screens/indicator_detail_screen.dart

import 'package:flutter/material.dart';
import '../controllers/indicator_detail_provider.dart';
import '../widgets/chart_card_widget.dart';

class IndicatorDetailScreen extends StatefulWidget {
  final String visualId;
  final IndicatorDetailProvider provider;

  const IndicatorDetailScreen({
    super.key, 
    required this.visualId, 
    required this.provider,
  });

  @override
  State<IndicatorDetailScreen> createState() => _IndicatorDetailScreenState();
}

class _IndicatorDetailScreenState extends State<IndicatorDetailScreen> {
  @override
  void initState() {
    super.initState();
    widget.provider.addListener(_rebuildUi);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_rebuildUi);
    super.dispose();
  }

  void _rebuildUi() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.provider;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D5288),
        title: const Text('Indicator Analytics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1D5288)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📄 SECTION 1: Metadata Definition Box
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF1D5288).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: const Text('CORE DHIS2 METRIC', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1D5288))),
                          ),
                          const SizedBox(height: 8),
                          Text(state.indicatorName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
                          const SizedBox(height: 6),
                          Text(state.indicatorDefinition, style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.4)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 📈 SECTION 2: Full-Size Timeline Trend Graph
                  ChartCardWidget(
                    title: '12-Month Longitudinal Progression Profile',
                    chartType: 'LINE_CHART',
                    points: state.historicalPoints,
                  ),
                  const SizedBox(height: 16),

                  // 📊 SECTION 3: Tabular Audit Matrix
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0, bottom: 8.0),
                    child: Text('REGIONAL PERFORMANCE BREAKDOWN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(const Color(0xFF1D5288).withOpacity(0.05)),
                          horizontalMargin: 16,
                          columnSpacing: 24,
                          columns: const [
                            DataColumn(label: Text('Reporting Target Unit', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)))),
                            DataColumn(label: Text('Achieved Ratio', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))), numeric: true),
                          ],
                          rows: state.regionalBreakdown.entries.map((entry) {
                            return DataRow(cells: [
                              DataCell(Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: entry.value >= 75 ? Colors.green.withOpacity(0.1) : Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${entry.value}%',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: entry.value >= 75 ? Colors.green : Colors.orange),
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}