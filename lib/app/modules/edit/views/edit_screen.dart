import 'dart:io';

import 'package:meyoi/app/modules/edit/controllers/edit_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/utils/face_mesh_painter.dart';
import 'package:meyoi/core/widgets/button_box_widget.dart';
import 'package:meyoi/core/widgets/button_style_widget.dart';
import 'package:meyoi/core/widgets/dialog_exit_editor.dart';
import 'package:meyoi/core/widgets/sheet_brightness.dart';
import 'package:meyoi/core/widgets/sheet_contrast.dart';
import 'package:meyoi/core/widgets/sheet_eyelash_style_widget.dart';
import 'package:meyoi/core/widgets/sheet_lipstick_style_widget.dart';
import 'package:meyoi/core/widgets/sheet_pallete_widget.dart';
import 'package:meyoi/core/widgets/sheet_eyebrow_style_widget.dart';
import 'package:meyoi/core/widgets/sheet_tools_widget.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditScreen extends GetView<EditController> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: WillPopScope(
        onWillPop: () async {
          return showExitDialog();
        },
        child: Scaffold(
          backgroundColor: AppColors.AbuBackground,
          body: Column(
            children: [
              Container(
                width: double.infinity,
                height: 80.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: () async {
                          await showExitDialog();
                        },
                      ),

                      SizedBox(width: 8.w),
                      Row(
                        children: [
                          Obx(
                            () => IconButton(
                              onPressed: controller.canUndo
                                  ? () => controller.undo()
                                  : null,
                              icon: Icon(
                                Icons.undo_rounded,
                                color: controller.canUndo
                                    ? Colors.white
                                    : Colors.white38, // Dim jika disabled
                                size: 24.dm,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Obx(
                            () => IconButton(
                              onPressed: controller.canRedo
                                  ? () => controller.redo()
                                  : null,
                              icon: Icon(
                                Icons.redo_rounded,
                                color: controller.canRedo
                                    ? Colors.white
                                    : Colors.white38,
                                size: 24.dm,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Obx(
                        () =>
                            (controller.isButtonTaped.value
                            //  &&
                            // controller.selectedTool.value != "Tools"
                            )
                            ? ButtonBoxWidget(
                                height: 25.h,
                                width: 0.3,
                                text: "Done",
                                backgroundColor: Colors.white,
                                fontColor: Colors.black,
                                fontSize: 12.sp,
                                onTap: () async {
                                  final imageBytes = await controller
                                      .captureFilteredImage();
                                  await controller.replaceImage(imageBytes);
                                  controller.unselectedTool();
                                },
                              )
                            : Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      // controller.saveImage();
                                      controller.saveImageWithMetadata();
                                    },
                                    icon: Icon(
                                      Icons.file_download_outlined,
                                      color: Colors.white,
                                      size: 24.dm,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await controller.processImg(
                                        controller.selectedImage.value!,
                                      );
                                      Get.snackbar(
                                        "Mesh Refreshed",
                                        "Face mesh has been successfully refreshed.",
                                        snackPosition: SnackPosition.TOP,
                                        colorText: Colors.white,
                                        backgroundColor: Colors.green
                                            .withOpacity(0.8),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.refresh_rounded,
                                      color: Colors.white,
                                      size: 24.dm,
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () async {},
                                  //   icon: Icon(
                                  //     Icons.save,
                                  //     color: Colors.white,
                                  //     size: 24.dm,
                                  //   ),
                                  // ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 100.h,
                        left: 5.w,
                        right: 5.w,
                      ),
                      child: Center(
                        child: InteractiveViewer(
                          boundaryMargin: EdgeInsets.all(0),
                          minScale: 0.5,
                          maxScale: 3.0,
                          panEnabled: true,
                          scaleEnabled: true,
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: controller.imageAspectRatio.value,
                              child: RepaintBoundary(
                                key: controller.repaintBoundaryKey,
                                child: Obx(() {
                                  double b = controller.brightness.value;
                                  double c = controller.contrast.value;

                                  // === Brightness Matrix ===
                                  final brightnessMatrix = [
                                    1,
                                    0,
                                    0,
                                    0,
                                    b * 255,
                                    0,
                                    1,
                                    0,
                                    0,
                                    b * 255,
                                    0,
                                    0,
                                    1,
                                    0,
                                    b * 255,
                                    0,
                                    0,
                                    0,
                                    1,
                                    0,
                                  ];

                                  // === Contrast Matrix ===
                                  double C = c + 1; // scale
                                  double T = 128 * (1 - C); // translation

                                  final contrastMatrix = [
                                    C,
                                    0,
                                    0,
                                    0,
                                    T,
                                    0,
                                    C,
                                    0,
                                    0,
                                    T,
                                    0,
                                    0,
                                    C,
                                    0,
                                    T,
                                    0,
                                    0,
                                    0,
                                    1,
                                    0,
                                  ];

                                  // ===== Combine brightness + contrast =====
                                  final combinedMatrix = List<double>.generate(
                                    20,
                                    (i) {
                                      return brightnessMatrix[i] +
                                          contrastMatrix[i] -
                                          (i % 6 == 0 ? 1 : 0);
                                    },
                                  );
                                  return CustomPaint(
                                    foregroundPainter: FaceMeshPainter(
                                      meshes: controller.face_mesh.value,
                                      originalImageSize:
                                          controller.image_size_origin.value ??
                                          Size.zero,
                                      strokes: controller.painted_points
                                          .toList(),
                                      applyLipColor:
                                          controller.isLipColored.value,
                                      applyIrisColor:
                                          controller.isIrisColored.value,
                                      irisColor: controller.irisColor.value,
                                      blushColor: controller.blushColor.value,
                                      lipstickColor: controller.lipColor.value,
                                      upperLipTexture:
                                          controller.upperLipTexture.value,
                                      lowerLipTexture:
                                          controller.lowerLipTexture.value,
                                      selectedStyle:
                                          controller.selectedStyle.value,
                                      applyFaceSkin:
                                          controller.isFaceColored.value,
                                      faceSkinColor: controller.faceColor.value,
                                      applyCheekColor:
                                          controller.isCheekColored.value,
                                      cheekColor: controller.cheekColor.value,
                                      skinOpacity:
                                          controller.opacity["Skin"].value,
                                      lipOpacity:
                                          controller.opacity["Lipstick"].value,
                                      irisOpacity:
                                          controller.opacity["Eyecolor"].value,
                                      cheekOpacity:
                                          controller.opacity["Cheek"].value,
                                      eyebrowOpacity:
                                          controller.opacity["Eyebrow"].value,
                                      applyEyebrowColor:
                                          controller.isEyebrowColored.value,
                                      eyebrowColor:
                                          controller.eyebrowColor.value,
                                      eyebrowStyle:
                                          controller.eyebrowStyle.value,
                                      applyEyelashColor:
                                          controller.isEyelashColored.value,
                                      leftEyelashTexture:
                                          controller.leftEyelashTexture.value,
                                      rightEyelashTexture:
                                          controller.rightEyelashTexture.value,
                                      eyelashOpacity:
                                          controller.opacity["Eyelash"].value,
                                      eyelashColor:
                                          controller.eyelashColor.value,
                                    ),
                                    child: ColorFiltered(
                                      colorFilter: ColorFilter.matrix(
                                        combinedMatrix,
                                      ),
                                      child:
                                          (controller.selectedImage.value ==
                                              null)
                                          ? CircularProgressIndicator()
                                          : Image.file(
                                              File(
                                                controller
                                                    .selectedImage
                                                    .value!
                                                    .path,
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    BottomSheetPalette(),
                    BottomSheetTools(),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 80.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8.r,
                              offset: Offset(0, -10.h),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.editMenuList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                child: Obx(
                                  () => (index == 0)
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                // controller
                                                //     .isEditButtonTaped
                                                //     .value = !controller
                                                //     .isEditButtonTaped
                                                //     .value;

                                                controller.setSelectedTool(
                                                  controller
                                                      .editMenuList[index]['title'],
                                                );

                                                // controller.hidePallete();

                                                controller.isButtonTaped.value =
                                                    !controller
                                                        .isButtonTaped
                                                        .value;
                                                (controller
                                                            .isButtonTaped
                                                            .value ==
                                                        false)
                                                    ? controller.hideTools()
                                                    : null;
                                              },
                                              icon: Icon(
                                                Icons.crop,
                                                size: 25.dm,
                                                color:
                                                    (controller
                                                                .selectedTool
                                                                .value ==
                                                            controller
                                                                .editMenuList[index]['title'] &&
                                                        controller
                                                            .isButtonTaped
                                                            .value)
                                                    ? AppColors.VioletDark2
                                                    : Colors.black,
                                              ),
                                            ),
                                            Text(
                                              "Tools",
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        )
                                      : ButtonStyleWidget(
                                          height: 25.h,
                                          width: 25.w,
                                          color:
                                              (controller.selectedTool.value ==
                                                      controller
                                                          .editMenuList[index]['title'] &&
                                                  controller
                                                      .isButtonTaped
                                                      .value)
                                              ? AppColors.VioletDark2
                                              : Colors.black,
                                          onPressed: () {
                                            controller.setSelectedTool(
                                              controller
                                                  .editMenuList[index]['title'],
                                            );

                                            controller.isButtonTaped.value =
                                                !controller.isButtonTaped.value;
                                            (controller.isButtonTaped.value ==
                                                    false)
                                                ? controller.hidePallete()
                                                : null;

                                            // controller.hideTools();
                                          },
                                          icon: controller
                                              .editMenuList[index]['icon'],
                                          title: controller
                                              .editMenuList[index]['title'],
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    BottomSheetEyebrowStyle(),
                    BottomSheetLipstickStyle(),
                    BottomSheetEyelashStyle(),
                    SheetBrightness(),
                    SheetContrast(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
