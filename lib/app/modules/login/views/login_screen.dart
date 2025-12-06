import 'package:meyoi/app/modules/login/controllers/login_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/button_gradient_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meyoi/routes/app_pages.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
          child: Stack(
            children: [
              DraggableScrollableSheet(
                minChildSize: 0.65,
                initialChildSize: 0.75,
                builder: (_, scrollController) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.dm),
                        topRight: Radius.circular(15.dm),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),
                          Container(
                            width: 50.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            "Login Account",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.VioletDark,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Sign in now to try makeup filters and discover your perfect look!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Form(
                              key: controller.formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: controller.emailController,
                                    validator: controller.validateEmail,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.dm,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Obx(
                                    () => TextFormField(
                                      controller: controller.passwordController,
                                      validator: controller.validatePassword,
                                      obscureText:
                                          controller.isPasswordHidden.value,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.dm,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            controller.isPasswordHidden.value
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: controller
                                              .togglePasswordVisibility,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 5.h),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        // Handle forgot password action
                                        Get.toNamed(Routes.FORGOT);  
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.VioletDark,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 20.h),
                                  // Obx(
                                  //   () =>
                                  // ),
                                  Obx(
                                    () => controller.isLoading.value
                                        ? const CircularProgressIndicator()
                                        : Column(
                                          children: [
                                            ButtonGradientWidget(
                                                height: 50.h,
                                                width: 0.9,
                                                text: "Sign In",
                                                onTap: () {
                                                  (controller
                                                              .emailController
                                                              .text
                                                              .isNotEmpty &&
                                                          controller
                                                              .passwordController
                                                              .text
                                                              .isNotEmpty)
                                                      ? controller.processLogin()
                                                      : print("NO");
                                                },
                                                fontColor: Colors.white,
                                                backgroundColor: [
                                                  (controller
                                                              .emailController
                                                              .text
                                                              .isNotEmpty &&
                                                          controller
                                                              .passwordController
                                                              .text
                                                              .isNotEmpty)
                                                      ? AppColors.PinkDark2
                                                      : Colors.grey,
                                                  (controller
                                                              .emailController
                                                              .text
                                                              .isNotEmpty &&
                                                          controller
                                                              .passwordController
                                                              .text
                                                              .isNotEmpty)
                                                      ? AppColors.VioletDark2
                                                      : Colors.black87,
                                                ],
                                              ),

                                              SizedBox(height: 10.h,),
                                              TextButton(
                                                onPressed: (){
                                                  Get.toNamed(Routes.REGISTER);
                                                },
                                                child: Text("Don't have account ?", style: TextStyle(
                                                  fontFamily: "Poppins", 
                                                  fontSize: 14.sp, 
                                                  color: AppColors.PinkDark2 
                                                ),))
                                          ],
                                        ),
                                  ),
                                  SizedBox(height: 20.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
