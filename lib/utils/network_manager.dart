import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();

  var isThereInternet = true.obs;

  late StreamSubscription<List<ConnectivityResult>> _sub;

  Timer? _noInternetTimer;

  bool _wasDisconnected = false;

  @override
  void onInit() {
    super.onInit();

    _sub = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  Future<void> _onChanged(List<ConnectivityResult> result) async {
    final status = result.isNotEmpty ? result.last : ConnectivityResult.none;

    if (status == ConnectivityResult.none) {
      _wasDisconnected = true;

      isThereInternet.value = false;

      _startTimer();
    } else {
      _stopTimer();

      if (_wasDisconnected) {
        Get.snackbar(
          'Mtandao umerudi',
          'Umerudi mtandaoni kikamilifu sasa',

          colorText: Colors.white,

          backgroundColor: const Color(0xFF00A63E),

          snackPosition: SnackPosition.TOP,

          margin: const EdgeInsets.all(10),

          icon: const Icon(Icons.wifi, color: Colors.white),
        );

        isThereInternet.value = true;

        _wasDisconnected = false;
      }
    }
  }

  void _startTimer() {
    if (_noInternetTimer != null && _noInternetTimer!.isActive) return;

    _noInternetTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      Get.snackbar(
        'Hakuna Mtandao',
        'Tafadhali washa mtandao kwenye simu yako',

        colorText: Colors.white,

        backgroundColor: Colors.red,

        snackPosition: SnackPosition.TOP,

        margin: const EdgeInsets.all(10),

        icon: const Icon(Icons.wifi_off, color: Colors.white),
      );
    });
  }

  void _stopTimer() {
    _noInternetTimer?.cancel();

    _noInternetTimer = null;
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();

      return result != ConnectivityResult.none;
    } on PlatformException {
      return false;
    }
  }

  @override
  void onClose() {
    _sub.cancel();

    _stopTimer();

    super.onClose();
  }
}
