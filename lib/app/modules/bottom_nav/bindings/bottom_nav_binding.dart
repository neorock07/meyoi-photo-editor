import 'package:meyoi/app/modules/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomNavController());
  }
}
