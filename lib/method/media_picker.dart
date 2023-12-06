import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MediaPicker {
  static Future<Uint8List?> pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        return await file.readAsBytes();
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      final mediaJsonList = <Map<String, dynamic>>[];
      for (var pickedFile in pickedFiles) {
        final id = DateTime.now().microsecondsSinceEpoch.toString();

        final mediaJson = {
          'id': id,
          'mediaFile': File(pickedFile.path).path,
          'thumbnailFile': File(pickedFile.path).path,
          'mediaType': "image"
        };
        mediaJsonList.add(mediaJson);
      }
      return mediaJsonList;
    } else {
      return [];
    }
  }

  takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final id = DateTime.now().microsecondsSinceEpoch.toString();
      final mediaJson = {
        'id': id,
        'mediaFile': File(pickedFile.path).path,
        'thumbnailFile': File(pickedFile.path).path,
        'mediaType': "image"
      };
      return mediaJson;
    } else {
      return null;
    }
  }
}
