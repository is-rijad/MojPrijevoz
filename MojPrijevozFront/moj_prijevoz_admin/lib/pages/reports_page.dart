import 'package:flutter/widgets.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ReportsPageState();
}

class _ReportsPageState extends RouteAwareState<ReportsPage> {
  _ReportsPageState() : super(action: DrawerMenuAction.reports);

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return PageWrapper(body: SizedBox.shrink(), appBarTitle: "Izvještaji");
  }

  Future<bool> _init() async {
    return true;
  }
}
