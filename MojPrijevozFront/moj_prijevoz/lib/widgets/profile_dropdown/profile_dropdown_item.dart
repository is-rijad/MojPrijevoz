import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/build_helper.dart';
import 'package:moj_prijevoz/common/profile_dropdown_action.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';

class ProfileDropdownItem extends PopupMenuItem<ProfileDropdownAction> {
  @override
  final ProfileDropdownAction value;
  final String text;

  ProfileDropdownItem({super.key, required this.value, required this.text})
    : super(
        value: value,
        enabled: GetIt.I<UIProvider>().profileDropdownAction != value,
        child: Builder(
          builder: (context) {
            final uiProvider = GetIt.I<UIProvider>();
            return Text(
              text,
              style: TextStyle(
                color: uiProvider.profileDropdownAction == value
                    ? BuildHelper.getPrimaryColor(context)
                    : null,
              ),
            );
          },
        ),
      );
}
