import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';

class UIProvider {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  bool _loadingDisabled = false;
  DrawerMenuAction? drawerMenuAction;

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
}
