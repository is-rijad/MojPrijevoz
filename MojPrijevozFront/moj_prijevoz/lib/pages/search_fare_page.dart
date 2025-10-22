import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/nominatim_provider.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/nominatim/nominatim_search_object.dart';
import 'package:moj_prijevoz/utils/nominatim_place_selector.dart';
import 'package:moj_prijevoz/widgets/dialogs/modal_bottom_sheet.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class SearchFarePage extends StatefulWidget {
  final NominatimResponse to;

  const SearchFarePage({super.key, required this.to});

  @override
  State<StatefulWidget> createState() => _SearchFarePageState();
}

class _SearchFarePageState extends State<SearchFarePage> {
  CityResponse? from;
  final _nominatimSearchObject = NominatimSearchObject();
  late final NominatimPlaceSelector _nominatimPlaceSelector;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context));
  }

  @override
  void initState() {
    _nominatimPlaceSelector = NominatimPlaceSelector(
      searchObject: _nominatimSearchObject,
    );
    _nominatimPlaceSelector.selectPlace(widget.to);

    super.initState();
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child:
                    PagedDropdown<
                      CityResponse,
                      int,
                      CityProvider,
                      CitySearchObject
                    >(
                      getLabel: (i) => i.name,
                      getValue: (i) => i.id,
                      onSelectionChanged: (value) {
                        from = value;
                      },
                      searchObject: CitySearchObject(page: 1, pageSize: 5),
                    ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child:
                    AutocompleteTextInput<
                      NominatimResponse,
                      int,
                      NominatimProvider,
                      NominatimSearchObject
                    >(
                      getLabel: (i) => i.displayName,
                      getValue: (i) => i.placeId,
                      searchObject: _nominatimSearchObject,
                      onTextChanged: (value) {
                        _nominatimPlaceSelector.resetSelection();
                      },
                      onSelectionChanged: (value) =>
                          _nominatimPlaceSelector.selectPlace(value),
                      selectedItem: _nominatimPlaceSelector.locationBound,
                    ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _onSearchButtonPressed,
                child: const Icon(Icons.search),
              ),
            ],
          ),
        ),

        Expanded(
          child: MapComponent(
            from: from,
            to: _nominatimPlaceSelector.locationBound,
          ),
        ),
      ],
    );
  }

  Future<void> _onSearchButtonPressed() async {
    context.read<NominatimProvider>().clearData(_nominatimSearchObject);
    await context.read<NominatimProvider>().fetchData(_nominatimSearchObject);
    if (_nominatimPlaceSelector.locationBound == null) {
      if (!mounted) return;
      final location =
          await ModalBottomSheet.showModalSheet<
            NominatimResponse,
            NominatimSearchObject,
            NominatimProvider
          >(context, _nominatimSearchObject, (i) => i.displayName);
      if (!mounted) return;
      setState(() {
        _nominatimPlaceSelector.selectPlace(location);
      });
    }

    if (from == null) {
      throw UserException("Morate izabrati početnu lokaciju!");
    }
    if (_nominatimSearchObject.contains == null ||
        _nominatimSearchObject.contains!.isEmpty) {
      throw UserException("Morate izabrati krajnju destinaciju!");
    }
    if (mounted) setState(() {});
  }
}
