import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String selectedIndicator = 'ANC Coverage Trend';
  String selectedVisualization = 'line';

  final List<String> indicators = [
    'ANC Coverage Trend',
    'Gender Distribution',
    'District Performance',
    'ANC KPI Snapshot',
    'Facility Reporting Rate',
  ];

  final List<String> visualizationTypes = ['line', 'bar', 'pie', 'table', 'kpi', 'map'];

  final GlobalKey indicatorKey = GlobalKey();
  final GlobalKey visualizationKey = GlobalKey();

  OverlayEntry? _overlayEntry;

  bool showDropdown = false;

  final TextEditingController searchController = TextEditingController();

  List<String> filteredItems = [];

  @override
  void dispose() {
    searchController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleDropdown({
    required BuildContext context,
    required GlobalKey key,
    required List<String> items,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    if (showDropdown) {
      _hideDropdown();
    } else {
      _showDropdown(context: context, key: key, items: items, selectedValue: selectedValue, onSelected: onSelected);
    }
  }

  void _showDropdown({
    required BuildContext context,
    required GlobalKey key,
    required List<String> items,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    filteredItems = List.from(items);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: _hideDropdown,
              child: Container(color: Colors.transparent),
            ),

            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 6,
              width: size.width,
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(16),
                child: StatefulBuilder(
                  builder: (context, setOverlayState) {
                    return Container(
                      constraints: const BoxConstraints(maxHeight: 350),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              setOverlayState(() {
                                filteredItems = items.where((e) => e.toLowerCase().contains(value.toLowerCase())).toList();
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];

                                final selected = item == selectedValue;

                                return ListTile(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  leading: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: selected ? const Color(0xFF1D5288) : Colors.grey.shade200,
                                    child: Icon(Icons.analytics, size: 18, color: selected ? Colors.white : Colors.grey),
                                  ),
                                  title: Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
                                  trailing: selected ? const Icon(Icons.check_circle, color: Color(0xFF1D5288)) : null,
                                  onTap: () {
                                    onSelected(item);
                                    _hideDropdown();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      showDropdown = true;
    });
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    searchController.clear();

    setState(() {
      showDropdown = false;
    });
  }

  Widget _filterDropdown({
    required String title,
    required String value,
    required GlobalKey key,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1D5288)),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Icon(showDropdown ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFF1D5288)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(title: const Text('Analytics'), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    _filterDropdown(
                      title: "Indicator",
                      value: selectedIndicator,
                      icon: Icons.analytics_outlined,
                      key: indicatorKey,
                      onTap: () {
                        _toggleDropdown(
                          context: context,
                          key: indicatorKey,
                          items: indicators,
                          selectedValue: selectedIndicator,
                          onSelected: (value) {
                            setState(() {
                              selectedIndicator = value;
                            });
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    _filterDropdown(
                      title: "Visualization",
                      value: selectedVisualization.toUpperCase(),
                      icon: Icons.bar_chart,
                      key: visualizationKey,
                      onTap: () {
                        _toggleDropdown(
                          context: context,
                          key: visualizationKey,
                          items: visualizationTypes,
                          selectedValue: selectedVisualization,
                          onSelected: (value) {
                            setState(() {
                              selectedVisualization = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(child: _buildVisualization()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualization() {
    switch (selectedVisualization) {
      case 'line':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.show_chart, size: 100, color: Color(0xFF1D5288)),
            SizedBox(height: 10),
            Text('Line Chart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        );

      case 'bar':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.bar_chart, size: 100, color: Color(0xFF1D5288)),
            SizedBox(height: 10),
            Text('Bar Chart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        );

      case 'pie':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.pie_chart, size: 100, color: Color(0xFF1D5288)),
            SizedBox(height: 10),
            Text('Pie Chart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        );

      case 'table':
        return DataTable(
          columns: const [
            DataColumn(label: Text('District')),
            DataColumn(label: Text('Value')),
          ],
          rows: const [
            DataRow(cells: [DataCell(Text('Bo')), DataCell(Text('85'))]),
            DataRow(cells: [DataCell(Text('Kenema')), DataCell(Text('79'))]),
            DataRow(cells: [DataCell(Text('Kono')), DataCell(Text('64'))]),
          ],
        );

      case 'kpi':
        return Container(
          width: 260,
          height: 150,
          decoration: BoxDecoration(color: const Color(0xFF1D5288), borderRadius: BorderRadius.circular(16)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('ANC Coverage', style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 10),
              Text(
                '84%',
                style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );

      case 'map':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.map, size: 100, color: Color(0xFF1D5288)),
            SizedBox(height: 10),
            Text('Map Visualization', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        );

      default:
        return const Text('No visualization selected');
    }
  }
}
