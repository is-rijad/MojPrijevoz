import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/pages/map_page.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CityResponse? location;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _buildHomePage(context));
  }

  Widget _buildHomePage(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ..._buildHeadingAndSearch(context),
            _buildNextFares(context),
            _buildSuggestedDrivers(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHeadingAndSearch(BuildContext context) {
    return [
      Column(
        children: [
          const Text("Moj prijevoz"),
          const Text("Vožnja koja stiže kada Vama odgovara."),
        ],
      ),

      Form(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child:
                  PagedDropdownFormField<
                    CityResponse,
                    int,
                    CityProvider,
                    CitySearchObject
                  >(
                    decoration:
                        InputDecorationWithIcon(
                          iconData: Icons.location_on,
                        ).copyWith(
                          hintText: "Gdje želite putovati?",
                          border: OutlineInputBorder(),
                        ),
                    searchObject: CitySearchObject(page: 1, pageSize: 5),
                    getLabel: (i) => i.name,
                    getValue: (i) => i.id,
                    onChanged: (value) => setState(() {
                      location = value;
                    }),
                  ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: location != null ? searchLocation : null,
              child: const Text("Započni"),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildNextFares(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Preporučene vožnje"),
        Container(color: Colors.amber, height: 200),
      ],
    );
  }

  Widget _buildSuggestedDrivers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Preporučeni vozači"),
        Container(color: Colors.deepOrange, height: 200),
      ],
    );
  }

  Future<void> searchLocation() async {
    if (location == null) {
      throw UserException("Lokacija je obavezan!");
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage(to: location!)),
    );
  }
}
