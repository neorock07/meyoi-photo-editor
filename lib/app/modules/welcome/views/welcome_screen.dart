import 'package:meyoi/app/modules/welcome/controllers/welcome_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/button_box_widget.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
              stops: [
                0.0, 
                0.2, 
                0.6, 
                1.0, 
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  "assets/images/logo.svg",
                  height: 70.dm,
                  width: 70.dm,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Enhance Your Natural Beauty",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
      
                SizedBox(height: 20.h),
                Text(
                  "Discover stunning filters that bring out your best look in every photo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(height: 50.h),
      
                ButtonBoxWidget(
                  height: 50.h,
                  width: 0.9,
                  text: "Sign Up",
                  onTap: () {
                    Get.toNamed(Routes.HOME);
                    // Get.toNamed(Routes.REGISTER);
      
                  },
                ),
      
                SizedBox(height: 20.h),
                ButtonBoxBorderWidget(
                  onTap: () {
                    Get.toNamed(Routes.LOGIN);
                    print("Tombol ditekan!");
                  },
                  height: 50.h,
                  width: 0.9,
                  fontColor: Colors.white,
                  text: "Sign In",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
