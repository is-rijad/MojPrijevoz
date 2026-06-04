import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/profile_dropdown_action.dart';

class UIProvider {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool _loadingDisabled = false;
  ProfileDropdownAction? profileDropdownAction;

  void disableLoading() {
    _loadingDisabled = true;
  }

  void startLoading() {
    if (!_loadingDisabled) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => isLoading.value = true,
      );
    }
    _loadingDisabled = false;
  }

  void stopLoading() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => isLoading.value = false,
    );
  }

  Future handleNavigationFromNotification(Map<String, dynamic> data) async {}
}
