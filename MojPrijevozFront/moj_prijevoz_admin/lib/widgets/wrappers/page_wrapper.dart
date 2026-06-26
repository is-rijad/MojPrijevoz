import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/providers/auth_provider.dart';
import 'package:moj_prijevoz_admin/common/providers/ui_provider.dart';
import 'package:moj_prijevoz_admin/common/widgets/drawer_menu/drawer_menu_item.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/pages/admins_page.dart';
import 'package:moj_prijevoz_admin/pages/cities_page.dart';
import 'package:moj_prijevoz_admin/pages/home_page.dart';
import 'package:moj_prijevoz_admin/pages/login_page.dart';
import 'package:moj_prijevoz_admin/pages/ratings_page.dart';
import 'package:moj_prijevoz_admin/pages/reports_page.dart';
import 'package:moj_prijevoz_admin/pages/transactions_page.dart';
import 'package:moj_prijevoz_admin/pages/user_vehicles_page.dart';
import 'package:moj_prijevoz_admin/pages/users/users_page.dart';
import 'package:moj_prijevoz_admin/pages/vehicles_page.dart';
import 'package:provider/provider.dart';

class PageWrapper extends StatefulWidget {
  final Widget body;
  final String? appBarTitle;

  const PageWrapper({super.key, required this.body, this.appBarTitle});

  @override
  State<StatefulWidget> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _uiProvider = GetIt.I<UIProvider>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: widget.body,
        key: _scaffoldKey,
        endDrawer: _buildDrawer(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Constants.navigatorKey.currentState?.canPop() ?? false
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => Constants.navigatorKey.currentState?.pop(),
            )
          : null,
      automaticallyImplyLeading: false,
      title: TextTitleSmall(widget.appBarTitle ?? ""),
      actions: [_buildDrawerIcon(context)],
      actionsPadding: EdgeInsets.all(8),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 60,
            child: DrawerHeader(
              padding: const EdgeInsetsGeometry.directional(top: 12, start: 12),
              decoration: BoxDecoration(color: context.primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TextTitleLarge('Admin meni'),
                  IconButton(
                    onPressed: () =>
                        _scaffoldKey.currentState?.closeEndDrawer(),
                    icon: Icon(Icons.close, color: context.secondaryColor),
                  ),
                ],
              ),
            ),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.home,
            text: "Početna",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.users,
            text: "Korisnici",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.userVehicles,
            text: "Vozila korisnika",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.vehicles,
            text: "Vozila",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.ratings,
            text: "Recenzije",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.cities,
            text: "Gradovi",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.admins,
            text: "Administartori",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.reports,
            text: "Izvještaji",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.transactions,
            text: "Transakcije",
            onClick: (action) async => await _onTap(action),
          ),
          DrawerMenuItem(
            value: DrawerMenuAction.logout,
            text: "Odjava",
            onClick: (action) async => await _onTap(action),
          ),
        ],
      ),
    );
  }

  Future _onTap(DrawerMenuAction action) async {
    _scaffoldKey.currentState?.closeEndDrawer();
    setState(() {
      _uiProvider.drawerMenuAction = action;
    });
    switch (action) {
      case DrawerMenuAction.home:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      case DrawerMenuAction.users:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => UsersPage()),
        );
      case DrawerMenuAction.userVehicles:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => UserVehiclesPage()),
        );
      case DrawerMenuAction.vehicles:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => VehiclesPage()),
        );
      case DrawerMenuAction.ratings:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => RatingsPage()),
        );
      case DrawerMenuAction.cities:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => CitiesPage()),
        );
      case DrawerMenuAction.admins:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => AdminsPage()),
        );
      case DrawerMenuAction.reports:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => ReportsPage()),
        );
      case DrawerMenuAction.transactions:
        await Constants.navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (context) => TransactionsPage()),
        );
      case DrawerMenuAction.logout:
        _uiProvider.startLoading();
        setState(() {
          _uiProvider.drawerMenuAction = null;
        });
        if (!context.mounted) return;
        await context.read<AuthProvider>().logout();
        if (!context.mounted) return;
        _uiProvider.stopLoading();
        await Constants.navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
        );
        break;
    }
    if (mounted) {
      setState(() {
        _uiProvider.drawerMenuAction = null;
      });
    }
  }

  Widget _buildDrawerIcon(BuildContext context) {
    return IconButton(
      onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      icon: Icon(Icons.menu),
    );
  }
}
