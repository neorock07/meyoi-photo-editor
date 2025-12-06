import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageDetailController extends GetxController {
  
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

}