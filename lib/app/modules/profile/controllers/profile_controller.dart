import 'package:get/get.dart';
import 'package:meyoi/app/data/datasources/remote/auth_firebase.dart';

class ProfileController extends GetxController {
  
  AuthFirebase authFirebase = AuthFirebase();
  RxString emailUser = "".obs;
  RxString nameUser = "".obs;

  @override
  void onInit() {
    getCurrentUserEmail();
    getCurrentUserName();
    super.onInit();
  }


  Future<void> getCurrentUserEmail() async {
    final user = await authFirebase.getCurrentUser();
    emailUser.value =  user?.email ?? 'No Email';
  }

  Future<void> getCurrentUserName() async {
    final user = await authFirebase.getCurrentUser();
    nameUser.value = user?.displayName ?? 'No Name';
  }
}