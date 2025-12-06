import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/app/modules/loading_image/controllers/loading_image_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoadingImageScreen extends GetView<LoadingImageController> {

  LoadingImageScreen({Key? key}) : super(key: key);

  EditController edit_controller = Get.put(EditController());

  @override
  Widget build(BuildContext context) {
    final _ = controller;
    
    return WillPopScope(
      
      onWillPop: () async{ 
          Get.back();
          edit_controller.selectedImage.value = null;
          return false;
       },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              CircularProgressIndicator(
                strokeWidth: 4.w,
                semanticsLabel: "Loading Image ...",
                color: AppColors.PinkBright),
              Text(
                "Process Image ...",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 12.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
