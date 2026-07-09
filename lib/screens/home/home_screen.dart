import 'package:dhis_2/common/widgets/network_banner.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/navigation/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController homecontroller = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => homecontroller.fetchDashboards());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: const Color(0xFFF3F6FB),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: Colors.blue[800],
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Image.asset('assets/logo/logo_white.png', width: 24, height: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'DHIS2 - ${Get.find<NavigationController>().currentUser.value?.name ?? 'User'}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: const Color(0xFF5B4B8A),
                      child: Text(
                        Get.find<NavigationController>().currentUser.value?.name != null
                            ? Get.find<NavigationController>().currentUser.value!.name![0].toUpperCase()
                            : 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              NetworkStatusBanner(),
              const SizedBox(height: 8),
              if (homecontroller.isfetchingDashboards.value)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: Column(
                    children: [
                      _buildDashboardSelector(),
                      const SizedBox(height: 10),
                      _buildDashboardSummary(),
                      const SizedBox(height: 10),
                      Expanded(child: _buildVisualizationList()),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardSelector() {
    final dashboards = List<Map<String, dynamic>>.from((homecontroller.dashboards['dashboards'] ?? []).cast<Map<String, dynamic>>());

    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: dashboards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final dashboard = dashboards[index];
          final isSelected = homecontroller.selectedDashboardId.value == dashboard['id'];
          return InkWell(
            onTap: () => homecontroller.fetchDashboardItems(dashboard['id'].toString()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[800] : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: isSelected ? Colors.blue[800]! : Colors.grey.shade300),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Center(
                child: Text(
                  dashboard['name']?.toString() ?? '',
                  style: TextStyle(color: isSelected ? Colors.white : Colors.blue[900], fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardSummary() {
    final dashboard = homecontroller.dashboardItems;
    final title = dashboard['name']?.toString() ?? homecontroller.selectedDashboardName.value;
    final description = dashboard['description']?.toString() ?? 'Select a dashboard from the list to explore its visualizations.';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('${dashboard['visualizationCount'] ?? 0} visualizations'), avatar: const Icon(Icons.bar_chart, size: 16)),
              Chip(label: Text(dashboard['category']?.toString() ?? 'Health'), avatar: const Icon(Icons.category, size: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVisualizationList() {
    final visualizations = List<Map<String, dynamic>>.from(homecontroller.visualizations.toList());

    if (visualizations.isEmpty) {
      return const Center(child: Text('No visualizations available for this dashboard yet.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: visualizations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => DashboardVisualizationCard(visualization: visualizations[index]),
    );
  }
}

class DashboardVisualizationCard extends StatefulWidget {
  final Map<String, dynamic> visualization;

  const DashboardVisualizationCard({super.key, required this.visualization});

  @override
  State<DashboardVisualizationCard> createState() => _DashboardVisualizationCardState();
}

class _DashboardVisualizationCardState extends State<DashboardVisualizationCard> {
  late String selectedRenderType;

  @override
  void initState() {
    super.initState();
    selectedRenderType = widget.visualization['defaultRenderType']?.toString() ?? 'line';
  }

  @override
  Widget build(BuildContext context) {
    final renderTypes = List<String>.from((widget.visualization['availableRenderTypes'] ?? []).cast<String>());
    final data = widget.visualization['data'] as Map<String, dynamic>? ?? <String, dynamic>{};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.visualization['title']?.toString() ?? 'Visualization',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(widget.visualization['description']?.toString() ?? '', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(999)),
                child: Text(
                  widget.visualization['indicatorName']?.toString() ?? '',
                  style: TextStyle(color: Colors.blue[800], fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: renderTypes.map((type) {
              final isActive = selectedRenderType == type;
              return ChoiceChip(label: Text(type.toUpperCase()), selected: isActive, onSelected: (_) => setState(() => selectedRenderType = type));
            }).toList(),
          ),
          const SizedBox(height: 10),
          _buildPreview(data, selectedRenderType),
          const SizedBox(height: 8),
          Row(
            children: [
              if (widget.visualization['allowDrillDown'] == true) const Icon(Icons.open_in_full, size: 14, color: Colors.green),
              if (widget.visualization['allowDrillDown'] == true) const SizedBox(width: 4),
              Text(
                widget.visualization['allowDrillDown'] == true ? 'Drill-down enabled' : 'No drill-down',
                style: TextStyle(color: Colors.grey[700], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(Map<String, dynamic> data, String renderType) {
    switch (renderType) {
      case 'line':
        return _buildLinePreview(data);
      case 'bar':
        return _buildBarPreview(data);
      case 'pie':
        return _buildPiePreview(data);
      case 'kpi':
        return _buildKpiPreview(data);
      case 'pivot':
        return _buildPivotPreview(data);
      case 'map':
        return _buildMapPreview(data);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLinePreview(Map<String, dynamic> data) {
    final series = List<Map<String, dynamic>>.from((data['series'] ?? []).cast<Map<String, dynamic>>());
    if (series.isEmpty) {
      return const Text('No line data available');
    }

    final points = List<Map<String, dynamic>>.from((series.first['data'] ?? []).cast<Map<String, dynamic>>());
    final values = points.map((point) => (point['value'] as num?)?.toDouble() ?? 0).toList();
    final maxValue = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: values.asMap().entries.map((entry) {
          final value = entry.value;
          final height = maxValue == 0 ? 0.0 : (value / maxValue) * 90;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height,
                    decoration: BoxDecoration(color: Colors.blue[600], borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 4),
                  Text(points[entry.key]['label']?.toString() ?? '', style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBarPreview(Map<String, dynamic> data) {
    final categories = List<String>.from((data['categories'] ?? []).cast<String>());
    final series = List<Map<String, dynamic>>.from((data['series'] ?? []).cast<Map<String, dynamic>>());
    if (categories.isEmpty || series.isEmpty) {
      return const Text('No bar data available');
    }

    final values = List<num>.from(series.first['data'] ?? []);
    final maxValue = values.isEmpty ? 1 : values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(categories.length, (index) {
          final value = values[index].toDouble();
          final height = maxValue == 0 ? 0.0 : (value / maxValue) * 90;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height,
                    decoration: BoxDecoration(color: Colors.teal[600], borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(height: 4),
                  Text(categories[index], style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPiePreview(Map<String, dynamic> data) {
    final categories = List<Map<String, dynamic>>.from((data['categories'] ?? []).cast<Map<String, dynamic>>());
    if (categories.isEmpty) {
      return const Text('No pie data available');
    }

    return Column(
      children: categories.map((category) {
        final value = (category['value'] as num?)?.toDouble() ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Expanded(child: Text(category['name']?.toString() ?? 'Category')),
              Text('${value.toStringAsFixed(0)}%'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKpiPreview(Map<String, dynamic> data) {
    final value = (data['value'] as num?)?.toDouble() ?? 0;
    final target = (data['target'] as num?)?.toDouble() ?? 0;
    final trend = data['trend']?.toString() ?? 'up';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${value.toStringAsFixed(1)}${data['unit'] ?? '%'}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Target: ${target.toStringAsFixed(0)}${data['unit'] ?? '%'}', style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            ],
          ),
        ),
        Icon(trend == 'up' ? Icons.trending_up : Icons.trending_down, color: trend == 'up' ? Colors.green : Colors.orange, size: 28),
      ],
    );
  }

  Widget _buildPivotPreview(Map<String, dynamic> data) {
    final rows = List<String>.from((data['rows'] ?? []).cast<String>());
    final columns = List<String>.from((data['columns'] ?? []).cast<String>());
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
      child: Text('${rows.length} rows × ${columns.length} columns', style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildMapPreview(Map<String, dynamic> data) {
    final layers = List<Map<String, dynamic>>.from((data['layers'] ?? []).cast<Map<String, dynamic>>());
    if (layers.isEmpty) {
      return const Text('No map data available');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: layers.take(4).map((layer) {
        return Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Text('${layer['district']}: ${layer['value']}'));
      }).toList(),
    );
  }
}
