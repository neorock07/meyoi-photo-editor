import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:meyoi/app/data/models/editor_model.dart';
import 'package:image/image.dart' as img_lib;
import 'package:meyoi/app/data/models/stroke_model.dart';
import 'package:meyoi/core/theme/colors.dart';
import 'package:meyoi/core/widgets/dialog_home.dart';
import 'package:meyoi/core/widgets/dialog_widget.dart';
import 'package:meyoi/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class EditController extends GetxController {
  // button option condition name
  Rx<String?> selectedTool = Rx<String?>("Default");

  // pallete color condition
  RxBool isPalleteVisible = false.obs;

  // tools button condition
  RxBool isToolsPanelVisible = false.obs;

  // open bottom sheet eyebrow style
  RxBool openStyleEyebrowSheet = false.obs;

  // open bottom sheet eyelash style
  RxBool openStyleEyelashSheet = false.obs;

  // open bottom sheet lipstick style
  RxBool openStyleLipstickSheet = false.obs;

  // button option bar condition
  RxBool isButtonTaped = false.obs;

  // button option styling
  RxBool isStyleTaped = false.obs;

  RxBool isImageProcessed = false.obs;

  // for selecting style option
  Rx<String?> selectedStyle = Rx<String?>(null);

  // for color picker init
  Rx<Color> pickerColor = Rx<Color>(Colors.red);
  Rx<Color> currentColor = Rx<Color>(Colors.red);

  // for image picker
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();
  RxBool isErrorPicking = false.obs;

  // --- KEY UNTUK MENYIMPAN GAMBAR ---
  late GlobalKey repaintBoundaryKey;

  // value to controll brightness pic.
  RxDouble brightness = 0.0.obs;
  RxDouble contrast = 0.0.obs;
  RxBool openSheetBrightness = false.obs;
  RxBool openSheetContrast = false.obs;

  // for polygon face mesh
  final FaceMeshDetector _faceMeshDetector = FaceMeshDetector(
    option: FaceMeshDetectorOptions.faceMesh,
  );

  final Rx<List<FaceMesh>> face_mesh = Rx<List<FaceMesh>>([]);

  // size image originally
  final Rx<Size?> image_size_origin = Rx<Size?>(null);

  // for face painter style
  final Rx<Color> blushColor = Rx<Color>(Colors.brown.withOpacity(0.35));
  final RxBool isErasing = false.obs;

  // image aspect ratio
  var imageAspectRatio = 1.0.obs;

  final RxBool isPainting = false.obs;
  final RxDouble brushSize = 15.0.obs;
  final RxList<BrushStroke> painted_points = <BrushStroke>[].obs;

  final RxBool isFaceColored = false.obs;
  final Rx<Color> faceColor = Rx<Color>(Colors.brown.withOpacity(0.35));

  final RxBool isCheekColored = false.obs;
  final Rx<Color> cheekColor = Rx<Color>(
    const ui.Color.fromARGB(255, 202, 131, 174).withOpacity(0.35),
  );

  final RxBool isLipColored = false.obs;
  final Rx<Color> lipColor = Rx<Color>(Colors.green.withOpacity(0.75));

  final RxBool isIrisColored = false.obs;
  final Rx<Color> irisColor = Rx<Color>(Colors.brown.withOpacity(0.35));

  final Rx<ui.Image?> upperLipTexture = Rx<ui.Image?>(null);
  final Rx<ui.Image?> lowerLipTexture = Rx<ui.Image?>(null);

  final RxBool isEyebrowColored = false.obs;
  final Rx<Color> eyebrowColor = Rx<Color>(Colors.black.withOpacity(0.6));
  final Rx<String> eyebrowStyle = "Default".obs;
  final Rx<Color> eyelashColor = Rx<Color>(Colors.black.withOpacity(0.8));

  final Rx<String> eyelashStyle = "Default".obs;
  final RxBool isEyelashColored = false.obs;
  final Rx<ui.Image?> leftEyelashTexture = Rx<ui.Image?>(null);
  final Rx<ui.Image?> rightEyelashTexture = Rx<ui.Image?>(null);

  // undo-redo
  final RxList<EditorState> _history = <EditorState>[].obs;
  final RxList<EditorState> _redoStack = <EditorState>[].obs;

  bool get canUndo => _history.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  RxMap<String, dynamic> opacity = <String, dynamic>{
    "Default": 0.3.obs,
    "Skin": 0.3.obs,
    "Cheek": 0.3.obs,
    "Lipstick": 0.3.obs,
    "Eyecolor": 0.3.obs,
    "Eyebrow": 0.6.obs,
    "Eyelash": 0.6.obs,
  }.obs;

  // menu opsi nav bar
  List<Map<String, dynamic>> editMenuList = [
    {"icon": "assets/images/eye_icon.svg", "title": "Tools"},
    {"icon": "assets/images/eye_icon.svg", "title": "Eyecolor"},
    {"icon": "assets/images/face_icon.svg", "title": "Skin"},
    {"icon": "assets/images/lip_icon.svg", "title": "Lipstick"},
    {"icon": "assets/images/pipi_icon.svg", "title": "Cheek"},
    {"icon": "assets/images/eyelash_icon.svg", "title": "Eyelash"},
    {"icon": "assets/images/alis_icon.svg", "title": "Eyebrow"},
  ];

  // menu sheet opsi pallete color
  final RxList<Map<String, dynamic>> paletteColors = [
    {"color": Colors.black, "name": "Default"},
    {"color": Colors.pink, "name": "Pink"},
    {"color": Colors.black, "name": "Black"},
    {"color": Colors.blue, "name": "Blue"},
    {"color": Colors.purple, "name": "Purple"},
    {"color": Colors.transparent, "name": "Transparent"},
  ].obs;

  final RxList<Map<String, dynamic>> paletteColorsSkin = [
    {"color": Colors.black, "name": "Default"},
    {
      "color": const ui.Color.fromARGB(255, 212, 170, 154).withOpacity(0.35),
      "name": "Cream",
    },
    {
      "color": const ui.Color.fromARGB(255, 165, 110, 90).withOpacity(0.35),
      "name": "Ivory",
    },
    {"color": const ui.Color.fromARGB(206, 180, 121, 84), "name": "Golden"},
    {"color": const ui.Color.fromARGB(201, 120, 80, 67), "name": "Espresso"},
    {"color": Colors.transparent, "name": "Transparent"},
  ].obs;

  // final RxList<Map<String, dynamic>> pallete_option = [
  //   {"name" : "Skin", "pallete" : paletteColorsSkin}
  // ].obs;

  // opsi style eyebrow
  List<Map<String, dynamic>> listEyebrow = [
    {"icon": "assets/images/default_icon.svg", "title": "Default"},
    {"icon": "assets/images/eyelash_style_1.png", "title": "Classic"},
    {
      "icon": "assets/images/eyebrow/eyebrow_straight_icon.png",
      "title": "Straight",
    },
    {
      "icon": "assets/images/eyebrow/eyebrow_rounded_icon.png",
      "title": "Rounded",
    },
    {
      "icon": "assets/images/eyebrow/eyebrow_hard_icon.png",
      "title": "Hard-Angeled",
    },
    {"icon": "assets/images/eyebrow/eyebrow_s_icon.png", "title": "S-Shape"},
  ];

  // opsi style lipstick
  List<Map<String, dynamic>> listLipstick = [
    {"icon": "assets/images/default_icon.svg", "title": "Default"},
    {
      "icon": "assets/images/lipstick/lipstick_cupid_icon.png",
      "title": "Cupid",
    },
    {
      "icon": "assets/images/lipstick/lipstick_classic_icon.png",
      "title": "Classic",
    },
    {
      "icon": "assets/images/lipstick/lipstick_hollywood_icon.png",
      "title": "Hollywood",
    },
    {
      "icon": "assets/images/lipstick/lipstick_pearlique_icon.png",
      "title": "Pearlique",
    },
    {
      "icon": "assets/images/lipstick/lipstick_goddess_icon.png",
      "title": "Goddess",
    },
  ];

  // opsi style eyelash
  List<Map<String, dynamic>> listEyelash = [
    {"icon": "assets/images/default_icon.svg", "title": "Default"},
    {
      "icon": "assets/images/eyelash/eyelash_lifted_icon.png",
      "title": "Lifted",
    },
    {
      "icon": "assets/images/eyelash/eyelash_natural_icon.png",
      "title": "Natural",
    },
    {
      "icon": "assets/images/eyelash/eyelash_stag_icon.png",
      "title": "Staggered",
    },
    {"icon": "assets/images/eyelash/eyelash_doll_icon.png", "title": "Doll"},
    {"icon": "assets/images/eyelash/eyelash_cat_icon.png", "title": "Cat"},
  ];

  @override
  void onInit() {
    super.onInit();
    repaintBoundaryKey = GlobalKey();
    update();
  }

  // --- FUNGSI SIMPAN GAMBAR ---
  Future<void> saveImage() async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            Get.snackbar(
              "Permission Refused",
              "Permission is needed for saving images.",
            );
            return;
          }
        }
      }

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: AppColors.PinkBright),
        ),
        barrierDismissible: false,
      );

      RenderRepaintBoundary? boundary =
          repaintBoundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        Get.back();
        Get.snackbar("Error", "Failed to capture image.");
        return;
      }

      // Resolusi tinggi (3.0x)
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 4. Simpan ke Galeri
      final String fileName =
          'meyoi_image_${DateTime.now().millisecondsSinceEpoch}';

      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: fileName,
      );

      Get.back();

      if (result != null && (result['isSuccess'] == true || result == true)) {
        Get.snackbar(
          "Success",
          "Image saved to gallery successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        log("Image saved successfully: $result");
      } else {
        throw Exception("failed to save image (Result: $result)");
      }
    } catch (e) {
      Get.back(); // Tutup loading jika error
      log("Error saving image: $e");
      Get.snackbar(
        "Error",
        "Failed to save image: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // function to save image with metadata.
  Future<void> saveImageWithMetadata() async {
    try {
      Set<String> editedArea = {};

      if (isLipColored.value) {
        editedArea.add("Lipstick");
      }

      if (isCheekColored.value) {
        editedArea.add("Cheek");
      }

      if (isFaceColored.value) {
        editedArea.add("Skin");
      }

      if (isEyelashColored.value) {
        editedArea.add("Eyelash");
      }

      if (isEyebrowColored.value) {
        editedArea.add("Eyebrow");
      }

      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
          if (!status.isGranted) {
            Get.snackbar(
              "Permission Refused",
              "Storage permission is required.",
            );
            return;
          }
        }
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.pink)),
        barrierDismissible: false,
      );

      RenderRepaintBoundary? boundary =
          repaintBoundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        Get.back();
        return;
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List rawPngBytes = byteData!.buffer.asUint8List();

      img.Image? editableImage = img.decodePng(rawPngBytes);

      if (editableImage != null) {
        editableImage.textData = {
          "Software": "Meyoi App",
          "Author": "User",
          "Description": "Created with Meyoi",
          "edited_area": editedArea.join(","),
          "meyoi_timestamp": DateTime.now().toIso8601String(),
        };

        rawPngBytes = img.encodePng(editableImage);
      }
      final String fileName = 'meyoi_${DateTime.now().millisecondsSinceEpoch}';

      final result = await ImageGallerySaverPlus.saveImage(
        rawPngBytes,
        quality: 100,
        name: fileName,
      );

      Get.back();

      if (result != null && (result['isSuccess'] == true || result == true)) {
        Get.snackbar(
          "",
          "",
          backgroundColor: Colors.white,
          borderRadius: 16.dm,
          margin: EdgeInsets.all(16.dm), // Jarak dari tepi layar
          padding: EdgeInsets.symmetric(horizontal: 20.dm, vertical: 16.dm),
          icon: Container(
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.all(8.dm), // Ukuran lingkaran background
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.PinkBright, AppColors.VioletDark2],
              ),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),

          titleText: const Text(
            "Photo saved",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),

          messageText: const SizedBox(height: 0),

          boxShadows: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          shouldIconPulse: false,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      } else {
        throw Exception("Result indicates failure: $result");
      }
    } catch (e) {
      Get.back();
      print("Error saving image: $e");
      Get.snackbar("Error", "Failed to save: $e");
    }
  }

  /* 
    Function to config Tools
  */

  // set brightness
  void setBrightness(double value) {
    saveState();
    brightness.value = value;
  }

  // set contrast
  void setContrast(double value) {
    contrast.value = value;
  }

  // crop image
  Future<void> cropImage() async {
    saveState();
    if (selectedImage.value == null) {
      Get.snackbar("Error", "Select an image first to crop.");
      return;
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedImage.value!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.PinkDark2,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio16x9,
          ],
        ),
      ],
    );

    if (croppedFile != null) {
      try {
        isLipColored.value = false;
        isFaceColored.value = false;
        isCheekColored.value = false;
        isEyelashColored.value = false;
        isEyebrowColored.value = false;

        final newImage = XFile(croppedFile.path);

        selectedImage.value = newImage;
        isButtonTaped.value = true;

        await processImg(newImage);

        update();
      } catch (e) {
        print("Error after crop: $e");
      }
    }
  }

  // set color picker
  void onColorChanged(Color color) {
    pickerColor.value = color;
  }

  // function to select base tool
  void setSelectedTool(String tool) {
    selectedTool.value = tool;
    if (tool == "Tools") {
      isToolsPanelVisible.value = true;
      hidePallete();
    } else if (tool == "Eyelash") {
      openStyleEyelashSheet.value = true;
    } else if (tool == "Eyebrow") {
      openStyleEyebrowSheet.value = true;
    } else if (tool == "Lipstick") {
      openStyleLipstickSheet.value = true;
    } else {
      isPalleteVisible.value = true;
      hideTools();
    }
  }

  // function to eraser
  void eraseMode() {
    // Ganti nama dari erasedMode agar sesuai permintaan
    isErasing.value = !isErasing.value;

    if (isErasing.value) {
      isPainting.value = false;
    }
  }

  // function to clear all tool
  void unselectedTool() {
    selectedTool.value = "Default";
    isButtonTaped.value = false;
    hidePallete();
    hideTools();
    hideStyleSheet();
  }

  // function for select style tool
  void selectedStyleTool(String tool) {
    selectedStyle.value = tool;
  }

  // function to hide pallete sheet
  void hidePallete() {
    isPalleteVisible.value = false;
  }

  // function to hide tools sheet
  void hideTools() {
    isToolsPanelVisible.value = false;
    openSheetBrightness.value = false;
    openSheetContrast.value = false;
  }

  // function to hide style sheet
  void hideStyleSheet() {
    openStyleEyebrowSheet.value = false;
    openStyleEyelashSheet.value = false;
    openStyleLipstickSheet.value = false;
  }

  // function to config lip mode
  void LipColorMode() {
    saveState();
    // isLipColored.value = !isLipColored.value;
    isLipColored.value = true;

    if (isLipColored.value) {
      isPainting.value = false;
      isErasing.value = false;
    }
    String? style_lip = selectedStyle.value!.toLowerCase();

    (style_lip == "default")
        ? clearLipMode()
        : loadLipTextures(
            'assets/images/lipstick/$style_lip/lipstick_${style_lip}_atas.png',
            'assets/images/lipstick/$style_lip/lipstick_${style_lip}_bawah.png',
          );
  }

  // function to clear lip mode
  void clearLipMode() {
    saveState();
    isLipColored.value = false;
    upperLipTexture.value = null;
    lowerLipTexture.value = null;
  }

  // function to config eyebrow mode
  void EyebrowColorMode(String style) {
    saveState();
    isPainting.value = false;
    isErasing.value = false;

    if (style == "Default") {
      isEyebrowColored.value = false;
      return;
    } else {
      isEyebrowColored.value = true;
      eyebrowStyle.value = style;
      log("Selected Eyebrow Style: $style");
    }
  }

  // function to config eyelash mode
  void EyelashColorMode(String style) {
    saveState();
    isPainting.value = false;
    isErasing.value = false;

    if (style == "Default") {
      isEyelashColored.value = false;
      return;
    } else {
      isEyelashColored.value = true;
      eyelashStyle.value = style;
      String? style_eyelash = selectedStyle.value!.toLowerCase();

      (style_eyelash == "default")
          ? clearEyelashMode()
          : loadEyelashTextures(
              'assets/images/eyelash/$style_eyelash/eyelash_${style_eyelash}_right.png',
              'assets/images/eyelash/$style_eyelash/eyelash_${style_eyelash}_left.png',
            );
      log("Selected Eyebrow Style: $style");
    }
  }

  // function to clear eyelash mode
  void clearEyelashMode() {
    saveState();
    isEyelashColored.value = false;
    leftEyelashTexture.value = null;
    rightEyelashTexture.value = null;
  }

  // function to config face skin mode
  void FaceColorMode() {
    saveState();
    // Toggle status pewarnaan wajah
    isFaceColored.value = true;

    // Nonaktifkan mode lain agar tidak tumpang tindih jika perlu
    if (isFaceColored.value) {
      isPainting.value = false;
      isErasing.value = false;
    }
  }

  // function to config cheek mode
  void CheekColorMode() {
    saveState();
    isCheekColored.value = true;

    if (isCheekColored.value) {
      isPainting.value = false;
      isErasing.value = false;
    }
  }

  // function to config iris mode
  void IrisColorMode() {
    saveState();
    isIrisColored.value = true;

    if (isIrisColored.value) {
      isPainting.value = false;
      isErasing.value = false;
    }
  }

  // function to load lipstick texture
  Future<void> loadLipTextures(String upperPath, String lowerPath) async {
    try {
      final ByteData upperData = await rootBundle.load(upperPath);
      final ui.Codec upperCodec = await ui.instantiateImageCodec(
        upperData.buffer.asUint8List(),
      );
      upperLipTexture.value = (await upperCodec.getNextFrame()).image;

      final ByteData lowerData = await rootBundle.load(lowerPath);
      final ui.Codec lowerCodec = await ui.instantiateImageCodec(
        lowerData.buffer.asUint8List(),
      );
      lowerLipTexture.value = (await lowerCodec.getNextFrame()).image;

      log("Tekstur bibir '$selectedStyle' berhasil dimuat.");
    } catch (e) {
      log("Error memuat tekstur bibir: $e");
      Get.snackbar("Error Aset", "Failed to load lip textures");
    }
  }

  // function to load eyelash texture
  Future<void> loadEyelashTextures(String leftPath, String rightPath) async {
    try {
      final ByteData leftData = await rootBundle.load(leftPath);
      final ui.Codec leftCodec = await ui.instantiateImageCodec(
        leftData.buffer.asUint8List(),
      );
      leftEyelashTexture.value = (await leftCodec.getNextFrame()).image;

      final ByteData rightData = await rootBundle.load(rightPath);
      final ui.Codec rightCodec = await ui.instantiateImageCodec(
        rightData.buffer.asUint8List(),
      );
      rightEyelashTexture.value = (await rightCodec.getNextFrame()).image;
    } catch (e) {
      log("Error loading eyelash texture: $e");
    }
  }

  //  Future<void> loadEyebrowTextures(String leftPath, String rightPath) async {
  //   try {
  //     final ByteData leftData = await rootBundle.load(leftPath);
  //     final ui.Codec leftCodec = await ui.instantiateImageCodec(leftData.buffer.asUint8List());
  //     leftEyebrowTexture.value = (await leftCodec.getNextFrame()).image;

  //     final ByteData rightData = await rootBundle.load(rightPath);
  //     final ui.Codec rightCodec = await ui.instantiateImageCodec(rightData.buffer.asUint8List());
  //     rightEyebrowTexture.value = (await rightCodec.getNextFrame()).image;

  //     log("Tekstur alis berhasil dimuat.");
  //   } catch (e) {
  //     log("Error memuat tekstur alis: $e");
  //     // Get.snackbar("Error", "Gagal memuat aset alis");
  //   }
  // }

  // function to detect face mesh
  Future<void> processImg(XFile img) async {
    try {
      painted_points.clear();
      face_mesh.value = [];
      image_size_origin.value = null;

      final decodedImage = await decodeImageFromList(await img.readAsBytes());

      image_size_origin.value = Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );

      imageAspectRatio.value =
          decodedImage.width.toDouble() / decodedImage.height.toDouble();

      final inputImage = InputImage.fromFilePath(img.path);

      final meshes = await _faceMeshDetector.processImage(inputImage);
      face_mesh.value = meshes;

      if (meshes.isEmpty) {
        Get.snackbar("Oops!", "No face detected!");
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar("Oops!", "Face detection error");
    }
  }

  // function to fix image rotation.
  Future<XFile> fixImageRotation(XFile file) async {
    final bytes = await file.readAsBytes();
    final img = img_lib.decodeImage(bytes); // package:image
    if (img == null) return file;

    // re-encode WITHOUT EXIF
    final fixedBytes = img_lib.encodeJpg(img, quality: 100);

    final newPath = file.path.replaceAll(".jpg", "_fixed.jpg");
    final newFile = File(newPath)..writeAsBytesSync(fixedBytes);

    return XFile(newFile.path);
  }

  // --- FUNGSI UNDO ---
  void undo() {
    if (_history.isEmpty) return;

    // 1. Simpan state saat ini ke Redo Stack sebelum mundur
    final currentState = EditorState(
      paintedPoints: List.from(painted_points),
      isLipColored: isLipColored.value,
      lipColor: lipColor.value,
      isIrisColored: isIrisColored.value,
      irisColor: irisColor.value,
      isFaceColored: isFaceColored.value,
      faceColor: faceColor.value,
      isCheekColored: isCheekColored.value,
      cheekColor: cheekColor.value,
      isEyebrowColored: isEyebrowColored.value,
      eyebrowColor: eyebrowColor.value,
      eyebrowStyle: eyebrowStyle.value,
      isEyelashColored: isEyelashColored.value,
      eyelashStyle: "Default",
    );
    _redoStack.add(currentState);

    // 2. Ambil state terakhir dari History
    final previousState = _history.removeLast();

    // 3. Terapkan state tersebut ke variabel controller
    _applyState(previousState);
  }

  // --- FUNGSI REDO ---
  void redo() {
    if (_redoStack.isEmpty) return;

    // 1. Simpan state saat ini ke History sebelum maju
    final currentState = EditorState(
      paintedPoints: List.from(painted_points),
      isLipColored: isLipColored.value,
      lipColor: lipColor.value,
      isIrisColored: isIrisColored.value,
      irisColor: irisColor.value,
      isFaceColored: isFaceColored.value,
      faceColor: faceColor.value,
      isCheekColored: isCheekColored.value,
      cheekColor: cheekColor.value,
      isEyebrowColored: isEyebrowColored.value,
      eyebrowColor: eyebrowColor.value,
      eyebrowStyle: eyebrowStyle.value,
      isEyelashColored: isEyelashColored.value,
      eyelashStyle: "Default",
    );
    _history.add(currentState);

    // 2. Ambil state dari Redo Stack
    final nextState = _redoStack.removeLast();

    // 3. Terapkan
    _applyState(nextState);
  }

  // fungsi untuk menyimpan state saat edit.
  void saveState() {
    // Bersihkan redo stack karena kita membuat cabang sejarah baru
    _redoStack.clear();

    // Buat snapshot dari kondisi saat ini
    final currentState = EditorState(
      paintedPoints: List.from(painted_points), // Deep copy list
      isLipColored: isLipColored.value,
      lipColor: lipColor.value,
      isIrisColored: isIrisColored.value,
      irisColor: irisColor.value,
      isFaceColored: isFaceColored.value,
      faceColor: faceColor.value,
      isCheekColored: isCheekColored.value,
      cheekColor: cheekColor.value,
      isEyebrowColored: isEyebrowColored.value,
      eyebrowColor: eyebrowColor.value,
      eyebrowStyle: eyebrowStyle.value,
      isEyelashColored: isEyelashColored.value,
      eyelashStyle: "Default", // Sesuaikan jika ada variabel style eyelash
    );

    // Masukkan ke history
    // Batasi history agar memori tidak penuh (misal max 20 langkah)
    if (_history.length >= 20) {
      _history.removeAt(0);
    }
    _history.add(currentState);

    update(); // Update UI jika ada GetBuilder
  }

  // Helper untuk menerapkan state ke variabel Rx
  void _applyState(EditorState state) {
    painted_points.assignAll(state.paintedPoints);
    isLipColored.value = state.isLipColored;
    lipColor.value = state.lipColor;
    isIrisColored.value = state.isIrisColored;
    irisColor.value = state.irisColor;
    isFaceColored.value = state.isFaceColored;
    faceColor.value = state.faceColor;
    isCheekColored.value = state.isCheekColored;
    cheekColor.value = state.cheekColor;
    isEyebrowColored.value = state.isEyebrowColored;
    eyebrowColor.value = state.eyebrowColor;
    eyebrowStyle.value = state.eyebrowStyle;
    isEyelashColored.value = state.isEyelashColored;
    // eyelashStyle.value = state.eyelashStyle;

    update(); // Trigger UI update
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = image;
        await processImg(image).then((dynamic q) {
          isImageProcessed.value = true;
          isErrorPicking.value = false;
          log(">> Image Processed Finish : v");
          log("isError : ${isErrorPicking.value}");
        });
      } else {
        Get.snackbar(
          "Cancelled",
          "Sorry, you didn't select any image",
          snackPosition: SnackPosition.BOTTOM,
        );
        isImageProcessed.value = false;
        isErrorPicking.value = true;
        Navigator.of(context).popAndPushNamed(Routes.BOTTOM_NAV);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      selectedImage.value = null;
      isImageProcessed.value = false;
      Navigator.of(context).popAndPushNamed(Routes.BOTTOM_NAV);
      isErrorPicking.value = true;
      print("Error picking image: $e");
    }
  }

  Future<Uint8List> captureFilteredImage() async {
    RenderRepaintBoundary boundary =
        repaintBoundaryKey.currentContext!.findRenderObject()
            as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // function to replace image after 'Done'
  Future<void> replaceImage(Uint8List bytes) async {
    final file = File('${(await getTemporaryDirectory()).path}/edited.png');
    await file.writeAsBytes(bytes);

    selectedImage.value = XFile(file.path);

    // reset all state
    face_mesh.value = [];
    painted_points.clear();
    // isLipColored.value = false;
    // isFaceColored.value = false;
    // isCheekColored.value = false;
    // isEyelashColored.value = false;
    // isEyebrowColored.value = false;

    // await processImg(selectedImage.value!);
  }


  // function to delete temporary image after 'exit editor'
  Future<void> deleteImageTemp() async {
    // Proses Hapus
    final File targetFile = File(
      '${(await getTemporaryDirectory()).path}/edited.png',
    );
    if (await targetFile.exists()) {
      await targetFile.delete();
    }
  }
}
