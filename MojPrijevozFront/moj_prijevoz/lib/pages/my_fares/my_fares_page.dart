import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/pages/my_fares/my_fares_driver_page.dart';
import 'package:moj_prijevoz/pages/my_fares/my_fares_passenger_page.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/fare_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class MyFaresPage extends StatefulWidget {
  final String? fareId;
  final String? side;
  const MyFaresPage({super.key, this.fareId, this.side});

  @override
  State<StatefulWidget> createState() => _MyFaresPageState();
}

class _MyFaresPageState extends State<MyFaresPage> {
  int? driverProfileId;
  ProfileType? complementSide;
  FareResponse? fareFromNotification;
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
          height: context.screenHeight * 0.7,
          child: MyFaresPassengerPage(),
        ),
      );
    }
    return DefaultTabController(
      initialIndex: complementSide?.index ?? 0,
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
              child: Center(
                child: TabBarView(
                  children: [
                    ChangeNotifierProvider(
                      create: (_) => FareProvider(),
                      child: MyFaresPassengerPage(
                        fareId: int.tryParse(widget.fareId ?? ""),
                      ),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => FareProvider(),
                      child: MyFaresDriverPage(
                        fareId: int.tryParse(widget.fareId ?? ""),
                      ),
                    ),
                  ],
                ),
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
    if (widget.fareId != null && widget.side != null && mounted) {
      complementSide = widget.side == "0"
          ? ProfileType.driver
          : ProfileType.passenger;
    }
    return true;
  }
}
