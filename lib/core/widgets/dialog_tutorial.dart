import 'package:carousel_slider/carousel_slider.dart';
import 'package:meyoi/app/modules/home/controllers/home_controller.dart';
import 'package:meyoi/core/constants/banner_text.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/button_box_widget.dart';
import 'package:meyoi/core/widgets/button_gradient_widget.dart';
import 'package:meyoi/core/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<dynamic> DialogTutorial(
  BuildContext context,
  double height,
  double width,
) {
  HomeController controller = Get.put(HomeController());
  CarouselSliderController carouselController = CarouselSliderController();

  return DialogPop(
    context,
    size: [height, width],
    icon: [
      Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(
            Icons.close,
            size: 18.dm,
            color: Colors.grey,
          ),
          onPressed: () {
            controller.currentTutorIndex.value = 0;
            Navigator.of(context).pop();
          },
        ),
      ),

      CarouselSlider(
        carouselController: carouselController,
        options: CarouselOptions(
          height: height / 2.5,
          viewportFraction: 1,
          autoPlay: false,
          onPageChanged: (index, reason) {
            controller.currentTutorIndex.value = index;
          },
          enlargeCenterPage: true,
        ),
        items: BannerText.img_path.map((String imagePath) {
          return Builder(
            builder: (BuildContext context) {
              return Image.asset(
                imagePath,
                width: 200.dm,
                height: 150.dm,
                fit: BoxFit.contain,
              );
            },
          );
        }).toList(),
      ),

      SizedBox(height: 5.h),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: BannerText.img_path.asMap().entries.map((entry) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                carouselController.animateToPage(entry.key);
              },
              child: Container(
                width: 8.0.dm,
                height: 8.0.dm,
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      (controller.currentTutorIndex.value == entry.key
                              ? AppColors.PinkDark2
                              : Colors.grey)
                          .withOpacity(0.9),
                ),
              ),
            ),
          );
        }).toList(),
      ),

      SizedBox(height: 10.h),

      Obx(
        () => Text(
          BannerText.sub_tutorial[controller.currentTutorIndex.value],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),

      SizedBox(height: 10.h),

      SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50.h,
              width: width / 2.7,
              child: Obx(
                () => ButtonBoxBorderWidget(
                  onTap: () {
                    if (controller.currentTutorIndex.value == 0) {
                      controller.currentTutorIndex.value = 0;
                      Navigator.of(context).pop();
                    } else {
                      if (controller.currentTutorIndex.value <=
                          BannerText.img_path.length - 1) {
                        controller.currentTutorIndex.value--;
                        final newIndex = controller.currentTutorIndex.value;
                        carouselController.animateToPage(newIndex);
                      }
                    }
                  },
                  height: 50.h,
                  width: 20.h,
                  text: (controller.currentTutorIndex.value > 0)
                      ? "Back"
                      : "Skip",
                  isShadow: false,
                  borderColor: AppColors.VioletDark2,
                  fontColor: AppColors.VioletDark2,
                ),
              ),
            ),

            SizedBox(
              height: 50.h,
              width: width / 2.7,
              child: Obx(
                () => ButtonGradientWidget(
                  height: 50.h,
                  width: 20.h,
                  text:
                      (controller.currentTutorIndex.value ==
                          BannerText.img_path.length - 1)
                      ? "Understood"
                      : "Continue",
                  onTap: () {
                    if (controller.currentTutorIndex.value <
                        BannerText.img_path.length - 1) {
                      controller.currentTutorIndex.value++;
                    } else {
                      controller.currentTutorIndex.value = 0;
                      Navigator.of(context).pop();
                    }

                    final newIndex = controller.currentTutorIndex.value;
                    carouselController.animateToPage(newIndex);
                  },
                  fontColor: Colors.white,
                  backgroundColor: [AppColors.PinkDark2, AppColors.VioletDark2],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
