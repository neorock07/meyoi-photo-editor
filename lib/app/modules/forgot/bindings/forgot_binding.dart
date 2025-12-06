import 'package:get/get.dart';
import 'package:meyoi/app/modules/forgot/controllers/forgot_controller.dart';

class ForgotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController()
    );
  }

}