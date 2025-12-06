import 'package:meyoi/app/modules/loading_image/controllers/loading_image_controller.dart';
import 'package:get/get.dart';

class LoadingImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadingImageController>(() => LoadingImageController());
  }
}
