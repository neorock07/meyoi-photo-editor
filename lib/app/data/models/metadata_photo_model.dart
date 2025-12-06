import 'dart:io';

class MetadataPhotoModel {
  final File file;
  final String fileName;
  final DateTime modifiedDate;
  String editedArea;

  MetadataPhotoModel({
    required this.file,
    required this.fileName,
    required this.modifiedDate,
    this.editedArea = "Loading...",
  });
}