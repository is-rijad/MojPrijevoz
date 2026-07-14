import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/widgets/snackbars.dart';
import 'package:path/path.dart' as path;

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
        final String extension = path.extension(picked.name).toLowerCase();
        final List<String> allowedFormats = ['.jpg', '.jpeg', '.png'];

        if (!allowedFormats.contains(extension)) {
          Constants.messengerKey.currentState?.showSnackBar(
            ErrorSnackBar(
              message: "Nepodržan format. Podržani formati su JPG, JPEG, PNG",
            ),
          );
          return null;
        }

        const int maxSizeBytes = 5 * 1024 * 1024;
        int fileSizeBytes = 0;

        final File file = File(picked.path);
        fileSizeBytes = await file.length();

        if (fileSizeBytes > maxSizeBytes) {
          double sizeInMB = fileSizeBytes / (1024 * 1024);
          Constants.messengerKey.currentState?.showSnackBar(
            ErrorSnackBar(
              message:
                  "Datoteka je prevelika (${sizeInMB.toStringAsFixed(2)} MB)",
            ),
          );
          return null;
        }
        return {
          "picture": await MultipartFile.fromFile(
            picked.path,
            contentType: DioMediaType('image', extension.split(".")[1]),
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
    return null;
  }
}
