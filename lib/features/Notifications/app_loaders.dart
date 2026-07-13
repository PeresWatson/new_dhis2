import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoaders {
  // Prevent instantiation
  AppLoaders._();

  /// Displays a non-dismissible full-screen loading overlay.
  /// Use this to block user interaction during network requests or authentication checks.
  static void showLoadingOverlay({required String message}) {
    // Avoid opening multiple overlays if one is already showing
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    Get.dialog(
      PopScope(
        canPop: false, // Prevents closing the loader via the device's hardware back button
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 3.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(width: 24),
                Flexible(
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false, // Prevents closing the loader by tapping outside
      barrierColor: Colors.black.withOpacity(0.50), // Dims the background screen
      transitionDuration: const Duration(milliseconds: 200),
    );
  }

  /// Closes any currently visible full-screen loading overlay or active dialog.
  static void hideLoadingOverlay() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Displays a lightweight circular spinner for inline/partial UI sections.
  static Widget inlineLoadingSpinner({double size = 30.0, Color color = Colors.blue}) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}