import 'package:dhis_2/common/widgets/network_banner.dart';
import 'package:dhis_2/screens/home/home_screen_controller.dart';
import 'package:dhis_2/screens/login/login_screen.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/utils/network_controller.dart';
import 'package:flutter/material.dart';
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
        body: (!homecontroller.isfetchingDashboards.value)
            ? SafeArea(
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
                          Image.asset(
                            'logo/logo_white.png',
                            width: 25,
                            height: 25,
                          ),
                          const SizedBox(width: 10),

                          Text(
                            "DHIS2 - ${logincontroller.userData["displayName"] ?? 'User'}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Spacer(),

                          Visibility(
                            visible: false,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: const Color.fromARGB(
                                255,
                                82,
                                70,
                                117,
                              ),
                              child: Text(
                                logincontroller.userData['firstName'] != null
                                    ? "${logincontroller.userData['firstName'][0].toUpperCase()}${logincontroller.userData['surname'][0].toUpperCase()}"
                                    : "U",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                        ],
                      ),
                    ),

                    // ================= NETWORK =================
                    NetworkStatusBanner(
                      isOnline: Get.find<NetworkController>().isOnline.value,
                    ),

                    const SizedBox(height: 10),

                    // ================= DROPDOWN TRIGGER =================
                    GestureDetector(
                      key: dropdownKey,
                      onTap: () => toggleDropdown(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                showDropdown.value
                                    ? Icons.menu_open
                                    : Icons.menu,
                                color: Colors.blue[800],
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 20),

                            Text(
                              "${homecontroller.selectedDashboardName.value.isEmpty ? 'Select Dashboard' : homecontroller.selectedDashboardName.value} ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    ElevatedButton(
                      onPressed: () => Get.off(() => LoginScreen()),
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
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
    final renderBox =
        dropdownKey.currentContext!.findRenderObject() as RenderBox;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    filteredDashboards.value =
        homecontroller.dashboardsData['dashboards'] ?? [];

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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ================= SEARCH =================
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search for a dashboards",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            final all =
                                homecontroller.dashboardsData['dashboards'] ??
                                [];

                            filteredDashboards.value = (all as List)
                                .where(
                                  (d) => (d['displayName'] ?? '')
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                                )
                                .toList();
                          },
                        ),

                        const SizedBox(height: 10),

                        // ================= LIST =================
                        Obx(() {
                          return SizedBox(
                            height: 300,
                            child: ListView.builder(
                              itemCount: filteredDashboards.length,
                              itemBuilder: (context, index) {
                                final dashboard = filteredDashboards[index];

                                return ListTile(
                                  title: Text(dashboard['displayName'] ?? ''),
                                  onTap: () {
                                    hideDropdown();
                                    print("Selected: ${dashboard['id']}");
                                    homecontroller.selectedDashboardId.value =
                                        dashboard['id'] ?? '';
                                    homecontroller.selectedDashboardName.value =
                                        dashboard['displayName'] ?? '';
                                  },
                                );
                              },
                            ),
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
