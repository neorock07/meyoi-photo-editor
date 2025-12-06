import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meyoi/app/data/datasources/remote/auth_firebase.dart';
import 'package:meyoi/core/utils/preference_controller.dart';
import 'package:meyoi/routes/app_pages.dart';

class VerificationController extends GetxController {
  final AuthFirebase _authFirebase = AuthFirebase();

  Timer? _timer;
  PreferenceController pref_controller = Get.put(PreferenceController());

  @override
  void onInit() {
    super.onInit();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
  }

  Future<void> checkEmailVerified() async {
    await _authFirebase.reloadUser();

    if (_authFirebase.isEmailVerified()) {
      _timer?.cancel();
      pref_controller.writeBoolData("isLogin", true);
      Get.offAllNamed(Routes.BOTTOM_NAV);
      Get.snackbar(
        "Email Verified",
        "Email has been successfully verified.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resendEmail() async {
    try {
      await _authFirebase.sendEmailVerification();
      Get.snackbar("Email Sent", "Verification email has been resent.");
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> cancelVerification() async {
    _timer?.cancel();
    await _authFirebase.signOut(); // Logout jika user menyerah/ingin ganti akun
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
