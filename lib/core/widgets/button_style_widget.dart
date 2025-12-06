import 'package:meyoi/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget ButtonStyleWidget({
  VoidCallback? onPressed,
  Color? color,
  double? width,
  double? height,
  required String? icon, 
  required String? title,
  EdgeInsetsGeometry? padding,
  BorderRadiusGeometry? borderRadius,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: SvgPicture.asset(
            icon!,
            color: color,
            height: height,
            width: width,
          ),
        ),
    
        Text(
          title!,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.black, 
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
            ),
        ),
      ],
    ),
  );
}
