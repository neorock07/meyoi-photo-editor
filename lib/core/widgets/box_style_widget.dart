import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget BoxStyleWidget(
  {
  required String title,
  required String asset,
  required List<Color> gradient,
  required Color borderColor,
  }) {
  return Container(
    height: 60.dm,
    width: 60.dm,
    decoration: BoxDecoration(
      border: Border.all(color: borderColor, width: 2.dm),
      borderRadius: BorderRadius.circular(10.dm),
      image: DecorationImage(
        image: AssetImage(asset), 
        fit: BoxFit.cover
        )
    ),
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 20.h,
        width: 60.dm,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(7.dm),
            bottomRight: Radius.circular(7.dm),
          ),
          // color: AppColors.VioletDark2.withAlpha(190),
          gradient: LinearGradient(
            colors: gradient
            )
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: (title.length > 7) ? 7.sp : 9.sp,
            ),
          ),
        ),
      ),
    ),
  );
}
