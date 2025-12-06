import 'dart:developer';

import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/box_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SheetContrast extends StatelessWidget {
  const SheetContrast({Key? key}) : super(key: key);

  EditController get controller => Get.find<EditController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        bottom: controller.openSheetContrast.value ? 10.h : -180.h,
        left: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {},
          onPanDown: (_) {
            // controller.hidePallete();
          },
          child: Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10.r,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.contrast,
                  color: AppColors.PinkBright,
                  size: 25.dm,
                ),
                Obx(
                  () => Slider(
                    value: controller.contrast.value,
                    min: -1.0,
                    max: 1.0,
                    divisions: 20,
                    thumbColor: AppColors.VioletDark2,
                    activeColor: AppColors.PinkBright,
                    inactiveColor: Colors.white24,
                    onChanged: (value) {
                      controller.setContrast(value);
                    },
                  ),
                ),
                // Value preview
                Obx(
                  () => Text(
                    controller.contrast.value.toStringAsFixed(2),
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
