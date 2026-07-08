import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    return Obx(
      () => Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),

        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                /// --- LOGO BRANDING SECTION ---
                Center(child: Image.asset('assets/logo/dhis_logo.png', width: 60, height: 60, fit: BoxFit.contain)),
                const SizedBox(height: 16),

                // Welcome Title text
                Text(
                  "DHIS2 LOGIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.blue[800]),
                ),
                const SizedBox(height: 36),

                /// --- INPUT CONTAINER CARD ---
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.blue[800] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.04), blurRadius: 16, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    children: [
                      // Server URL Field Input
                      Visibility(
                        visible: true, // Hiding URL input field for now as we are pre-populating it with a default value in the controller
                        child: TextField(
                          controller: controller.urlController,
                          keyboardType: TextInputType.url,
                          decoration: InputDecoration(
                            labelText: controller.labelUrl,
                            prefixIcon: Icon(Icons.dns_rounded, color: Colors.blue[800]),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF1F5F9),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                          prefixIcon: Icon(Icons.person_outline_rounded, color: Colors.blue[800]),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password Text Field Input
                      Obx(
                        () => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          decoration: InputDecoration(
                            labelText: controller.labelPassword,
                            prefixIcon: Icon(Icons.lock_open_rounded, color: Colors.blue[800]),
                            suffixIcon: IconButton(
                              icon: Icon(controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                controller.obscurePassword.toggle();
                              },
                            ),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF1F5F9),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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
                    String url = controller.urlController.text.trim();

                    if (username.isEmpty || password.isEmpty || url.isEmpty) {
                      AppSnackbars.showError(title: controller.titleError, message: controller.errEmptyFields);
                      return;
                    } else {
                      // controller.D2login(url: url, username: username, password: password);
                      controller.login(username,password);
                      
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 3,
                    shadowColor: Colors.blue.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 3, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : Text(controller.btnLogin, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
