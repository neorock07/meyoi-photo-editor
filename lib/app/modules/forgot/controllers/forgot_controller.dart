import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meyoi/app/data/datasources/remote/auth_firebase.dart';

class ForgotPasswordController extends GetxController {
  final AuthFirebase _authDataSource = AuthFirebase();
  
  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> sendResetEmail() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please filled your email.");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Email not valid!");
      return;
    }

    try {
      isLoading.value = true;

      // 2. Panggil Firebase
      await _authDataSource.sendPasswordResetEmail(email);

      isLoading.value = false;
      
      // 3. Sukses & Kembali ke Login
      Get.back(); // Tutup halaman forgot password
      
      Get.snackbar(
        "Email Sent..", 
        "Please, check inbox/spam to reset your password!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error", 
        e.toString().replaceAll("Exception: ", ""), // Bersihkan pesan error
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}