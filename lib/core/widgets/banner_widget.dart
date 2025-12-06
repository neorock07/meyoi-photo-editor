import 'package:meyoi/core/widgets/button_box_widget.dart'; // Sesuaikan path ini
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget BannerWidget({
  required double height,
  required double width,
  required String text,
  required List<Color> colors,
  required Function() onTap,
  double borderRadius = 10,
  Color fontColor = Colors.black,
}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            // height: 80.h,
            // color: Colors.red,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    image: DecorationImage(
                      image: AssetImage("assets/images/Poly.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                
                
                Padding(
                  padding: EdgeInsets.only(top: 10.h, left: 10.w),
                  child: Image.asset(
                    "assets/images/Shine.png",
                    height: 100.h,
                    width: 100.dm,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Image.asset(
                    "assets/images/fk.png",
                    height: 180.h,
                    width: 120.dm,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // SvgPicture.asset(
        //   "assets/images/img_banner.svg",
        //   height: height / 1.5,
        //   width: width / 1.5,
        // ),
        SizedBox(width: 5.w),
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: width / 2,
                child: Text(
                  text,
                  style: TextStyle(
                    color: fontColor,
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Pindahkan ikon ke kanan
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: SvgPicture.asset(
                      "assets/images/panah.svg",
                      height: height / 5,
                      width: width / 5,
                    ),
                  ),
                
                  Padding(
                    padding: EdgeInsets.only(top: 5.h, left: 10.w),
                    child: ButtonBoxWidget(
                      height: 25.h,
                      width: 0.3,
                      text: "Make Up",
                      backgroundColor: Colors.white,
                      fontColor: Colors.black,
                      fontSize: 12.sp,
                      onTap: () {
                        onTap();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ],
    ),
  );
}
