import 'package:flutter/material.dart';

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({super.key, required String message})
    : super(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      );
}

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar({super.key, required String message})
    : super(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
      );
}
