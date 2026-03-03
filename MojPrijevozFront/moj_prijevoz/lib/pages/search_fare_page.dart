import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/providers/nominatim_provider.dart';
import 'package:moj_prijevoz/providers/search_fare_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/requests/search_fare/search_fare_request.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/nominatim/nominatim_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/search_fare/search_fare_search_object.dart';
import 'package:moj_prijevoz/utils/nominatim_place_selector.dart';
import 'package:moj_prijevoz/widgets/date_time/date_time_picker_form_field.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input_form_field.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class SearchFarePage extends StatefulWidget {
  final NominatimResponse to;

  const SearchFarePage({super.key, required this.to});

  @override
  State<StatefulWidget> createState() => _SearchFarePageState();
}

class _SearchFarePageState extends State<SearchFarePage> {
  final SearchFareRequest _request = SearchFareRequest();
  final _formKey = GlobalKey<FormState>();
  final _nominatimSearchObject = NominatimSearchObject();
  late final NominatimPlaceSelector _nominatimPlaceSelectorForFinalLocation;
  final _searchFareSearchObject = SearchFareSearchObject(page: 1, pageSize: 5);
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;
  final _pageSize = 4;

  final List<NominatimPlaceSelector> _nominatimPlaceSelectors = List.empty(
    growable: true,
  );
  final List<NominatimSearchObject> _nominatimSearchObjects = List.empty(
    growable: true,
  );
  int currentBreadCrumbIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context));
  }

  @override
  void initState() {
    _nominatimPlaceSelectorForFinalLocation = NominatimPlaceSelector(
      searchObject: _nominatimSearchObject,
    );
    _nominatimPlaceSelectorForFinalLocation.selectPlace(widget.to);
    _addStopPlace();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onPageChanged(
    int value,
    SearchResult<UserResponse> searchResult,
  ) async {
    if (value ==
            (_searchFareSearchObject.pageSize * _searchFareSearchObject.page) -
                1 &&
        searchResult.hasMore) {
      await context.read<SearchFareProvider>().fetchData(
        _searchFareSearchObject,
      );
    }
    if (!mounted) return;
    setState(() {
      _currentPage = value;
    });
  }

  void _addStopPlace() {
    final searchObject = NominatimSearchObject();
    final selector = NominatimPlaceSelector(searchObject: searchObject);

    setState(() {
      _nominatimSearchObjects.add(searchObject);
      _nominatimPlaceSelectors.add(selector);
    });
  }

  Widget _build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 10,
          children: [
            _buildBreadCrumbs(),

            if (currentBreadCrumbIndex == 0) ..._buildInputs(),
            if (currentBreadCrumbIndex == 1) _buildRecommendedDrivers(),
            if (currentBreadCrumbIndex == 2) _buildSummary(),

            Spacer(),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadCrumbs() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        TextButton(
          onPressed: () => setState(() {
            currentBreadCrumbIndex = 0;
          }),
          child: Text(
            "Podaci o vožnji",
            style: TextStyle(
              color: currentBreadCrumbIndex == 0
                  ? context.primaryColor
                  : Colors.black,
            ),
          ),
        ),
        const Text(">"),
        TextButton(
          onPressed: _request.isValid
              ? () async {
                  await _onClickRecommendedDriver();
                  setState(() {
                    currentBreadCrumbIndex = 1;
                  });
                }
              : null,
          child: Text(
            "Preporučeni vozači",
            style: TextStyle(
              color: currentBreadCrumbIndex == 1
                  ? context.primaryColor
                  : Colors.black,
            ),
          ),
        ),
        const Text(">"),
        TextButton(
          onPressed: _request.isValid
              ? () => setState(() {
                  currentBreadCrumbIndex = 2;
                })
              : null,
          child: Text(
            "Sažetak",
            style: TextStyle(
              color: currentBreadCrumbIndex == 2
                  ? context.primaryColor
                  : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildInputs() {
    return [
      _buildStartLocation(),
      _buildStopPlaces(),
      _buildFinalLocation(),
      _buildDateTimePicker(),
      _buildBudgetInput(),
    ];
  }

  Widget _buildStartLocation() {
    return PagedDropdownFormField<
      CityResponse,
      int,
      CityProvider,
      CitySearchObject
    >(
      getLabel: (i) => i.name,
      getValue: (i) => i.id,
      initialValue: _request.startLocation,
      onSelectionChanged: (value) {
        setState(() {
          _request.startLocation = value;
        });
      },
      decoration: InputDecorationWithIcon(
        iconData: Icons.location_on_outlined,
        iconHint: "Putujem iz",
      ),
      defaultLabel: "Putujem iz",
      searchObject: CitySearchObject(page: 1, pageSize: 5),
      validator: (value) {
        if (value == null) {
          return "Početna lokacija je obavezna!";
        }
        return null;
      },
    );
  }

  Widget _buildStopPlaces() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Constants.autoCompleteTextInputElementHeight * 3 + 10,
              maxWidth: context.screenWidth - 95,
            ),
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                    width: 1,
                    height:
                        (_nominatimSearchObjects.length) *
                        Constants.autoCompleteTextInputElementHeight,
                    color: Colors.black,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: List.generate(_nominatimSearchObjects.length, (
                        index,
                      ) {
                        final searchObject = _nominatimSearchObjects[index];
                        final placeSelector = _nominatimPlaceSelectors[index];

                        return Row(
                          key: ValueKey(searchObject),
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _nominatimSearchObjects.removeAt(index);
                                  _nominatimPlaceSelectors.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.remove),
                            ),
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
                                    searchObject: searchObject,
                                    onTextChanged: (_) {
                                      placeSelector.resetSelection();
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Zaustavno mjesto",
                                    ),
                                    onSelectionChanged: (value) {
                                      setState(() {
                                        placeSelector.selectPlace(value);
                                      });
                                    },
                                    selectedItem: placeSelector.locationBound,
                                  ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => setState(() {
              _addStopPlace();
            }),
            icon: Icon(Icons.add_location_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalLocation() {
    return AutocompleteTextInputFormField<
      NominatimResponse,
      int,
      NominatimProvider,
      NominatimSearchObject
    >(
      getLabel: (i) => i.displayName,
      getValue: (i) => i.placeId,
      searchObject: _nominatimSearchObject,
      onTextChanged: (value) {
        _nominatimPlaceSelectorForFinalLocation.resetSelection();
      },
      onSelectionChanged: (value) => setState(() {
        _nominatimPlaceSelectorForFinalLocation.selectPlace(value);
        _request.finalLocation = value;
      }),
      initialValue: _nominatimPlaceSelectorForFinalLocation.locationBound,
      decoration: InputDecorationWithIcon(
        iconData: Icons.location_on_outlined,
        iconHint: "Putujem do",
      ),
      validator: (value) {
        if (value == null) {
          return "Početna lokacija je obavezna!";
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker() {
    return DateTimePickerFormField(
      initialValue: _request.fareDateTime,
      defaultLabel: "Datum i vrijeme putovanja",
      decoration: InputDecorationWithIcon(
        iconData: Icons.calendar_month_outlined,
        iconHint: "Datum i vrijeme putovanja",
      ),
      onDateTimeChanged: (dateTime) => setState(() {
        _request.fareDateTime = dateTime;
      }),
      validator: (value) {
        if (value == null) {
          return "Datum i vrijeme su obavezni!";
        }
        return null;
      },
    );
  }

  Widget _buildBudgetInput() {
    return SizedBox(
      width: context.screenWidth,
      child: TextFormField(
        initialValue: _request.budget?.toString(),
        decoration: InputDecorationWithIcon(
          iconData: Icons.attach_money_outlined,
          iconHint: "Budžet (KM)",
        ).copyWith(suffixText: "KM", labelText: "Budžet (KM)"),
        keyboardType: TextInputType.number,
        onSaved: (newValue) => _request.budget = double.parse(newValue!),
        validator: (value) {
          if (value == null) {
            return "Budžet je obavezan!";
          }
          if (double.tryParse(value) == null) {
            return "Budžet mora biti broj!";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildRecommendedDrivers() {
    return SizedBox(
      width: context.screenWidth,
      height: context.screenHeight - 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<SearchFareProvider>(
            builder: (context, provider, _) {
              if (provider.searchResult.items.isEmpty) {
                return Expanded(
                  child: const Center(
                    child: Text("Nisu pronađeni vozači za ovu rutu!"),
                  ),
                );
              }
              return Column(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          _onPageChanged(index, provider.searchResult),
                      children: provider.searchResult.items
                          .map((i) => _buildSearchFareDriverCard(context, i))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      provider.searchResult.items.length,
                      (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? context.primaryColor
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFareDriverCard(BuildContext context, UserResponse driver) {
    return GestureDetector(
      onTap: () => true,
      onLongPress: () => true,
      onSecondaryTap: () => true,
      child: Card(
        borderOnForeground: true,
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return SizedBox(
      width: context.screenWidth,
      height: 240,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sažetak"),
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.screenWidth * 0.4,
                  maxHeight: 200,
                ),
                child: MapComponent(
                  from: _request.startLocation,
                  to: _nominatimPlaceSelectorForFinalLocation.locationBound,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        ElevatedButton(
          onPressed: currentBreadCrumbIndex == 0
              ? null
              : () => setState(() {
                  currentBreadCrumbIndex--;
                }),
          child: Text("Nazad"),
        ),
        ElevatedButton(
          onPressed: currentBreadCrumbIndex == 2
              ? null
              : _onClickButtonOrBreadCrumb,

          child: Text("Dalje"),
        ),
      ],
    );
  }

  Future<void>? _onClickButtonOrBreadCrumb() async {
    if (currentBreadCrumbIndex == 0) {
      await _onClickRecommendedDriver();
    } else if (currentBreadCrumbIndex == 1) {
      setState(() {
        currentBreadCrumbIndex++;
      });
    }
  }

  Future<void> _onClickRecommendedDriver() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      setState(() {
        _request.isValid = true;
      });
      _request.stopPlaces = [];
      for (var i in _nominatimPlaceSelectors) {
        if (i.locationBound != null) {
          _request.stopPlaces!.add(i.locationBound!);
        }
      }
      context.read<SearchFareProvider>().clearData(_searchFareSearchObject);
      var route = await GetIt.I<MapProvider>().getRoute(
        _request.startLocation!,
        _request.finalLocation!,
      );
      _searchFareSearchObject.originCityId = _request.startLocation!.id;
      _searchFareSearchObject.duration = route.duration;
      _searchFareSearchObject.distance = route.distance;
      _searchFareSearchObject.budget = _request.budget;
      _searchFareSearchObject.fareDateTime = _request.fareDateTime;

      if (!mounted) return;

      await context.read<SearchFareProvider>().fetchData(
        _searchFareSearchObject,
      );
      setState(() {
        currentBreadCrumbIndex = 1;
      });
    }
  }
}
