import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkStatusBanner extends StatefulWidget {
  const NetworkStatusBanner({super.key});

  @override
  State<NetworkStatusBanner> createState() => _NetworkStatusBannerState();
}

class _NetworkStatusBannerState extends State<NetworkStatusBanner> {
  bool isOnline = true;

  StreamSubscription<InternetStatus>? _subscription;

  @override
  void initState() {
    super.initState();
    _checkInternet();

    _subscription = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) {
      if (!mounted) return;

      setState(() {
        isOnline = status == InternetStatus.connected;
      });
    });
  }

  Future<void> _checkInternet() async {
    final hasInternet =
        await InternetConnection().hasInternetAccess;

    if (!mounted) return;

    setState(() {
      isOnline = hasInternet;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: double.infinity,
      height: 25,
      color: const Color.fromARGB(255, 2, 71, 127),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isOnline ? "Online" : "Offline",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}