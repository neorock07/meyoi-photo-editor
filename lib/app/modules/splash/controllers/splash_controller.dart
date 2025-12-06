import 'package:meyoi/core/utils/preference_controller.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  PreferenceController pref = Get.put(PreferenceController());

  /**
   *  state ketika berada di page splash.
   * 
  */

  @override
  void onReady() {
    super.onReady();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _navToHome();
  }

  /**
   *  state ketika page close
   * 
  */

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.onClose();
  }

  void _navToHome() async {
    bool data = await pref.loadBoolData("isLogin");
    if (data) {
      await Future.delayed(const Duration(seconds: 2));
      Get.offNamed(Routes.BOTTOM_NAV);
    } else {
      await Future.delayed(const Duration(seconds: 2));
      Get.offNamed(Routes.LOGIN);
    }
  }
}
