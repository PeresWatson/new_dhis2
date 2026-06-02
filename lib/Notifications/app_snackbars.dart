import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbars {
  // Prevent instantiation
  AppSnackbars._();

  /// Displays a success message snackbar
  static void showSuccess({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _showCustomSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.green[700]!.withOpacity(0.95),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
      position: position,
    );
  }

  /// Displays an error alert message snackbar
  static void showError({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _showCustomSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent.withOpacity(0.95),
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 28),
      position: position,
    );
  }

  /// Displays an operational warning alert message snackbar
  static void showWarning({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _showCustomSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.orange[800]!.withOpacity(0.95),
      icon: const Icon(Icons.warning_amber_outlined, color: Colors.white, size: 28),
      position: position,
    );
  }

  /// Master internal wrapper mapping to GetX core infrastructure
  static void _showCustomSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required Icon icon,
    required SnackPosition position,
  }) {
    // Dismiss any active overlay snackbars to prevent layout stacking bugs
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      icon: icon,
      shouldIconPulse: false,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 4),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}