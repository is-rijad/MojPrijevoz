import 'package:flutter/material.dart';

class LoadingProvider {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void startLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });
  }

  void stopLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = false;
    });
  }
}
