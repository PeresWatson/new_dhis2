import 'package:d2_touch/d2_touch.dart';
import 'package:get/get.dart';

class D2Service extends GetxService {
  late D2Touch d2;

  Future<D2Service> init() async {
    d2 = await D2Touch.init();
    return this;
  }
}
