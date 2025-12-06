import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/app/modules/home/controllers/home_controller.dart';
import 'package:meyoi/core/constants/banner_text.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/button_box_widget.dart';
import 'package:meyoi/core/widgets/button_gradient_widget.dart';
import 'package:meyoi/core/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<dynamic> DialogColorPicker(
  BuildContext context,
  double height,
  double width,
) {
  EditController controller = Get.find<EditController>();

  return DialogPop(
    context,
    size: [height, width],
    icon: [
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Pick a Color!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: "Poppins",
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),

      SizedBox(height: 5.h),
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: ColorPicker(
          pickerColor: controller.pickerColor.value,
          onColorChanged: controller.onColorChanged,
        ),
      ),
      SizedBox(height: 5.h),
      ButtonBoxWidget(
        width: width,
        height: 40.h,
        text: "Get it!",
        fontSize: 14.sp,
        onTap: () {
          controller.currentColor.value = controller.pickerColor.value;
        
          if (controller.selectedTool.value == "Lipstick") {
            controller.lipColor.value = controller.currentColor.value;
          } else if (controller.selectedTool.value == "Skin") {
            controller.FaceColorMode();
            controller.faceColor.value = controller.currentColor.value;
          } else if (controller.selectedTool.value == "Cheek") {
            controller.CheekColorMode();
            controller.cheekColor.value = controller.currentColor.value;
          } else if (controller.selectedTool.value == "Eyecolor") {
            controller.IrisColorMode();
            controller.irisColor.value = controller.currentColor.value;
          } else if (controller.selectedTool.value == "Eyebrow") {
            controller.eyebrowColor.value = controller.currentColor.value;
          } else if (controller.selectedTool.value == "Eyelash") {
            controller.eyelashColor.value = controller.currentColor.value;
          }
          log("current color : ${controller.currentColor.value}");
          log("picker color : ${controller.pickerColor.value}");
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
