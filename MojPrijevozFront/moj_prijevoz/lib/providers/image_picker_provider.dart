import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider {
  Future<Map<String, dynamic>?> pickImage() async {
    try {
      final picker = ImagePicker();

      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (picked != null) {
        return {
          "picture": await MultipartFile.fromFile(
            picked.path,
            contentType: DioMediaType('image', 'jpeg'),
          ),
          "file": File(picked.path),
        };
      }
      return null;
    } on PlatformException catch (e) {
      if (e.code != "already_active") {
        rethrow;
      }
    }
  }
}
