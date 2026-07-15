import 'dart:convert';
import 'package:dhis_2/common/widgets/network_banner.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/common/utils/charts/barChartWidget.dart';
import 'package:dhis_2/common/utils/charts/kpiWidget.dart';
import 'package:dhis_2/common/utils/charts/lineChartWidget.dart';
import 'package:dhis_2/common/utils/charts/mapVisualizationWidget.dart';
import 'package:dhis_2/common/utils/charts/pieChartWidget.dart';
import 'package:dhis_2/common/utils/charts/pivotTableWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final LoginController logincontroller = Get.find<LoginController>();
  final homecontroller = Get.find<HomeController>();

  final TextEditingController searchController = TextEditingController();

  final GlobalKey dropdownKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  var showDropdown = false.obs;
  var filteredDashboards = [].obs;

  @override
  Widget build(BuildContext context) {
    Get.find<HomeController>().isfullScreenBarChart.value = false;
    Get.find<HomeController>().isfullScreenLineChart.value = false;
    Get.find<HomeController>().isfullScreenPieChart.value = false;
    Get.find<HomeController>().isfullScreenTable.value = false;
    Get.find<HomeController>().isfullScreenMap.value = false;
    Get.find<HomeController>().fetchSimulatedData();
    return Obx(
      () => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) return;
          final home = Get.find<HomeController>();
          home.isfullScreenBarChart.value = false;
          home.isfullScreenLineChart.value = false;
          home.isfullScreenPieChart.value = false;
          home.isfullScreenTable.value = false;
          home.isfullScreenMap.value = false;
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          body: SafeArea(
            child: Column(
              children: [
                // ================= HEADER =================
                Container(
                  color: Colors.blue[800],
                  width: double.infinity,
                  height: 40,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Image.asset('assets/logo/logo_white.png', width: 25, height: 25),
                      const SizedBox(width: 10),

                      Text(
                        "DHIS2 - ${homecontroller.simulatedDashboards["organization"]['name'] ?? 'User'}",
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w600),
                      ),

                      const Spacer(),

                      Visibility(
                        visible: true,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: const Color.fromARGB(255, 82, 70, 117),
                          child: Text(
                            homecontroller.simulatedDashboards != null
                                ? "${homecontroller.simulatedDashboards["organization"]['country'][0].toUpperCase()}"
                                : "U",
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),

                // ================= NETWORK ==========================
                NetworkStatusBanner(),

                // ================= DROPDOWN TRIGGER =================
                GestureDetector(
                  key: dropdownKey,
                  onTap: () {
                    homecontroller.fetchSimulatedData();
                    toggleDropdown(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(showDropdown.value ? Icons.menu_open : Icons.menu, color: Colors.blue[800], size: 22),
                        ),

                        const SizedBox(width: 20),

                        Text(
                          "${homecontroller.selectedDashboard.isEmpty ? 'Select Dashboard' : homecontroller.selectedDashboard['name']} ",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: (homecontroller.selectedDashboardIndex.value == (-1))
                        ? Center(
                            child: NoDashboardSelected(
                              onSelectDashboard: () {
                                toggleDropdown(context);
                              },
                            ),
                          )
                        : SingleChildScrollView(
                            child: Builder(
                              builder: (_) {
                                final items = List<Map<String, dynamic>>.from(homecontroller.selectedDashboard['visualizations'] ?? []);
                                return Column(
                                  children: items.map((item) {
                                    final type = item['defaultRenderType']?.toString().toLowerCase();

                                    if (type == 'line') {
                                      return LineChartWidget(item: item);
                                    } else if (type == 'bar') {
                                      return BarChartWidget(item: item);
                                    } else if (type == 'pie') {
                                      return PieChartWidget(item: item);
                                    } else if (type == 'kpi') {
                                      return KPIWidget(item: item);
                                    } else if (type == 'pivot') {
                                      return PivotTableWidget(item: item);
                                    } else if (type == 'map') {
                                      return MapVisualizationWidget(item: item);
                                    }
                                    return const SizedBox.shrink();
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TOGGLE DROPDOWN =================
  void toggleDropdown(BuildContext context) {
    if (showDropdown.value) {
      hideDropdown();
    } else {
      showDashboardDropdown(context);
    }
  }

  // ================= SHOW DROPDOWN =================
  void showDashboardDropdown(BuildContext context) {
    final renderBox = dropdownKey.currentContext!.findRenderObject() as RenderBox;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    filteredDashboards.value = filteredDashboards.value = (homecontroller.simulatedDashboards['dashboards'] as List);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Container(
          child: Stack(
            children: [
              // OUTSIDE TAP CLOSE
              GestureDetector(
                onTap: hideDropdown,
                child: Container(color: Colors.transparent),
              ),

              // DROPDOWN BOX (BELOW ICON)
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 5,
                width: size.width,
                child: Material(
                  elevation: 12,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ================= SEARCH =================
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search for a dashboards",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            filteredDashboards.value = (homecontroller.simulatedDashboards['dashboards'] as List)
                                .where((d) => (d['name'] ?? '').toString().toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          },
                        ),

                        const SizedBox(height: 10),

                        // ================= LIST =================
                        Obx(() {
                          return SizedBox(
                            height: 300,
                            child: (!homecontroller.isfetchingDashboards.value)
                                ? ListView.builder(
                                    itemCount: filteredDashboards.length,
                                    itemBuilder: (context, index) {
                                      final dashboard = filteredDashboards[index];

                                      return ListTile(
                                        title: Text(dashboard['name'] ?? ''),
                                        onTap: () {
                                          hideDropdown();
                                          homecontroller.selectedDashboard = homecontroller.simulatedDashboards['dashboards'][index];
                                          homecontroller.selectedDashboardIndex.value = index;
                                        },
                                      );
                                    },
                                  )
                                : Center(child: CircularProgressIndicator()),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    showDropdown.value = true;
  }

  // ================= HIDE DROPDOWN =================
  void hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    showDropdown.value = false;
    searchController.clear();
  }
}

class DashboardVisualizationItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final dynamic homecontroller;

  const DashboardVisualizationItem({super.key, required this.item, required this.homecontroller});

  @override
  State<DashboardVisualizationItem> createState() => _DashboardVisualizationItemState();
}

class _DashboardVisualizationItemState extends State<DashboardVisualizationItem> {
  // 1. Declare a variable to hold the future
  late Future<Map<String, dynamic>?> _visualizationFuture;

  @override
  void initState() {
    super.initState();

    // 2. Extract logic and initialize the future ONCE here
    final typeKey = widget.item['type']?.toString().toLowerCase() ?? '';
    final innerItem = widget.item[typeKey];
    final innerId = innerItem?['id'] ?? '';
    final visualizationUrlID = '${typeKey}s/$innerId';

    _visualizationFuture = widget.homecontroller.fetchVisualizationDetails(visualizationUrlID);
  }

  @override
  Widget build(BuildContext context) {
    // If innerId was empty, handle it before rendering the main card
    final typeKey = widget.item['type']?.toString().toLowerCase() ?? '';
    final innerItem = widget.item[typeKey];
    final innerId = innerItem?['id'] ?? '';

    if (innerId.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No visualization data available', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: FutureBuilder<Map<String, dynamic>?>(
        // 3. Pass the cached future here
        future: _visualizationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          final data = snapshot.data;
          final title = data?['name'] ?? 'No Name';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Container(
                height: 200,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: SingleChildScrollView(
                  child: Text(const JsonEncoder.withIndent('  ').convert(data), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NoDashboardSelected extends StatelessWidget {
  final VoidCallback? onSelectDashboard;

  const NoDashboardSelected({super.key, this.onSelectDashboard});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.dashboard_customize_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),

            const Text("No Dashboard Selected", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Text(
              "Select a dashboard to view visualizations, KPIs, charts, and reports.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),

            if (onSelectDashboard != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(onPressed: onSelectDashboard, icon: const Icon(Icons.dashboard), label: const Text("Select Dashboard")),
            ],
          ],
        ),
      ),
    );
  }
}
