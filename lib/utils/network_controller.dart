import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkServiceController extends GetxController {
  final isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();

    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        isOnline.value = false;
      } else {
        isOnline.value = true;
      }
    });
  }
}


