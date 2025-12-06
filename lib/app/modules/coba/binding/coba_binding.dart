import 'package:meyoi/app/modules/coba/controller/coba_controller.dart';
import 'package:get/get.dart';

class CobaBinding extends Bindings {
  @override
  void dependencies() {
  
    Get.lazyPut<CobaController>(
      () => CobaController(),
    );
  
  }

}