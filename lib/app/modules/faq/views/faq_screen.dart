import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meyoi/app/modules/faq/controllers/faq_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/faq_item_widget.dart';

class FaqScreen extends GetView<FaqController> {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
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
                    'Frequently Asked Questions',
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                child: ListView(
                  children: const [
                    // Item 1
                    FaqItem(
                      question: "What is Meyoi?",
                      answer: "Meyoi is an AI-powered photo editing app that allows you to apply makeup filters and enhance your selfies effortlessly.",
                    ),
                    SizedBox(height: 12), // Jarak antar item
                    
                    // Item 2
                    FaqItem(
                      question: "Is Meyoi free to use?",
                      answer: "Yes, Meyoi offers free features, but there are premium filters available for subscribers.",
                    ),
                    SizedBox(height: 12),
                            
                    // Item 3
                    FaqItem(
                      question: "How do I use the makeup filters?",
                      answer: "Simply upload your photo, select the filter you like from the carousel, and tap apply.",
                    ),
                    SizedBox(height: 12),
                            
                    // Item 4 (Contoh posisi terbuka seperti di gambar)
                    FaqItem(
                      question: "Does Meyoi store my photos?",
                      answer: "No, Meyoi does not permanently store your photos. Images are only processed temporarily to apply filters, and we never share your personal data or photos without your consent.",
                      initiallyExpanded: true, // Agar default-nya terbuka
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}