import 'package:get/get.dart';
import 'package:meyoi/app/modules/image_detail/controllers/image_detail_controller.dart';

class ImageDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageDetailController>(
      () => ImageDetailController());
  }
}
