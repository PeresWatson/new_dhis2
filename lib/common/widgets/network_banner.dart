import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkStatusBanner extends StatefulWidget {
  const NetworkStatusBanner({super.key});

  @override
  State<NetworkStatusBanner> createState() => _NetworkStatusBannerState();
}

class _NetworkStatusBannerState extends State<NetworkStatusBanner> {

  
  bool isOnline = true;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  Timer? _internetCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkInternet();

    // Listen to network changes
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        if (mounted) setState(() => isOnline = false);
      } else {
        _checkInternet(); // Verify real internet
      }
    });

    // Periodic real internet check (important for your case)
    _internetCheckTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkInternet();
    });
  }

  Future<void> _checkInternet() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        if (mounted) setState(() => isOnline = false);
        return;
      }

      // Real internet check
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      final hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (mounted) {
        setState(() => isOnline = hasInternet);
      }
    } catch (_) {
      if (mounted) {
        setState(() => isOnline = false);
      }
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _internetCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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