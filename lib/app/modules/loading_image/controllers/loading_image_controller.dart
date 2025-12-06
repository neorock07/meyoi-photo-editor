import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:get/get.dart';

class LoadingImageController extends GetxController {
  EditController editController = Get.put(EditController());

  @override
  void onInit() {
    GoToEdit();
    super.onInit();
  }

  // @override
  //   void onClose() {
  //     editController.dispose();
  //     super.onClose();
  //   }

  

  // @override
  // void onReady() {
  //   GoToEdit();
  //   super.onReady();
  // }

  void GoToEdit() {
    if (editController.isImageProcessed.value) {
      Future.delayed(Duration(milliseconds: 500)).then((_) {
        Get.offNamed(Routes.EDIT);
        editController.isImageProcessed.value = false;
      });
    }
  }
}
