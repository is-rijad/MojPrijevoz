import 'package:flutter/widgets.dart';
import 'package:moj_prijevoz_admin/common/providers/auth_provider.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return PageWrapper(body: SizedBox.shrink(), appBarTitle: "Moj prijevoz");
  }

  Future<bool> _init() async {
    try {
      await context.read<AuthProvider>().getNewToken();
    } catch (_) {}
    return true;
  }
}
