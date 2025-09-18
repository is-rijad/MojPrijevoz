import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/loading_type.dart';

class LoadingProvider {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  void startLoading(LoadingType loadingType) {
     if (loadingType == LoadingType.global) {
      isLoading.value = true;
    }
  }

  void stopLoading() {
    isLoading.value = false;
  }
}
