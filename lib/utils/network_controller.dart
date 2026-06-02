import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Reactive state: true if connected to Mobile Data or WiFi
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    // Listen for real-time changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Check network status exactly when the app boots up
  Future<void> _checkInitialConnection() async {
    List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  // Update state logic based on active interfaces
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // connectivity_plus 6.x returns a list. If it contains .none, there is no internet connection.
    if (results.contains(ConnectivityResult.none)) {
      isOnline.value = false;
    } else {
      isOnline.value = true;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel(); // Cancel stream to avoid memory leaks
    super.onClose();
  }
}