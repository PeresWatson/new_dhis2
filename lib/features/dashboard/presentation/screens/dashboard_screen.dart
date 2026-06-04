// lib/features/dashboard/presentation/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import '../controllers/dashboard_provider.dart'; // 🌟 This imports the correct provider file
import '../widgets/chart_card_widget.dart';
import '../../data/models/analytics_response_model.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardProvider provider;

  const DashboardScreen({Key? key, required this.provider}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.provider.initializeDashboardData();
    });
    widget.provider.addListener(_updateUi);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_updateUi);
    super.dispose();
  }

  void _updateUi() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.provider;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D5288),
        title: const Text(
          'DHIS2 Mobile Dashboard', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (state.status == DashboardStatus.loading && state.dashboards.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1D5288)));
          }

          if (state.status == DashboardStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.errorMessage, style: const TextStyle(fontWeight: FontWeight.w500)),
                  TextButton(
                    onPressed: () => state.initializeDashboardData(),
                    child: const Text('Retry Connection'),
                  )
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
                child: Text(
                  'FAVORITE DASHBOARDS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(
                height: 44,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: state.dashboards.length,
                  itemBuilder: (context, index) {
                    final dashboard = state.dashboards[index];
                    
                    // 🔑 This will compile perfectly now because it reads from the correct file!
                    final isSelected = state.selectedDashboardIndex == index;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(dashboard.displayName),
                        selected: isSelected,
                        selectedColor: const Color(0xFF1D5288),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        // 🔑 This accepts 'int index' perfectly now!
                        onSelected: (_) => state.switchDashboard(index),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 20),
              Expanded(
                child: state.status == DashboardStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: state.currentLayoutItems.length,
                        itemBuilder: (context, index) {
                          final item = state.currentLayoutItems[index];
                          final mockPoints = [
                            AnalyticsDataPoint(periodId: '202401', periodName: 'Jan 2024', value: 45.5),
                            AnalyticsDataPoint(periodId: '202402', periodName: 'Feb 2024', value: 52.3),
                            AnalyticsDataPoint(periodId: '202403', periodName: 'Mar 2024', value: 48.7),
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ChartCardWidget(title: item.displayName, points: mockPoints),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}