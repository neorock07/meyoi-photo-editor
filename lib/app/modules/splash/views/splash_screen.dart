import 'package:meyoi/app/modules/splash/controllers/splash_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _ = controller;

    return Scaffold(
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
            stops: [0.0, 0.2, 0.6, 1.0],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 100.dm,
              height: 100.dm,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Text(
                "MEYOI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
