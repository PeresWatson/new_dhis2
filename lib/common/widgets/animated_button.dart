import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GetXAnimatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? buttonColor;
  final Color? textColor;

  const GetXAnimatedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.buttonColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Local reactive scale target value managed via GetX Rx types
    final RxDouble scaleTarget = 1.0.obs;

    return GestureDetector(
      onTapDown: (_) => scaleTarget.value = 0.95, // Shrink on press
      onTapUp: (_) {
        scaleTarget.value = 1.0; // Restore size
        onTap(); // Trigger your actual route or login logic
      },
      onTapCancel: () => scaleTarget.value = 1.0, // Restore if dragged away
      child: Obx(() => Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: buttonColor ?? Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (buttonColor ?? Theme.of(context).primaryColor)
                      .withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )
              // The flutter_animate package dynamically listens to target changes!
              .animate(target: scaleTarget.value)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(0.95, 0.95),
                curve: Curves.easeOutCubic,
                duration: 100.ms,
              )),
    );
  }
}