import 'dart:convert';
import 'package:dhis_2/common/widgets/network_banner.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/utils/network_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final LoginController logincontroller = Get.find<LoginController>();
  final HomeController homecontroller = Get.find<HomeController>();

  final TextEditingController searchController = TextEditingController();

  final GlobalKey dropdownKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  var showDropdown = false.obs;
  var filteredDashboards = [].obs;

  @override
  Widget build(BuildContext context) {
    homecontroller.fetchDashboards();

    return Obx(
      () => Scaffold(
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
                    Image.asset('logo/logo_white.png', width: 25, height: 25),
                    const SizedBox(width: 10),

                    Text(
                      "DHIS2 - ${logincontroller.userData["displayName"] ?? 'User'}",
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w600),
                    ),

                    const Spacer(),

                    Visibility(
                      visible: false,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color.fromARGB(255, 82, 70, 117),
                        child: Text(
                          logincontroller.userData['firstName'] != null
                              ? "${logincontroller.userData['firstName'][0].toUpperCase()}${logincontroller.userData['surname'][0].toUpperCase()}"
                              : "U",
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                  ],
                ),
              ),

              // ================= NETWORK =================
              NetworkStatusBanner(isOnline: Get.find<NetworkController>().isOnline.value),

              // ================= DROPDOWN TRIGGER =================
              GestureDetector(
                key: dropdownKey,
                onTap: () {
                  homecontroller.fetchDashboards();
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
                        "${homecontroller.selectedDashboardName.value.isEmpty ? 'Select Dashboard' : homecontroller.selectedDashboardName.value} ",
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
                  child: homecontroller.isfetchingDashboardItems.value
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Builder(
                            builder: (_) {
                              final items = List<Map<String, dynamic>>.from(homecontroller.dashboardItems['dashboardItems'] ?? []);

                              // Sort exactly like DHIS2 dashboard layout
                              items.sort((a, b) {
                                final ay = a['y'] ?? 0;
                                final by = b['y'] ?? 0;
                                if (ay != by) return ay.compareTo(by);

                                final ax = a['x'] ?? 0;
                                final bx = b['x'] ?? 0;
                                return ax.compareTo(bx);
                              });
                              return Column(
                                children: [
                                  for (var item in items)
                                    if (item['type'] == 'TEXT')
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: Markdown(
                                          data: item['displayText'] ?? '',
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                        ),
                                      )
                                    else if (item['type'] == 'MAP' || item['type'] == 'VISUALIZATION')
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(item['type'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                const SizedBox(height: 12),
                                                Container(
                                                  height: 200,
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                                                  child: Image(
                                                    image: NetworkImage(
                                                      'https://play.im.dhis2.org/dev/api/${(item['type'] as String).toLowerCase()}s/${item['${(item['type'] as String).toLowerCase()}']['id']}/data',
                                                      headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('admin:district'))}'},
                                                    ),
                                                    // Makes sure the entire chart/map visualization fits legibly within the frame without stretching
                                                    fit: BoxFit.contain,

                                                    // Individual loader setup
                                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                                      if (loadingProgress == null) return child; // Image finished loading, display it

                                                      return Center(
                                                        child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[800]!),
                                                          // Optional: Display download percentage if server provides headers
                                                          value: loadingProgress.expectedTotalBytes != null
                                                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                    errorBuilder: (context, error, stackTrace) {
                                                      final typeKey = (item['type'] as String).toLowerCase();
                                                      print('Failed URL: https://play.im.dhis2.org/dev/api/${typeKey}s/${item[typeKey]['id']}/data');
                                                      return const Center(
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.broken_image, color: Colors.grey, size: 32),
                                                            SizedBox(height: 4),
                                                            Text('Visualization missing', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
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

    filteredDashboards.value = homecontroller.dashboards['dashboards'] ?? [];

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
                            final all = homecontroller.dashboards['dashboards'] ?? [];

                            filteredDashboards.value = (all as List)
                                .where((d) => (d['displayName'] ?? '').toString().toLowerCase().contains(value.toLowerCase()))
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
                                        title: Text(dashboard['displayName'] ?? ''),
                                        onTap: () {
                                          hideDropdown();
                                          homecontroller.selectedDashboardId.value = dashboard['id'] ?? '';
                                          homecontroller.selectedDashboardName.value = dashboard['displayName'] ?? '';
                                          homecontroller.fetchDashboardItems(dashboard['id'] ?? '');
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
