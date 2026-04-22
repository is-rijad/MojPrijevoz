import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/components/next_fares/next_fares_component.dart';
import 'package:moj_prijevoz/pages/search_fare_page.dart';
import 'package:moj_prijevoz/providers/nominatim_provider.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/search_objects/nominatim/nominatim_search_object.dart';
import 'package:moj_prijevoz/utils/nominatim_place_selector.dart';
import 'package:moj_prijevoz/widgets/dialogs/modal_bottom_sheet.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchObject = NominatimSearchObject();
  late final NominatimPlaceSelector _nominatimPlaceSelector;

  @override
  void initState() {
    super.initState();
    _nominatimPlaceSelector = NominatimPlaceSelector(
      searchObject: _searchObject,
    );
  }

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
                  AutocompleteTextInput<
                    NominatimResponse,
                    int,
                    NominatimProvider,
                    NominatimSearchObject
                  >(
                    decoration: InputDecorationWithIcon(
                      iconData: Icons.location_on,
                    ).copyWith(hintText: "Gdje želite putovati?"),
                    searchObject: _searchObject,
                    getLabel: (i) => i.displayName,
                    getValue: (i) => i.placeId,
                    onTextChanged: (value) {
                      _nominatimPlaceSelector.resetSelection();
                      setState(() {
                        _searchObject.contains = value.isNotEmpty
                            ? value
                            : null;
                      });
                    },
                    onSelectionChanged: (value) {
                      _nominatimPlaceSelector.selectPlace(value);
                    },
                  ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _searchObject.contains != null ? searchLocation : null,
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
        const Text("Vaše zakazane vožnje"),
        SizedBox(height: 200, child: NextFaresComponent()),
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
    if (_searchObject.contains == null) {
      throw UserException("Lokacija je obavezna!");
    }
    if (_nominatimPlaceSelector.locationBound == null) {
      final location =
          await ModalBottomSheet.showModalSheet<
            NominatimResponse,
            NominatimSearchObject,
            NominatimProvider
          >(context, _searchObject, (i) => i.displayName);
      _nominatimPlaceSelector.selectPlace(location);
    }
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchFarePage(to: _nominatimPlaceSelector.locationBound!),
      ),
    );
  }
}
