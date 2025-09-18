import 'package:flutter/material.dart';

class LoadingProvider {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void startLoading() {
    isLoading.value = true;
  }

  void stopLoading() {
    isLoading.value = false;
  }
}
