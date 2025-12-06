import 'package:meyoi/app/modules/terms/terms_controllers/terms_controller.dart';
import 'package:get/get.dart';

class TermsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsController>(() => TermsController());
  }
}
