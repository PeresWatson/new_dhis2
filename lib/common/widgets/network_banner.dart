import 'package:flutter/material.dart';

class NetworkStatusBanner extends StatelessWidget {
  final bool isOnline;

  const NetworkStatusBanner({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Forces full width and rigid height of 40 pixels
      width: double.infinity,
      height: 25,
      color: const Color.fromARGB(255, 2, 71, 127),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Status Indicator Dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green[600] : Colors.red[600],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          // Status Text Labels
          Text(
            isOnline ? "Online" : "Offline",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}