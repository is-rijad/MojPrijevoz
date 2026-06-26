import 'package:flutter/widgets.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _RatingsPageState();
}

class _RatingsPageState extends RouteAwareState<RatingsPage> {
  _RatingsPageState() : super(action: DrawerMenuAction.ratings);

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return PageWrapper(body: SizedBox.shrink(), appBarTitle: "Recenzije");
  }

  Future<bool> _init() async {
    return true;
  }
}
