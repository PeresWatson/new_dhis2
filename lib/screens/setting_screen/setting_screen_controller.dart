import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingScreenController  extends GetxController{


@override
void onInit() {
  super.onInit();

  final storage = GetStorage();

  if (storage.hasData('last_sync')) {
    lastSync.value = storage.read('last_sync');
  }
}

final storage = GetStorage();
final RxString lastSync = "Never".obs;
  final serverOnline = true.obs;

  // Sync
  final wifiOnly = true.obs;
  final autoSync = true.obs;

  // Storage
  final storageUsed = 0.65.obs;
  final storageMb = 248.0.obs;

  // Appearance
  final darkMode = false.obs;

  void toggleWifi(bool v) => wifiOnly.value = v;
  void toggleAutoSync(bool v) => autoSync.value = v;
  void toggleDarkMode(bool v) => darkMode.value = v;

  void clearCache() {
    storageUsed.value = 0.1;
    storageMb.value = 40;
    Get.snackbar("Storage", "Cache cleared");
  }

  void syncNow() {
    Get.snackbar("Sync", "Synchronization started...");
  }

  void logout() {
    Get.snackbar("Logout", "Session ended");
  }


void updateSyncTime() {
  final now = DateTime.now().toIso8601String();

  GetStorage().write('last_sync', now);

  lastSync.value = now;
}

}