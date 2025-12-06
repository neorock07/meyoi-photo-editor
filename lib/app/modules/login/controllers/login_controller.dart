import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meyoi/app/data/datasources/remote/auth_firebase.dart';
import 'package:meyoi/core/utils/preference_controller.dart';
import 'package:meyoi/routes/app_pages.dart';

class LoginController extends GetxController {
  RxBool terms_check = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isPasswordHidden = true.obs;

  late TextEditingController emailController;
  late TextEditingController passwordController;

  // firebase auth
  AuthFirebase authFirebase = AuthFirebase();
  RxBool isLoading = false.obs;

  PreferenceController pref = Get.put(PreferenceController());

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    pref.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
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

  Future<void> processLogin() async {
    if (formKey.currentState!.validate()) {
      String email = emailController.text;
      String password = passwordController.text;
      try {
        isLoading.value = true;
        authFirebase
            .signIn(email.trim(), password.trim())
            .then((user) async {
              isLoading.value = false;
              if (user != null) {
                if (user.emailVerified) {
                  pref.writeBoolData("isLogin", true);

                  Get.offAllNamed(Routes.BOTTOM_NAV);
                  Get.snackbar(
                    'Success',
                    'Successfully login!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.defaultDialog(
                    title: "Email Verification Required",
                    middleText:
                        "Your email is not verified. Would you like to resend the verification email?",
                    textConfirm: "Resend",
                    textCancel: "Close",
                    onConfirm: () async {
                      await authFirebase.sendEmailVerification();
                      Get.back();
                      Get.snackbar(
                        "Email Sent",
                        "Verification email has been resent. Please check your inbox.",
                      );
                    },
                    onCancel: () async {
                      await authFirebase.signOut();
                    },
                  );
                  await authFirebase.signOut();
                }
              } else {
                  pref.writeBoolData("isLogin", false);

                Get.snackbar(
                  'Error',
                  'Sorry, please check and try again!',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            })
            .catchError((e) {
              isLoading.value = false;
              Get.snackbar(
                'Error',
                e.toString(),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            });
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
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
