import 'dart:developer';
import 'dart:ui';

import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomSheetTools extends StatelessWidget {
  const BottomSheetTools({Key? key}) : super(key: key);

  EditController get controller => Get.find<EditController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: Duration(milliseconds: 600),
        curve: Curves.decelerate,
        bottom: controller.isToolsPanelVisible.value ? 80.h : -180.h,
        // left: 0,
        // right: 0,
        width: MediaQuery.of(context).size.width * 0.7,
        height: 80.h,
        child: GestureDetector(
          onTap: () {},
          onPanDown: (_) {
            controller.hideTools();
          },
          child: Container(
            height: 80.h,
            width: MediaQuery.of(context).size.width * 0.4,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.r,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.crop,
                            color: Colors.white,
                            size: 22.dm,
                          ),
                          onPressed: () async {
                            await controller.cropImage();
                            controller.isButtonTaped.value = false;  
                      log("Nilai isButtonTaped: ${controller.isButtonTaped.value}");
                          },
                        ),
                        Text(
                          "Crop",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: "Poppins",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.brightness_4_rounded,
                            color: Colors.white,
                            size: 22.dm,
                          ),
                          onPressed: () {
                            controller.openSheetBrightness.value = !controller.openSheetBrightness.value;
                            controller.isButtonTaped.value = true;  
                      log("Nilai isButtonTaped: ${controller.isButtonTaped.value}");
                          },
                        ),
                        Text(
                          "Brightness",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: "Poppins",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.contrast_outlined,
                            color: Colors.white,
                            size: 22.dm,
                          ),
                          onPressed: () {
                            controller.openSheetContrast.value = !controller.openSheetContrast.value;
                            controller.isButtonTaped.value = true;  
                      log("Nilai isButtonTaped: ${controller.isButtonTaped.value}");
                          },
                        ),
                        Text(
                          "Contrast",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: "Poppins",
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
