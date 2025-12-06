import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/core/theme/colors.dart'; // Pastikan import ini ada
import 'package:meyoi/core/widgets/dialog_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomSheetPalette extends StatelessWidget {
  const BottomSheetPalette({Key? key}) : super(key: key);

  EditController get controller => Get.find<EditController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        // Tinggi disesuaikan agar muat Slider + Tombol Penghapus (sekitar 200.h)
        bottom: controller.isPalleteVisible.value ? 80.h : -300.h,
        left: 0,
        right: 0,
        child: GestureDetector(
          child: Container(
            // Tinggi ditambah
            height: 150.h,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10.r,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Slider Opasitas
                Row(
                  children: [
                    Text(
                      "Intensity",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        // Menggunakan value 0.6 sebagai default jika key belum ada
                        value:
                            (controller.opacity.containsKey(
                              controller.selectedTool.value,
                            ))
                            ? controller
                                  .opacity[controller.selectedTool.value]!
                                  .value
                            : 0.6,
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.pink, // Sesuaikan dengan AppColors
                        inactiveColor: Colors.grey.shade300,
                        onChanged: (value) {
                          // Pastikan map opacity sudah terisi untuk tool ini
                          if (controller.opacity.containsKey(
                            controller.selectedTool.value,
                          )) {
                            controller
                                    .opacity[controller.selectedTool.value]!
                                    .value =
                                value;
                          }
                        },
                      ),
                    ),
                    Text(
                      "${((controller.opacity.containsKey(controller.selectedTool.value) ? controller.opacity[controller.selectedTool.value]!.value : 0.6) * 100).toInt()}%",
                      style: TextStyle(fontFamily: "Poppins", fontSize: 12.sp),
                    ),
                    SizedBox(width: 10.w),
                    // GestureDetector(
                    //   onTap: () {
                    //     controller
                    //         .eraseMode(); // Memanggil fungsi di controller
                    //   },
                    //   child: AnimatedContainer(
                    //     duration: const Duration(milliseconds: 200),
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 12.w,
                    //       vertical: 6.h,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       // Warna berubah jika aktif
                    //       color: controller.isErasing.value
                    //           ? Colors.redAccent
                    //           : Colors.grey.shade100,
                    //       borderRadius: BorderRadius.circular(20.r),
                    //       border: Border.all(
                    //         color: controller.isErasing.value
                    //             ? Colors.redAccent
                    //             : Colors.grey.shade300,
                    //       ),
                    //     ),
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Icon(
                    //           Icons.cleaning_services_outlined,
                    //           size: 16.sp,
                    //           color: controller.isErasing.value
                    //               ? Colors.white
                    //               : Colors.black54,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),

                SizedBox(height: 5.h),

                // 2. Tombol Penghapus Manual (BARU)
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    
                  ],
                ),

                SizedBox(height: 10.h),

                // 3. Pilihan Warna (Palette)
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          controller.paletteColors.length,
                          (index) => GestureDetector(
                            onTap: () {
                              // Reset mode penghapus saat memilih warna baru
                              controller.isErasing.value = false;
                              controller.currentColor.value = controller.paletteColors[index]['color']; 

                              if (controller.selectedTool.value == "Lipstick") {
                                controller.lipColor.value =
                                    controller.currentColor.value;
                              } else if (controller.selectedTool.value ==
                                  "Skin") {
                                controller.FaceColorMode();
                                controller.faceColor.value = controller.
                                    currentColor.value;
                              } else if (controller.selectedTool.value ==
                                  "Cheek") {
                                controller.CheekColorMode();
                                controller.cheekColor.value =
                                    controller.currentColor.value;
                              } else if (controller.selectedTool.value ==
                                  "Eyecolor") {
                                controller.IrisColorMode();
                                controller.irisColor.value =
                                    controller.currentColor.value;
                              } 
                              else if (controller.selectedTool.value ==
                                  "Eyebrow") {
                                controller.eyebrowColor.value =
                                    controller.currentColor.value;
                              }
                              else if (controller.selectedTool.value ==
                                  "Eyelash") {
                                controller.eyelashColor.value =
                                    controller.currentColor.value;
                              }
                            },
                            child: index == 0
                                ? Text(
                                        "",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: "Poppins",
                                          color: Colors.transparent,
                                        ),
                                      )
                                : (index == controller.paletteColors.length -1)? 
                                Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.colorize, 
                                      size: 32.dm, 
                                      color: const Color.fromARGB(255, 80, 79, 79)),
                                      onPressed: () {
                                        DialogColorPicker(
                                          context,
                                          MediaQuery.of(context).size.height * 0.8,
                                          300.w,
                                        );
                                      },
                                    ),
                                  ],
                                ) :
                                Column(
                                    children: [
                                      Container(
                                        width: 32.w,
                                        height: 32.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(1.5.dm),
                                          child: Container(
                                            width: 32.w,
                                            height: 32.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  (controller
                                                          .selectedTool
                                                          .value ==
                                                      "Skin")
                                                  ? controller
                                                        .paletteColorsSkin[index]['color']
                                                  : controller
                                                        .paletteColors[index]['color'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        (controller.selectedTool.value ==
                                                "Skin")
                                            ? controller
                                                  .paletteColorsSkin[index]['name']
                                            : controller
                                                  .paletteColors[index]['name'],
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: "Poppins",
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
