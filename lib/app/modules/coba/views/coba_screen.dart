// import 'dart:io';

// import 'package:meyoi/app/modules/coba/controller/coba_controller.dart';
// import 'package:meyoi/core/utils/face_mesh_painter.dart';
// import 'package:meyoi/c;''ore/widgets/editing_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class CobaScreen extends GetView<CobaController> {
//   const CobaScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Editor - Face Mesh'),
//         backgroundColor: Colors.blueAccent,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Area untuk menampilkan gambar dan hasil edit
//           Expanded(
//             child: Center(
//               child: Obx(() {
//                 if (controller.selectedImage.value == null) {
//                   return const Text("Pilih gambar untuk memulai", style: TextStyle(fontSize: 18));
//                 }
//                 return GestureDetector(
//                   // --- PERUBAHAN BESAR PADA GESTUREDETECTOR ---
//                   onPanStart: (details) {
//                     controller.startStroke(details.localPosition);
//                   },
//                   onPanUpdate: (details) {
//                     controller.updateStroke(details.localPosition);
//                   },
//                   // onPanEnd: tidak perlu aksi khusus, goresan sudah tersimpan
//                   child: 
//                   CustomPaint(
//                     foregroundPainter: FaceMeshPainter(
//                       meshes: controller.face_mesh.value,
//                       originalImageSize: controller.img_size_ori.value ?? Size.zero,
//                       strokes: controller.painted_points.toList(),
//                       applyLipColor: controller.isLipColored.value,
//                       applyIrisColor: controller.isIrisColored.value,
//                        irisColor: controller.irisColor.value, 
//                        blushColor: controller.blushColor.value,
//                       lipstickColor: controller.lipColor.value,
//                        selectedStyle: '', 
//                        applyFaceSkin: null, 
//                        faceSkinColor: null,
//                       //  selectedStyle: '',
//                     ),
//                     child: Image.file(
//                       File(controller.selectedImage.value!.path),
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
          
//           // Area untuk tombol utama
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.photo_library),
//                   label: const Text('Galeri'),
//                   onPressed: () => controller.pickImage(ImageSource.gallery),
//                 ),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.camera_alt),
//                   label: const Text('Kamera'),
//                   onPressed: () => controller.pickImage(ImageSource.camera),
//                 ),
//               ],
//             ),
//           ),

//           // Area untuk kontrol editing (widget baru kita)
//           const EditingWidget(),
//         ],
//       ),
//     );
//   }
// }

