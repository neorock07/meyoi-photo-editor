import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meyoi/app/data/datasources/remote/auth_firebase.dart';
import 'package:meyoi/routes/app_pages.dart';

class RegisterController extends GetxController {
  RxBool terms_check = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfPasswordHidden = true.obs;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confPasswordController;

  //firebase auth
  AuthFirebase authFirebase = AuthFirebase();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confPasswordController = TextEditingController();
  }


  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfPasswordVisibility() {
    isConfPasswordHidden.value = !isConfPasswordHidden.value;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required username';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Required valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password required';
    }
    if (value.length < 6) {
      return 'Password min. 6 characters';
    }
    return null;
  }

  String? validateConfPassword(String? value) {
    if (value != passwordController.text) {
      return 'Password does not match';
    }

    return null;
  }

  Future<void> processRegistration() async{
    if (formKey.currentState!.validate()) {
      String username = usernameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String conf_password = confPasswordController.text;

      try {
        isLoading.value = true;
        await authFirebase.signUp(email.trim(), password.trim(), username.trim());
        await authFirebase.sendEmailVerification();
        await authFirebase.signOut();

        isLoading.value = false;
        Get.offAllNamed(Routes.LOGIN);

        Get.snackbar(
        'Account Created', 
        'Please verify your email before logging in.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 7),
      );

      } catch (e) {
        isLoading.value = false;
      Get.snackbar('Registration Failed!', e.toString());
      }

    } else {
      Get.snackbar(
        'Error',
        'Sorry, please check and try again!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
