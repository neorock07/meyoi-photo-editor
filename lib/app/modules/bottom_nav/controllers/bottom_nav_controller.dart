import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:meyoi/app/data/datasources/remote/auth_firebase.dart';
import 'package:meyoi/app/data/models/metadata_photo_model.dart';
import 'package:meyoi/app/modules/home/views/home_screen.dart';
import 'package:meyoi/app/modules/profile/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:meyoi/core/utils/preference_controller.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';

class BottomNavController extends GetxController {

  var selectedIndex = 0.obs;

  PreferenceController pref = Get.find<PreferenceController>();

  final List<Widget> pages = [
    HomeScreen(),
    const ProfileScreen(),
  ];

  AuthFirebase authFirebase = AuthFirebase();
  RxString emailUser = "".obs;
  RxString nameUser = "".obs;

  var metadataPhoto = <MetadataPhotoModel>[].obs;
  
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // State untuk daftar file
  final RxList<FileSystemEntity> imageFiles = <FileSystemEntity>[].obs;
  final RxBool isLoadingImages = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadImages(); 
  }

  @override
  void onReady() {
    loadImages();
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

  Future<void> updateNewUsername(String newUser) async {
    await authFirebase.updateUsername(newUser);
  }

  Future<void> logOut() async {
    await authFirebase.signOut();
    await pref.logOut("isLogin", false);
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> loadImages() async {
    try {
      isLoadingImages.value = true;
      
      // Mendapatkan direktori penyimpanan
      // Jika Anda menyimpan di folder khusus aplikasi (seperti di EditController sebelumnya)
      // Gunakan path yang sama.
      Directory? directory;
      if (Platform.isAndroid) {
         directory = await getExternalStorageDirectory(); 
      } else {
         directory = await getApplicationDocumentsDirectory();
      }
      
      if (directory != null) {
        // Masuk ke subfolder jika ada
        final myImgDir = Directory('${directory.path}/Meyoi Photo Editor/image');
        
        if (await myImgDir.exists()) {
          List<FileSystemEntity> files = directory.listSync();
      
      // Filter hanya file gambar & urutkan dari terbaru
      var imageFiles = files.whereType<File>().where((file) {
        return file.path.endsWith('.png') || file.path.endsWith('.jpg');
      }).toList();

      imageFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));

      // 2. Map ke Model (Awalnya metadata masih "Loading...")
      List<MetadataPhotoModel> tempItems = imageFiles.map((file) {
        return MetadataPhotoModel(
          file: file,
          fileName: file.path.split('/').last,
          modifiedDate: file.statSync().modified,
          editedArea: "Loading...", 
        );
      }).toList();

      metadataPhoto.assignAll(tempItems);
      isLoadingImages.value = false;

      _fetchMetadataLazy();
        }
      }
    } catch (e) {
      print("Error loading images: $e");
    } finally {
      isLoadingImages.value = false;
    }
  }

  // Fungsi untuk update metadata satu per satu
  void _fetchMetadataLazy() async {
    for (int i = 0; i < metadataPhoto.length; i++) {
      // Jalankan fungsi berat di background thread (Isolate)
      String metadata = await compute(readMetadataInBackground, metadataPhoto[i].file.path);
      
      // Update data di list
      metadataPhoto[i].editedArea = metadata;
      
      // Refresh UI agar teks "Loading..." berubah jadi hasil
      metadataPhoto.refresh(); 
    }
  }

  // Fungsi helper untuk format tanggal
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy   HH.mm').format(date);
  }
  
  // Fungsi hapus file
  Future<void> deleteImage(FileSystemEntity file) async {
      try {
          await file.delete();
          imageFiles.remove(file);
          Get.snackbar("Deleted", "File deleted successfully");
      } catch (e) {
          Get.snackbar("Error", "Failed to delete file: $e");
      }
  }


  // Fungsi ini berjalan di thread terpisah agar UI tidak macet
Future<String> readMetadataInBackground(String filePath) async {
  try {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    
    // Decode hanya untuk baca info (skip decoding pixel penuh biar agak cepat)
    final image = img.decodePng(bytes);

    if (image != null && image.textData != null) {
      String? data = image.textData?['edited_area'];
      // Sesuaikan key dengan saat Anda save: 'edited_area' atau 'meyoi_edited_area'
      
      if (data != null && data.isNotEmpty) {
        return data;
      }
    }
    return "Not Makeup";
  } catch (e) {
    return "Not Makeup";
  }
}

}