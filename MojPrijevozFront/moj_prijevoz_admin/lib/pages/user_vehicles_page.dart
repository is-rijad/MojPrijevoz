import 'package:flutter/widgets.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class UserVehiclesPage extends StatefulWidget {
  const UserVehiclesPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserVehiclesPageState();
}

class _UserVehiclesPageState extends RouteAwareState<UserVehiclesPage> {
  _UserVehiclesPageState() : super(action: DrawerMenuAction.userVehicles);

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return PageWrapper(
      body: SizedBox.shrink(),
      appBarTitle: "Vozila korisnika",
    );
  }

  Future<bool> _init() async {
    return true;
  }
}
