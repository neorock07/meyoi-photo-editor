import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meyoi/app/modules/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:meyoi/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/dialog_edit_username_widget.dart';
import 'package:meyoi/core/widgets/dialog_logout_widget.dart';
import 'package:meyoi/core/widgets/profile_button_widget.dart';
import 'package:meyoi/routes/app_pages.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  BottomNavController get bottomNavController =>
      Get.find<BottomNavController>();

  @override
  Widget build(BuildContext context) {
    // final _ = controller;

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
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
                  padding: EdgeInsets.only(top: 20.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50.r,
                        backgroundImage: AssetImage("assets/images/avatar2.png"),
                      ),
                      SizedBox(height: 10.h),
                      Obx(
                        () => Text(
                          bottomNavController.nameUser.value,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Obx(
                        () => Text(
                          bottomNavController.emailUser.value,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: ListView(
                  children: [
                    // Item 1: User Profile
                    ItemProfile(
                      icon: Icons.person_outline,
                      text: "User Profile",
                      onTap: () async {
                        // Get.toNamed('/profile-detail');
                        DialogUpdateUsername(context);
                      },
                    ),
          
                    // Item 2: History
                    ItemProfile(
                      icon: Icons.history,
                      text: "History",
                      onTap: () {
                        // Navigasi ke History
                        Get.toNamed(Routes.HISTORY);
                      },
                    ),
          
                    // Item 3: Terms of Service
                    ItemProfile(
                      icon: Icons.description_outlined,
                      text: "Terms of Service",
                      onTap: () {
                        Get.toNamed(Routes.TERMS);
                      },
                    ),
          
                    // Item 4: FAQ
                    ItemProfile(
                      icon: Icons.help_outline, // Atau Icons.chat_bubble_outline
                      text: "Faq",
                      onTap: () {
                        Get.toNamed(Routes.FAQ);
                      },
                    ),
          
                    // Item 5: Logout
                    ItemProfile(
                      icon: Icons.logout, // Atau Icons.exit_to_app
                      text: "Logout",
                      onTap: () {
                        DialogLogout(
                          context,
                          MediaQuery.of(context).size.height * 0.4,
                          300.w,
                        );
                      },
                      isLastItem:
                          true, // Opsional: untuk menghilangkan divider di item terakhir
                    ),
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
