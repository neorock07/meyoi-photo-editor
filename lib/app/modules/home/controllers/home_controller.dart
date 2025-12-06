import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:meyoi/app/data/models/metadata_photo_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  // banner tutorial
  RxInt currentTutorIndex = 0.obs;
  final PageController pageTutorController = PageController();

  // State untuk daftar file
  final RxList<FileSystemEntity> imageFiles = <FileSystemEntity>[].obs;
  final RxBool isLoadingImages = false.obs;

  var metadataPhoto = <MetadataPhotoModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadImages();
    // loadImagesWithMetadata(); // Muat gambar saat inisialisasi
  }

  Future<void> loadImages() async {
    try {
      isLoadingImages.value = true;
      imageFiles.clear();

      // 1. Cek Izin Storage (Penting untuk Android 10 ke bawah atau akses umum)
      if (await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted ||
          await Permission.photos.request().isGranted) {
        // 2. Targetkan folder Pictures sesuai screenshot Anda
        // Path standar Android untuk Pictures publik
        final Directory picturesDir = Directory('/storage/emulated/0/Pictures');

        // Cek apakah folder ada
        if (await picturesDir.exists()) {
          // 3. Ambil List & Filter
          List<FileSystemEntity> files = picturesDir.listSync();

          // Filter file:
          // - Harus file (bukan folder)
          // - Ekstensi .jpg atau .png
          // - Nama file diawali dengan 'meyoi_'
          final filteredFiles = files.where((file) {
            if (file is File) {
              String fileName = file.path.split('/').last;
              bool isImage =
                  fileName.toLowerCase().endsWith('.jpg') ||
                  fileName.toLowerCase().endsWith('.png');
              bool isMeyoi = fileName.startsWith('meyoi_');

              return isImage && isMeyoi;
            }
            return false;
          }).toList();

          // 4. Urutkan dari yang terbaru (berdasarkan waktu modifikasi)
          filteredFiles.sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
          );

          imageFiles.assignAll(filteredFiles);
          log("Loaded ${imageFiles.length} meyoi images.");
        } else {
          log("Folder Pictures Not Found: ${picturesDir.path}");
        }
      } else {
        Get.snackbar(
          "Permission denied",
          "Give storage permission to load images.",
        );
      }
    } catch (e) {
      log("Error loading images: $e");
    } finally {
      isLoadingImages.value = false;
    }
  }

  Future<void> loadImagesWithMetadata() async {
    try {
      isLoadingImages.value = true;
      metadataPhoto.clear();

      // 1. Cek Permission
      if (await Permission.storage.request().isGranted ||
          await Permission.manageExternalStorage.request().isGranted ||
          await Permission.photos.request().isGranted) {
        
        // 2. Sesuaikan path folder penyimpanan Anda
        // Di saveImageWithMetadata Anda pakai ImageGallerySaverPlus, 
        // biasanya masuk ke /Pictures/ atau root gallery. 
        // Pastikan path ini sesuai dengan tempat file tersimpan.
        final Directory picturesDir = Directory('/storage/emulated/0/Pictures'); 

        if (await picturesDir.exists()) {
          List<FileSystemEntity> files = picturesDir.listSync();

          // 3. Filter File Meyoi
          final filteredFiles = files.where((file) {
            if (file is File) {
              String fileName = file.path.split('/').last;
              bool isImage = fileName.toLowerCase().endsWith('.png'); // Metadata text biasanya di PNG
              bool isMeyoi = fileName.startsWith('meyoi_'); // Sesuai prefix save Anda
              return isImage && isMeyoi;
            }
            return false;
          }).toList();

          // 4. Sortir Terbaru
          filteredFiles.sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
          );

          // 5. Map ke Model (Awalnya "Loading...")
          List<MetadataPhotoModel> tempItems = filteredFiles.map((file) {
            return MetadataPhotoModel(
              file: file as File,
              fileName: file.path.split('/').last,
              modifiedDate: file.statSync().modified,
              editedArea: "Loading...", // Placeholder
            );
          }).toList();

          metadataPhoto.assignAll(tempItems);
          
          // 6. Jalankan Baca Metadata di Background
          _fetchMetadataLazy();
        } 
      } else {
        Get.snackbar("Permission denied", "Storage permission required.");
      }
    } catch (e) {
      print("Error loading images: $e");
    } finally {
      isLoadingImages.value = false;
    }
  }

  // Fungsi helper untuk format tanggal
  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy   HH.mm').format(date);
  }

  // Fungsi hapus file
  Future<void> deleteImage(FileSystemEntity file) async {
    try {
      // Tampilkan dialog konfirmasi (Opsional, tapi disarankan)
      Get.defaultDialog(
        title: "Remove this photo?",
        middleText: "Photo will be permanently deleted from your device!.",
        textConfirm: "Remove",
        textCancel: "Cancel",
        titleStyle: TextStyle(
          fontFamily: "Poppins", 
          fontSize: 16.sp, 
          fontWeight: FontWeight.bold
        ),
        middleTextStyle: TextStyle(
          fontFamily: "Poppins", 
          fontSize: 14.sp, 
          fontWeight: FontWeight.normal
        ),
        confirmTextColor: Get.theme.colorScheme.onError,
        onConfirm: () async {
          Get.back(); // Tutup dialog

          // Proses Hapus
          final File targetFile = File(file.path);
          if (await targetFile.exists()) {
            await targetFile.delete(); 
            imageFiles.remove(file);
            loadImages();

            
            Get.snackbar(
              "Deleted",
              "File deleted successfully",
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to delete file: $e");
    }
  }

  // Fungsi untuk update metadata satu per satu
  void _fetchMetadataLazy() async {
    for (int i = 0; i < metadataPhoto.length; i++) {
      if (metadataPhoto[i].editedArea == "Loading...") {
        
        // Panggil fungsi top-level via compute
        String metadata = await compute(readMetadataInBackground, metadataPhoto[i].file.path);
        
        // Update item
        metadataPhoto[i].editedArea = metadata;
        metadataPhoto.refresh(); 
      }
    }
  }

  // Fungsi ini berjalan di thread terpisah agar UI tidak macet
  Future<String> readMetadataInBackground(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return "Not Makeup";

      final bytes = await file.readAsBytes();

      // Decode gambar untuk membaca text chunk (metadata)
      // img.decodePng akan membaca metadata tEXt dari file PNG
      final image = img.decodePng(bytes);

      if (image != null && image.textData != null) {
        // 1. BACA SESUAI KEY YANG ANDA SIMPAN
        String? data = image.textData?['edited_area'];

        if (data != null && data.isNotEmpty) {
          // 2. Format ulang string agar lebih rapi di UI
          // Data tersimpan: "Lipstick,Cheek"
          // Data ditampilkan: "Lipstick, Cheek"
          return data.replaceAll(',', ', ');
        }
      }
      return "Not Makeup"; // Jika key tidak ditemukan
    } catch (e) {
      return "Not Makeup"; // Jika file corrupt/error
    }
  }
}
