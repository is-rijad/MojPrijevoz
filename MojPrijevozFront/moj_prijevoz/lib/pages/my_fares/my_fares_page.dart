import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/pages/my_fares/my_fares_driver_page.dart';
import 'package:moj_prijevoz/pages/my_fares/my_fares_passenger_page.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class MyFaresPage extends StatefulWidget {
  const MyFaresPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyFaresPageState();
}

class _MyFaresPageState extends State<MyFaresPage> {
  int? driverProfileId;
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBarTitle: "Moje vožnje",
      body: LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init),
    );
  }

  Widget _build(BuildContext context) {
    if (driverProfileId == null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: context.screenHeight * 0.5,
          child: MyFaresPassengerPage(),
        ),
      );
    }
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: "Moje vožnje (putnik)"),
                Tab(text: "Moje vožnje (vozač)"),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: context.screenHeight * 0.7,
              child: TabBarView(
                children: [MyFaresPassengerPage(), MyFaresDriverPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _init() async {
    driverProfileId = await context.read<AuthProvider>().getProfileId(
      ProfileType.driver,
    );
    return true;
  }
}
