import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/tables/paginated_table.dart';
import 'package:moj_prijevoz_admin/pages/cities/one_city_page.dart';
import 'package:moj_prijevoz_admin/providers/city_provider.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/all_cities_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz_admin/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<StatefulWidget> createState() => _CitiesPageState();
}

class _CitiesPageState extends RouteAwareState<CitiesPage> {
  _CitiesPageState() : super(action: DrawerMenuAction.cities);

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context), appBarTitle: "Gradovi");
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                text: "Dodajte grad",
                onPressed: () async => await _navigateToAddCityPage(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: context.screenHeight * 0.8,
          width: context.screenWidth,
          child:
              PaginatedTable<
                AllCitiesResponse,
                CityResponse,
                CityProvider,
                CitySearchObject
              >(
                searchObject: CitySearchObject(page: 1, pageSize: 10),
                header: <String, String?>{
                  "Naziv": "Name",
                  "G. širina": "Lat",
                  "G. dužina": "Long",
                  "Kreiran u": "CreatedAt",
                  "Uređen u": "UpdatedAt",
                },

                items: [
                  (i) => Text(i.name),
                  (i) => Text(i.lat),
                  (i) => Text(i.long),
                  (i) => Text(
                    "${context.getLocalizedDate(i.createdAt)} ${context.getLocalizedTime(i.createdAt)}",
                  ),
                  (i) => Text(
                    "${context.getLocalizedDate(i.updatedAt)} ${context.getLocalizedTime(i.updatedAt)}",
                  ),
                ],
                onTap: (i) async =>
                    await Constants.navigatorKey.currentState?.push(
                      MaterialPageRoute(
                        builder: (context) => OneCityPage(cityId: i!.id),
                      ),
                    ),
              ),
        ),
      ],
    );
  }

  Future _navigateToAddCityPage() async {
    await Constants.navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => OneCityPage(cityId: null)),
    );
  }
}
