import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/common/profile_dropdown_action.dart';

class UIProvider {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  ProfileDropdownAction? profileDropdownAction;

  void startLoading(LoadingType loadingType) {
    if (loadingType == LoadingType.global) {
      isLoading.value = true;
    }
  }

  void stopLoading() {
    isLoading.value = false;
  }
}
