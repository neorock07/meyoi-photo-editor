import 'package:meyoi/app/modules/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:meyoi/core/constants/banner_text.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/button_box_widget.dart';
import 'package:meyoi/core/widgets/button_gradient_widget.dart';
import 'package:meyoi/core/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

BottomNavController bottomNavController = Get.find<BottomNavController>();

Future<dynamic> DialogLogout(
  BuildContext context,
  double height,
  double width,
) {
  return DialogPop(
    context,
    size: [height, width],
    icon: [
      Image.asset(
        'assets/images/logout_img.png',
        width: 150.dm,
        height: 150.dm,
      ),
      SizedBox(height: 10.h),
      Text(
        "Are you sure want to logout?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 10.h),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left:5.w),
            child: SizedBox(
              height: 50.h,
              width: width / 3,
              child: ButtonBoxBorderWidget(
                onTap: () {
                  Get.back();
                },
                height: 50.h,
                width: 20.h,
                text: "No",
                isShadow: false,
                borderColor: AppColors.VioletDark2,
                fontColor: AppColors.VioletDark2,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(right:5.w),
            child: SizedBox(
              height: 50.h,
              width: width / 3,
              child: ButtonGradientWidget(
                height: 50.h,
                width: 20.h,
                text: "Yes",
                onTap: () async{
                  await bottomNavController.logOut();
                },
                fontColor: Colors.white,
                backgroundColor: [AppColors.PinkDark2, AppColors.VioletDark2],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
