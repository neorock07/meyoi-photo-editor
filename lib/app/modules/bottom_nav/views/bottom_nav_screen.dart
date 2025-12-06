import 'package:meyoi/app/modules/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/dialog_home.dart';
import 'package:meyoi/core/widgets/dialog_image_pick.dart';
import 'package:meyoi/core/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.pages,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DialogImagePick(
            context,
            MediaQuery.of(context).size.height * 0.2,
            100.w,
          );
        },
        elevation: 0,
        backgroundColor: AppColors.VioletDark2,
        shape: CircleBorder(
          side: BorderSide(color: Colors.white, width: 6.dm),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, -8), // Bayangan ke atas
                blurRadius: 30,
                spreadRadius: 0.8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomAppBar(
              color: Colors
                  .transparent, // Agar tidak override warna dari Container
              elevation: 0, // Nonaktifkan bayangan default
              height: 80.h,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.dm,
              child: BottomNavigationBar(
                iconSize: 18.dm,
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: controller.selectedIndex.value,
                onTap: controller.changeIndex,
                selectedItemColor: AppColors.VioletDark2,
                unselectedItemColor: Colors.grey,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    label: 'Account',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
