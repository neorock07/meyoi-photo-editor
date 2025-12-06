import 'package:meyoi/core/constants/banner_text.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/button_gradient_widget.dart';
import 'package:meyoi/core/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<dynamic> DialogHome(
  BuildContext context, 
  double height, 
  double width
  ){
  return DialogPop(
    context, 
    size: [height, width],
    icon: [
      Image.asset(
        'assets/images/home_bn.png',
        width: 150.dm,
        height: 150.dm,
      ),
      SizedBox(height: 10.h),
      Text(
        BannerText.homeDialogTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 15.h),
      ButtonGradientWidget(
        height: 50.h,
        width: 20.h,
        text: "Continue",
        onTap: (){
          Get.back();
        },
        fontColor: Colors.white,
        backgroundColor: [
          AppColors.PinkDark2,
          AppColors.VioletDark2,
        ])
    ]
    );
}