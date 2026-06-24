import 'package:dhis_2/screens/navigation/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dhis_2/Notifications/app_loaders.dart';
import 'package:dhis_2/Notifications/app_snackbars.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // Injecting your defined controller
  final LoginController controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    // Dynamically tracking dark/light modes for contrast adjustments
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// --- LOGO BRANDING SECTION ---
              Center(
                child: Image.asset(
                  'logo/dhis_logo.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),

              // Welcome Title text
              Text(
                "DHIS2 LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.blue[800],
                ),
              ),
              const SizedBox(height: 36),

              /// --- INPUT CONTAINER CARD ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blue[800] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Server URL Field Input
                    Visibility(
                      visible:
                          false, // Hiding URL input field for now as we are pre-populating it with a default value in the controller
                      child: TextField(
                        controller: controller.urlController,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          labelText: controller.labelUrl,
                          prefixIcon: Icon(
                            Icons.dns_rounded,
                            color: Colors.blue[800],
                          ),
                          filled: true,
                          fillColor: isDark
                              ? const Color(0xFF2D2D2D)
                              : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Username Text Field Input
                    TextField(
                      controller: controller.usernameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: controller.labelUsername,
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.blue[800],
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2D2D2D)
                            : const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Text Field Input
                    TextField(
                      onSubmitted: (value) async {
                         String username = controller.usernameController.text.trim();
                  String password = controller.passwordController.text.trim();

                  print(
                    "Attempting login with URL: ${controller.urlController.text}, Username: $username , password: $password",
                  );

                  if (username.isEmpty || password.isEmpty) {
                    AppSnackbars.showError(
                      title: controller.titleError,
                      message: controller.errEmptyFields,
                    );
                    return;
                  }

                  bool success = await controller.login(username, password);

                  if (success) {
                    AppLoaders.hideLoadingOverlay();
                    AppSnackbars.showSuccess(
                      title: controller.titleSuccess,
                      message: controller.msgLoginSuccess,
                    );
                    
                    Get.off(() => NavigationMenu());
                  }
                      },
                      controller: controller.passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: controller.labelPassword,
                        prefixIcon: Icon(
                          Icons.lock_open_rounded,
                          color: Colors.blue[800],
                        ),
                        filled: true,
                        fillColor: isDark
                            ? const Color(0xFF2D2D2D)
                            : const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              /// --- ACTION SUBMIT BUTTON ---
              ElevatedButton(
                onPressed: () async {
                  String username = controller.usernameController.text.trim();
                  String password = controller.passwordController.text.trim();

                  print(
                    "Attempting login with URL: ${controller.urlController.text}, Username: $username , password: $password",
                  );

                  if (username.isEmpty || password.isEmpty) {
                    AppSnackbars.showError(
                      title: controller.titleError,
                      message: controller.errEmptyFields,
                    );
                    return;
                  }

                  bool success = await controller.login(username, password);

                  if (success) {
                    AppLoaders.hideLoadingOverlay();
                    AppSnackbars.showSuccess(
                      title: controller.titleSuccess,
                      message: controller.msgLoginSuccess,
                    );
                    Get.off(() => NavigationMenu());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 3,
                  shadowColor: Colors.blue.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  controller.btnLogin,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
