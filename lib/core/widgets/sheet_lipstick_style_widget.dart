import 'dart:developer';

import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/box_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomSheetLipstickStyle extends StatelessWidget {
  const BottomSheetLipstickStyle({Key? key}) : super(key: key);

  EditController get controller => Get.find<EditController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        bottom: controller.openStyleLipstickSheet.value ? 10.h : -180.h,
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.listLipstick.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: GestureDetector(
                    onTap: () {
                      controller.isPalleteVisible.value = true;
                      controller.selectedStyleTool(
                        controller.listLipstick[index]['title'],
                      );
                      controller.isStyleTaped.value =
                          !controller.isStyleTaped.value;

                      controller.LipColorMode();
                      controller.isButtonTaped.value = true;  
                      log("Nilai isButtonTaped: ${controller.isButtonTaped.value}");
                      log("Nilai isLipColored: ${controller.isLipColored.value}");
                    },

                    child: index == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                 controller.listLipstick[index]['icon'],
                                width: 28.w,
                                height: 28.h,
                              ),
                              Text(
                                controller.listLipstick[index]['title'],
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: "Poppins",
                                  color: AppColors.VioletDark2,
                                ),
                              ),
                            ],
                          )
                        : Obx(
                            () => BoxStyleWidget(
                              title: controller.listLipstick[index]['title'],
                              asset: controller.listLipstick[index]['icon'],
                              gradient:
                                  (controller.selectedStyle.value ==
                                      controller.listLipstick[index]['title'])
                                  ? [
                                      AppColors.VioletDark2.withAlpha(190),
                                      AppColors.PinkBright.withAlpha(190),
                                    ]
                                  : [Colors.grey, Colors.black],
                              borderColor:
                                  (controller.selectedStyle.value ==
                                      controller.listLipstick[index]['title'])
                                  ? AppColors.PinkBright.withAlpha(190)
                                  : Colors.grey,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
