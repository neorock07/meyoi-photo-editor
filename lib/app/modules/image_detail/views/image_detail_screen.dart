import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/app/modules/image_detail/controllers/image_detail_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/button_box_widget.dart';
import 'package:meyoi/routes/app_pages.dart';

class ImageDetailScreen extends GetView<ImageDetailController> {
  EditController edit_controller = Get.put(EditController());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: () async {
          controller.selectedImage.value = null;
          edit_controller.selectedImage.value = null;
          Get.back();

          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 80.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.PinkDark,
                      AppColors.VioletDark,
                      AppColors.VioletBright,
                      AppColors.PinkBright,
                    ],
                    stops: [0.0, 0.2, 0.6, 1.0],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SizedBox(width: 2.w),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: () {
                          // Get.offAndToNamed(Routes.BOTTOM_NAV);
                          controller.selectedImage.value = null;
                          edit_controller.selectedImage.value = null;
                          Get.back();
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: ButtonBoxWidget(
                          height: 25.h,
                          width: 0.3,
                          text: "Make Up",
                          backgroundColor: Colors.white,
                          fontColor: Colors.black,
                          fontSize: 12.sp,
                          onTap: () async {
                            edit_controller
                                .processImg(controller.selectedImage.value!)
                                .then((_) {
                                  edit_controller.isImageProcessed.value = true;
                                  edit_controller.selectedImage.value =
                                      controller.selectedImage.value;
                                  Get.toNamed(
                                    (edit_controller.isErrorPicking.value)
                                        ? Routes.BOTTOM_NAV
                                        : Routes.LOADING,
                                  );
                                });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height - 80.h,
                width: double.infinity,
                child: Center(
                  child: InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(0),
                    minScale: 0.5,
                    maxScale: 3.0,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: Image.file(
                      File(controller.selectedImage.value!.path),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
