import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meyoi/app/modules/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:meyoi/app/modules/home/controllers/home_controller.dart';
import 'package:meyoi/core/constants/banner_text.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/banner_widget.dart';
import 'package:meyoi/core/widgets/button_anim_widget.dart';
import 'package:meyoi/core/widgets/dialog_image_pick.dart';
import 'package:meyoi/core/widgets/dialog_tutorial.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:meyoi/app/modules/image_detail/controllers/image_detail_controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  HomeController controller = Get.put(HomeController());
  ImageDetailController img_controller = Get.put(ImageDetailController());
  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    // final _ = controller;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 35.h),
                    Obx(
                      () => RichText(
                        text: TextSpan(
                          text: "Hai",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: " ${bottomNavController.nameUser.value}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.PinkDark2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    BannerWidget(
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.9,
                      text: BannerText.bannerTitle,
                      colors: [AppColors.PinkDark2, AppColors.VioletDark2],
                      fontColor: Colors.white,
                      onTap: () {
                        DialogImagePick(
                          context,
                          MediaQuery.of(context).size.height * 0.2,
                          100.w,
                        );
                      },
                    ),
                    SizedBox(height: 10.h),

                    AnimatedGradientBorderButton(
                      height: 40.h,
                      strokeWidth: 5.dm,
                      width: MediaQuery.of(context).size.width * 0.9,
                      borderRadius: 5.dm,
                      onTap: () async {
                        DialogTutorial(
                          context,
                          MediaQuery.of(context).size.height * 0.45,
                          MediaQuery.of(context).size.width * 0.8,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.book_solid,
                            color: AppColors.VioletDark2,
                            size: 20.dm,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "Tutorial",
                            style: TextStyle(
                              color: AppColors.VioletDark2,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              "Recent history",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.HISTORY);
                                  },
                                  child: Text(
                                    "see more",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.PinkDark2,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),

                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.PinkDark2,
                                  size: 16.dm,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              RefreshIndicator(
                onRefresh: controller.loadImages,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  color: Colors.white,
                  child: Obx(() {
                    if (controller.isLoadingImages.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.imageFiles.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported_outlined,
                            size: 60,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 10),
                          SvgPicture.asset(
                            "assets/images/notfound.svg",
                            height: 100.dm,
                            width: 100.dm,
                            fit: BoxFit.contain,
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      itemCount: controller.imageFiles.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[200],
                        thickness: 1,
                        height: 30.h,
                      ),
                      itemBuilder: (context, index) {
                        final File file = File(
                          controller.imageFiles[index].path,
                        );
                        final String fileName = file.path.split('/').last;
                        final DateTime modifiedDate = file.statSync().modified;

                        // final item = controller.imageFiles[index];

                        return InkWell(
                          onTap: () {
                            img_controller.selectedImage.value = XFile(
                              file.path,
                            );
                            Get.toNamed(Routes.IMAGE_DETAIL)?.then((v) {
                              (img_controller.selectedImage.value == null)
                                  ? null
                                  : Get.dialog(
                                      const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.PinkBright,
                                        ),
                                      ),
                                      barrierDismissible: false,
                                    );
                            });
                          },
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Image.file(
                                    File(file.path),
                                    width: 60.w,
                                    height: 60.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                SizedBox(width: 15.w),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              fileName,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.sp,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                controller.deleteImage(file),
                                            child: Icon(
                                              Icons.delete_outline,
                                              color: Colors.grey[600],
                                              size: 20.dm,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 8.h),

                                      Row(
                                        children: [
                                          // Tags (Contoh Statis, sesuaikan jika ada data real)
                                          // Container(
                                          //   width: 100.w,
                                          //   child: SingleChildScrollView(
                                          //     scrollDirection: Axis.horizontal,
                                          //     child: Text(
                                          //       item.editedArea,
                                          //       style: TextStyle(
                                          //         fontFamily: "Poppins",
                                          //         fontSize: 12.sp,
                                          //         color: Colors.black87,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                          // // Garis Pemisah Vertikal
                                          // Container(
                                          //   height: 14.h,
                                          //   width: 1.w,
                                          //   margin: EdgeInsets.symmetric(
                                          //     horizontal: 10.w,
                                          //   ),
                                          //   color: Colors.grey[400],
                                          // ),

                                          // Tanggal & Waktu
                                          Text(
                                            controller.formatDate(modifiedDate),
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 12.sp,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
