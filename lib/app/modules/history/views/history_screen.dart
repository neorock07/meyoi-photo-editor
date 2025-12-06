import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meyoi/app/modules/home/controllers/home_controller.dart';
import 'package:meyoi/app/modules/image_detail/controllers/image_detail_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/routes/app_pages.dart';

class HistoryScreen extends GetView<HomeController> {
  
  ImageDetailController img_controller = Get.put(ImageDetailController());

  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80.h,
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
              child: Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'History',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            RefreshIndicator(
              onRefresh: controller.loadImages,
              child: Container(
                height:
                    MediaQuery.of(context).size.height *
                    0.85, 
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
                        const SizedBox(height: 10),
                        // Pastikan path asset svg benar
                        // SvgPicture.asset(...)
                        Text(
                          "No images found",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    );
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 20.h,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Menampilkan 2 kolom
                      crossAxisSpacing: 15.w, // Jarak antar kolom (horizontal)
                      mainAxisSpacing: 20.h, // Jarak antar baris (vertikal)
                      childAspectRatio:
                          0.72, // Rasio lebar:tinggi item (atur ini agar teks tidak overflow)
                    ),
                    itemCount: controller.imageFiles.length,
                    itemBuilder: (context, index) {

                      final File file = File(controller.imageFiles[index].path);
                      final String fileName = file.path.split('/').last;
                      final DateTime modifiedDate = file.statSync().modified;
                      // Sesuaikan dengan model Anda

                      return InkWell(
                        onTap: () {
                          // Logika Tap Anda
                          img_controller.selectedImage.value = XFile(file.path);
                          Get.toNamed(Routes.IMAGE_DETAIL);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. GAMBAR (Mengisi sisa ruang ke atas)
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20.r,
                                  ), // Sudut membulat besar
                                  color: Colors.grey[100],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Image.file(file, fit: BoxFit.cover),
                                ),
                              ),
                            ),

                            SizedBox(height: 10.h),

                            // 2. NAMA FILE & ICON DELETE
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Nama File
                                Expanded(
                                  child: Text(
                                    fileName, // "Nama File"
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight:
                                          FontWeight.bold, // Bold sesuai gambar
                                      fontSize: 16.sp,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                SizedBox(width: 8.w),

                                // Icon Sampah
                                GestureDetector(
                                  onTap: () => controller.deleteImage(file),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.black87, // Hitam/Abu gelap
                                    size: 22.dm,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 4.h),

                            // 3. TANGGAL
                            Text(
                              controller.formatDate(
                                modifiedDate,
                              ), // "27/12/2025"
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12.sp,
                                color: Colors.black54, // Abu-abu kecil
                              ),
                            ),
                          ],
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
    );
  }
}
