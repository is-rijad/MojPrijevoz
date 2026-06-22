import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/providers/ui_provider.dart';

class DrawerMenuItem extends ListTile {
  final DrawerMenuAction value;
  final Future Function(DrawerMenuAction action)? onClick;
  final String text;

  DrawerMenuItem({
    super.key,
    required this.value,
    required this.text,
    this.onClick,
  }) : super(
         onTap: () => onClick?.call(value),
         enabled: GetIt.I<UIProvider>().drawerMenuAction != value,
         title: Builder(
           builder: (context) {
             final uiProvider = GetIt.I<UIProvider>();
             return Text(
               text,
               style: TextStyle(
                 fontSize: 18,
                 fontWeight: FontWeight(600),
                 color: uiProvider.drawerMenuAction == value
                     ? context.primaryColor
                     : null,
               ),
             );
           },
         ),
       );
}
