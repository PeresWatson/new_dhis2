import 'package:get/get.dart';
import 'package:dhis_2/screens/login/login_screen_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Keeps it alive across route cleanups
    Get.put<LoginController>(LoginController(), permanent: true);
  }
}