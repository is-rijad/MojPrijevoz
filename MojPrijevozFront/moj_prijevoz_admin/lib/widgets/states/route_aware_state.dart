import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/providers/ui_provider.dart';

abstract class RouteAwareState<T extends StatefulWidget> extends State<T>
    with RouteAware {
  final DrawerMenuAction action;

  RouteAwareState({required this.action});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Constants.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        GetIt.I<UIProvider>().drawerMenuAction = action;
      });
    });
  }

  @override
  void dispose() {
    Constants.routeObserver.unsubscribe(this);
    super.dispose();
  }
}
