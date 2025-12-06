// Fungsi untuk memunculkan Dialog
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:meyoi/app/modules/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:meyoi/app/modules/register/controllers/register_controller.dart';

BottomNavController bottomNavController = Get.find<BottomNavController>();
RegisterController registerController = Get.put(RegisterController());

Future<void> DialogUpdateUsername(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Update Username"),
        content: Column(
          mainAxisSize:
              MainAxisSize.min, // Agar tinggi dialog menyesuaikan konten
          children: [
            Text(
              "Your new username:",
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),

            SizedBox(height: 10.h),

            TextFormField(
              controller: registerController.usernameController,
              decoration: InputDecoration(
                hintText: bottomNavController.nameUser.value,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          TextButton(
            onPressed: () async {


              log("Input user: ${registerController.usernameController.text}");
              await bottomNavController.updateNewUsername(
                registerController.usernameController.text,
              );

              Get.back();
              Get.snackbar(
                "Success!",
                "Username has been updated successfully!!",
                colorText: Colors.white,
                backgroundColor: Colors.green,
              );
              registerController.usernameController.clear();
            },
            child: const Text(
              "Save",
              style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
