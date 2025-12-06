import 'package:meyoi/app/data/models/stroke_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image_picker/image_picker.dart';

class CobaController extends GetxController {
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  /**
   * Face Mesh
   */

  final Rx<List<FaceMesh>> face_mesh = Rx<List<FaceMesh>>([]);
  final Rx<Size?> img_size_ori = Rx<Size?>(null);

  final FaceMeshDetector _faceMeshDetector = FaceMeshDetector(
    option: FaceMeshDetectorOptions.faceMesh,
  );

  final Rx<Color> blushColor = Rx<Color>(Colors.pink.withOpacity(0.35));
  final RxBool isErasing = false.obs;

  final RxBool isPainting = false.obs;
  final RxDouble brushSize = 15.0.obs;
  final RxList<BrushStroke> painted_points = <BrushStroke>[].obs;

  final RxBool isLipColored = false.obs;
  final Rx<Color> lipColor = Rx<Color>(Colors.red.withOpacity(0.35));

  final RxBool isIrisColored = false.obs; 
  final Rx<Color> irisColor = Rx<Color>(Colors.brown.withOpacity(0.35));


  void IrisColorMode(){
    isIrisColored.value = !isIrisColored.value;
    if(isIrisColored.value){
      isPainting.value = false;
      isErasing.value = false;
      isLipColored.value = false;
    }
  }

  void LipColorMode(){
    isLipColored.value = !isLipColored.value;
    if(isLipColored.value){
      isPainting.value = false;
      isErasing.value = false;
    }
  }

  void changeActiveColor(Color color){
    if(isLipColored.value){
      lipColor.value = color.withOpacity(0.6);
    }
    else if (isIrisColored.value){
      irisColor.value = color.withOpacity(0.8);
    }
    else{
      blushColor.value = color.withOpacity(0.35);
    }
  }

  void changeBlushSize(double size) {
    brushSize.value = size;
  }

  void erasedMode() {
    isErasing.value = !isErasing.value;
    if (isErasing.value) isPainting.value = false;
  }

  void paintMode() {
    isPainting.value = !isPainting.value;
    if (isPainting.value) isErasing.value = false;
  }

  // void erasePointedPoints(Offset pos) {
  //   painted_points.removeWhere((point) {
  //     final distance = (point.position - pos).distance;
  //     return distance <= brushSize.value / 2;
  //   });
  // }

  void changeBlushColor(Color color) {
    blushColor.value = color.withOpacity(0.35);
  }

  void startStroke(Offset pos) {
    if (!isPainting.value && !isErasing.value) return;

    final stroke = BrushStroke(
      points: [pos],
      color: isErasing.value ? Colors.transparent : blushColor.value,
      strokeWidth: brushSize.value,
      isEraser: isErasing.value,
    );
    painted_points.add(stroke);
  }

  void updateStroke(Offset pos) {
    if (painted_points.isEmpty) return;

    final lastStroke = List<Offset>.from(painted_points.last.points..add(pos));
    painted_points[painted_points.length - 1] = BrushStroke(
      points: lastStroke,
      color: painted_points.last.color,
      strokeWidth: painted_points.last.strokeWidth,
      isEraser: painted_points.last.isEraser,
    );
  }

  Future<void> processImg(XFile img) async {
    face_mesh.value = [];
    img_size_ori.value = null;
    painted_points.clear();
    isErasing.value = false;
    isPainting.value = false;
    isIrisColored.value = false;
    // isLipColored.value = false;

    try {
      final inputImage = InputImage.fromFilePath(img.path);
      final decodedImage = await decodeImageFromList(await img.readAsBytes());
      img_size_ori.value = Size(
        decodedImage.width.toDouble(),
        decodedImage.height.toDouble(),
      );

      final List<FaceMesh> meshes = await _faceMeshDetector.processImage(
        inputImage,
      );
      face_mesh.value = meshes;
    } catch (e) {
      Get.snackbar("Oops!, Error", "Failed to detect face : $e");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImage.value = image;
        await processImg(image);
      } else {
        Get.snackbar(
          "Cancelled",
          "Sorry, you didn't select any image",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      print("Error picking image: $e");
    }
  }

  void clearImage() {
    selectedImage.value = null;
    isIrisColored.value = false;
    processImg(XFile(""));
    // face_mesh.value = [];
    // img_size_ori.value = null;
    // erased_points.clear();
    // isErasing.value = false;
  }

  @override
  void onClose() {
    _faceMeshDetector.close();
    super.onClose();
  }
}
