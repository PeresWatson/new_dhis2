import 'package:dhis_2/screens/onboarding_screen/onboarding_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject and instantiate the GetX controller lifecycle engine
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // Reactively render loading state if configuration engine is running
          if (controller.isInitializing.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(controller.textLoadingEngine),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) => controller.currentPage.value = index,
                  itemCount: controller.onboardingData.length,
                  itemBuilder: (context, index) => _buildPageContent(
                    title: controller.onboardingData[index]["title"]!,
                    description: controller.onboardingData[index]["description"]!,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Page Indicators mapped dynamically via Obx wrapper
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.onboardingData.length,
                          (index) => _buildDotIndicator(index, controller),
                        ),
                      ),
                      // Action Execution Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: controller.isLoggingIn.value
                              ? null
                              : () => controller.handleNextAction(),
                          child: controller.isLoggingIn.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  controller.currentPage.value == controller.onboardingData.length - 1
                                      ? controller.textGetStarted
                                      : controller.textNext,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPageContent({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 100, color: Colors.blue[800]),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index, OnboardingController controller) {
    return Obx(() {
      bool isSelected = controller.currentPage.value == index;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        height: 8,
        width: isSelected ? 24 : 8,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[800] : Colors.grey[400],
          borderRadius: BorderRadius.circular(4),
        ),
      );
    });
  }

  void _showLoginBottomSheet(BuildContext context, OnboardingController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.textGatewayAccess, 
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.urlController,
                  decoration: InputDecoration(labelText: controller.textLabelUrl, border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(labelText: controller.textLabelUsername, border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: controller.textLabelPassword, border: const OutlineInputBorder()),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
                    onPressed: () {
                      Get.back(); // Native pop via GetX architecture
                      controller.performMockLoginFlow();
                    },
                    child: Text(
                      controller.textButtonAuthenticate, 
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}