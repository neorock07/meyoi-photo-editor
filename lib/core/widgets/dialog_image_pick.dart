import 'dart:developer';

import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/dialog_widget.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<dynamic> DialogImagePick(
  BuildContext context,
  double height,
  double width,
) {
  EditController controller = Get.put(EditController());

  return DialogPop(
    context,
    size: [height, width],
    icon: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Choose Media",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: "Poppins",
              fontWeight: FontWeight.normal,
              color: AppColors.PinkDark2,
            ),
          ),

          IconButton(
            icon: Icon(Icons.close, size: 18.dm, color: Colors.grey),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      SizedBox(height: 15.h),
      Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.grey.withOpacity(0.3),
          onTap: () {
            controller.pickImage(ImageSource.gallery, context).then((_) {
              controller.isImageProcessed.value = true;
              Get.back();
              log("isError : ${controller.isErrorPicking.value}");

              Get.toNamed(
                (controller.isErrorPicking.value)
                    ? Routes.BOTTOM_NAV
                    : Routes.LOADING,
              );
              if (controller.isErrorPicking.value == true) {
                Get.snackbar(
                  "Cancelled",
                  "Sorry, please retake the picture again.",
                  snackPosition: SnackPosition.TOP,
                );
              }
              controller.isErrorPicking.value = false;
            });
          },
          child: Row(
            children: [
              Icon(Icons.image, size: 25.dm, color: Colors.black),
              SizedBox(width: 10.w),
              Text(
                "Choose from Gallery",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10.h),
      Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.grey.withOpacity(0.3),
          // onTap: () => controller.pickImage(ImageSource.camera),
          onTap: () {
            controller.pickImage(ImageSource.camera, context).then((_) {
              controller.isImageProcessed.value = true;
              
              log("isError : ${controller.isErrorPicking.value}");
              Get.toNamed(
                (controller.isErrorPicking.value)
                    ? Routes.BOTTOM_NAV
                    : Routes.LOADING,
              );
              if (controller.isErrorPicking.value == true) {
                Get.snackbar(
                  "Cancelled",
                  "Sorry, please retake the picture again.",
                  snackPosition: SnackPosition.TOP,
                );
              }
              controller.isErrorPicking.value = false;
            });
          },
          child: Row(
            children: [
              Icon(Icons.camera_alt, size: 25.dm, color: Colors.black),
              SizedBox(width: 10.w),
              Text(
                "Take a Picture",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
