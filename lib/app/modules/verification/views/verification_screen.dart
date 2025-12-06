import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meyoi/core/widgets/button_box_widget.dart';
import '../controllers/verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Verify your email!",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.dm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mark_email_unread_outlined,
                size: 100.dm,
                color: Colors.blue,
              ),
              SizedBox(height: 20.h),
              const Text(
                "Please check your email inbox!.",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "We have send verification code to your email!, please check.\nThis page will automatically change after verification",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              const CircularProgressIndicator(), // Indikator bahwa sistem sedang mengecek
              SizedBox(height: 10.h),
              const Text(
                "Checking status...",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 30.h),

              ButtonBoxWidget(
                height: 30.h,
                width: 0.35,
                text: "Resend Code",
                backgroundColor: Colors.white,
                fontColor: Colors.black,
                fontSize: 12.sp,
                onTap: controller.resendEmail,
              ),
              ButtonBoxWidget(
                height: 30.h,
                width: 0.4,
                text: "Cancel Verification",
                backgroundColor: Colors.red,
                fontColor: Colors.white,
                fontSize: 12.sp,
                onTap: controller.cancelVerification,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
