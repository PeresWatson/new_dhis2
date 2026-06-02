import 'package:dhis_2/common/widgets/dashboard_header.dart';
import 'package:dhis_2/common/widgets/network_banner.dart';
import 'package:dhis_2/screens/login/login_screen.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';
import 'package:dhis_2/utils/network_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final LoginController logincontroller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (1 == 1)
          ? SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.blue[800],
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Image.asset(
                          'logo/logo_white.png',
                          width: 25,
                          height: 25,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "DHIS2 - ${logincontroller.userData['nationality'] ?? 'User'}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: const Color.fromARGB(255, 82, 70, 117),
                                  child: Text(
                                    logincontroller.userData['name'] != null
                                        ? "${(logincontroller.userData['firstName'] as String).characters.first.toUpperCase()} ${(logincontroller.userData['surname'] as String).characters.first.toUpperCase()}"
                                        : "U",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  NetworkStatusBanner(
                    isOnline: Get.find<NetworkController>().isOnline.value,
                  ),
                  AntenatalCareBanner(),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.off(() => LoginScreen());
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Column(children: []),
    );
  }
}
