import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/app/modules/home/controllers/home_controller.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

EditController controller = Get.find<EditController>();
HomeController home_controller = Get.find<HomeController>();

Future<bool> showExitDialog() async {
  final result = Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        "Warning!",
        style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "Are you sure you want to exit? Unsaved changes will be lost.",
        style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.grey,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () async{
            controller.isImageProcessed.value = false;
            controller.isLipColored.value = false;
            controller.isEyebrowColored.value = false;
            controller.isEyelashColored.value = false;
            controller.isCheekColored.value = false;
            controller.isFaceColored.value = false;
            await controller.deleteImageTemp();
            Get.offNamed(Routes.BOTTOM_NAV)?.then((value) {
              controller.selectedImage.value = null;
              controller.isErrorPicking.value = false;
              // home_controller.loadImages();
            });
          },
          child: Text(
            "Yes",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: false,
  );

  return result == true;
}
