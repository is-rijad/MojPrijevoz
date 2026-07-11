import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/providers/auth_provider.dart';
import 'package:moj_prijevoz_admin/common/providers/ui_provider.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/components/stats/fare_this_month.dart';
import 'package:moj_prijevoz_admin/components/stats/users_by_city_map.dart';
import 'package:moj_prijevoz_admin/components/stats/chart_by_month.dart';
import 'package:moj_prijevoz_admin/providers/stats_provider.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends RouteAwareState<HomePage> {
  _HomePageState() : super(action: DrawerMenuAction.home);

  @override
  void didPopNext() {
    fetchData();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return PageWrapper(body: _buildBody(context), appBarTitle: "Moj prijevoz");
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextLabelLarge("Korisnici po gradovima"),
                  SizedBox(
                    width: context.screenWidth * 0.45,
                    height: context.screenHeight * 0.4,
                    child: Consumer<StatsProvider>(
                      builder: (context, provider, _) {
                        return UsersByCityMap(
                          data: provider.usersByCitySearchResult.items,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  const TextLabelLarge("Registrovani korisnici po mjesecima"),
                  SizedBox(
                    width: context.screenWidth * 0.45,
                    height: context.screenHeight * 0.4,
                    child: Consumer<StatsProvider>(
                      builder: (context, provider, _) {
                        return ChartByMonth(
                          data: provider.usersByMonthSearchResult.items,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextLabelLarge("Zarada od provizije po mjesecima"),
                  SizedBox(
                    width: context.screenWidth * 0.45,
                    height: context.screenHeight * 0.4,
                    child: Consumer<StatsProvider>(
                      builder: (context, provider, _) {
                        return ChartByMonth(
                          data: provider.revenueByMonthSearchResult.items,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextLabelLarge("Sve vožnje ovaj mjesec"),
                  SizedBox(
                    width: context.screenWidth * 0.45,
                    height: context.screenHeight * 0.4,
                    child: Consumer<StatsProvider>(
                      builder: (context, provider, _) {
                        return FareThisMonthChart(
                          data: provider.faresThisMonthSearchResult.items,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _init() async {
    try {
      await context.read<AuthProvider>().getNewToken();
    } catch (_) {}
    setState(() {
      GetIt.I<UIProvider>().drawerMenuAction = DrawerMenuAction.home;
    });
    if (!mounted) return false;
    await fetchData();
    return true;
  }

  Future fetchData() async {
    await Future.wait([
      context.read<StatsProvider>().getUsersByCity(),
      context.read<StatsProvider>().getUsersByMonth(),
      context.read<StatsProvider>().getRevenueByMonth(),
      context.read<StatsProvider>().getFaresThisMonth(),
    ]);
  }
}
