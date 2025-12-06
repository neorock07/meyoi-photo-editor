
import 'package:meyoi/app/modules/bottom_nav/bindings/bottom_nav_binding.dart';
import 'package:meyoi/app/modules/bottom_nav/views/bottom_nav_screen.dart';
import 'package:meyoi/app/modules/coba/binding/coba_binding.dart';
import 'package:meyoi/app/modules/coba/views/coba_screen.dart';
import 'package:meyoi/app/modules/edit/bindings/edit_binding.dart';
import 'package:meyoi/app/modules/edit/views/edit_screen.dart';
import 'package:meyoi/app/modules/faq/bindings/faq_binding.dart';
import 'package:meyoi/app/modules/faq/views/faq_screen.dart';
import 'package:meyoi/app/modules/forgot/bindings/forgot_binding.dart';
import 'package:meyoi/app/modules/forgot/views/forgot_screen.dart';
import 'package:meyoi/app/modules/history/views/history_screen.dart';
import 'package:meyoi/app/modules/home/bindings/home_binding.dart';
import 'package:meyoi/app/modules/image_detail/bindings/image_detail_binding.dart';
import 'package:meyoi/app/modules/image_detail/views/image_detail_screen.dart';
import 'package:meyoi/app/modules/loading_image/bindings/loading_image_binding.dart';
import 'package:meyoi/app/modules/loading_image/views/loading_image_screen.dart';
import 'package:meyoi/app/modules/login/bindings/login_binding.dart';
import 'package:meyoi/app/modules/login/views/login_screen.dart';
import 'package:meyoi/app/modules/register/bindings/register_binding.dart';
import 'package:meyoi/app/modules/register/views/register_screen.dart';
import 'package:meyoi/app/modules/splash/bindings/splash_binding.dart';
import 'package:meyoi/app/modules/splash/views/splash_screen.dart';
import 'package:meyoi/app/modules/terms/terms_bindings/terms_binding.dart';
import 'package:meyoi/app/modules/terms/terms_views/terms_screen.dart';
import 'package:meyoi/app/modules/welcome/bindings/welcome_binding.dart';
import 'package:meyoi/app/modules/welcome/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAV,
      page: () => const BottomNavScreen(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_DETAIL,
      page: () => ImageDetailScreen(),
      binding: ImageDetailBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => HistoryScreen(),
      binding: HomeBinding(),
      transition: Transition.downToUp,
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => FaqScreen(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeScreen(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
      transition: Transition.downToUp,
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.downToUp,
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.EDIT,
      page: () => EditScreen(),
      binding: EditBinding(),
      transition: Transition.rightToLeftWithFade,
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.LOADING,
      page: () => LoadingImageScreen(),
      binding: LoadingImageBinding(),
      transition: Transition.upToDown,
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.TERMS,
      page: () => const TermsScreen(),
      binding: TermsBinding(),
      transition: Transition.downToUp,
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: _Paths.FORGOT,
      page: () => const ForgotPasswordView(),
      binding: ForgotBinding(),
      transition: Transition.downToUp,
      curve: Curves.easeInOut,
    ),
    // GetPage(
    //   name: _Paths.COBA,
    //   page: () => const CobaScreen(),
    //   binding: CobaBinding(),
    // ),
  ];
}