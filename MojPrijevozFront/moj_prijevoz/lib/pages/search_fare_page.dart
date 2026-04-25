import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/pages/home_page.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/fare_offer_provider.dart';
import 'package:moj_prijevoz/providers/map_provider.dart';
import 'package:moj_prijevoz/providers/nominatim_provider.dart';
import 'package:moj_prijevoz/providers/search_fare_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/dtos/fare_offer/fare_offer_driver_price_dto.dart';
import 'package:moj_prijevoz/resources/dtos/nominatim/nominatim_city_dto.dart';
import 'package:moj_prijevoz/resources/dtos/stop_point/stop_point_dto.dart';
import 'package:moj_prijevoz/resources/requests/fare_offer/fare_offer_insert_request.dart';
import 'package:moj_prijevoz/resources/requests/search_fare/search_fare_request.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/responses/search_fare/search_fare_driver_response.dart';
import 'package:moj_prijevoz/resources/responses/search_fare/search_fare_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/nominatim/nominatim_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/search_fare/search_fare_driver_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/search_fare/search_fare_search_object.dart';
import 'package:moj_prijevoz/utils/nominatim_place_selector.dart';
import 'package:moj_prijevoz/widgets/date_time/date_time_picker_form_field.dart';
import 'package:moj_prijevoz/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz/widgets/dialogs/general_dialog.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input_form_field.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class SearchFarePage extends StatefulWidget {
  final NominatimResponse to;

  const SearchFarePage({super.key, required this.to});

  @override
  State<StatefulWidget> createState() => _SearchFarePageState();
}

class _SearchFarePageState extends State<SearchFarePage> {
  late AuthProvider _authProvider;
  late UserProvider _userProvider;
  late CityProvider _cityProvider;
  late final UserResponse _userResponse;
  late CityResponse _usersCity;
  final UIProvider _uiProvider = GetIt.I<UIProvider>();
  final SearchFareRequest _request = SearchFareRequest();
  final _formKey = GlobalKey<FormState>();
  final _nominatimSearchObject = NominatimSearchObject();
  late final NominatimPlaceSelector _nominatimPlaceSelectorForFinalLocation;
  final _searchFareSearchObject = SearchFareSearchObject(page: 1, pageSize: 5);
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  final List<NominatimPlaceSelector> _nominatimPlaceSelectors = List.empty(
    growable: true,
  );
  final List<NominatimSearchObject> _nominatimSearchObjects = List.empty(
    growable: true,
  );
  final Map<int, SearchFareDriverResponse> _selectedDrivers =
      <int, SearchFareDriverResponse>{};
  int currentBreadCrumbIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      appBarTitle: const Text("Potražite vožnju"),
      body: LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init),
    );
  }

  Future<bool> _init() async {
    _uiProvider.disableLoading();
    var userId = await _authProvider.getUserId();
    _uiProvider.disableLoading();
    _userResponse = await _userProvider.getById(userId);
    _uiProvider.disableLoading();
    _usersCity = await _cityProvider.getById(_userResponse.cityId);
    return true;
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
  void didChangeDependencies() {
    _authProvider = context.read<AuthProvider>();
    _userProvider = context.read<UserProvider>();
    _cityProvider = context.read<CityProvider>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onPageChanged(
    int value,
    SearchResult<SearchFareResponse> searchResult,
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
          onPressed: (_request.isValid && (_selectedDrivers.isNotEmpty))
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
      initialValue: _usersCity,
      onSelectionChanged: (value) {
        _request.isChanged = true;
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
      onSaved: (value) => _request.startLocation = value,
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
                        _nominatimSearchObjects.length *
                        Constants.autoCompleteTextInputElementHeight,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex--;
                          final obj = _nominatimSearchObjects.removeAt(
                            oldIndex,
                          );
                          final sel = _nominatimPlaceSelectors.removeAt(
                            oldIndex,
                          );
                          _nominatimSearchObjects.insert(newIndex, obj);
                          _nominatimPlaceSelectors.insert(newIndex, sel);
                          _request.isChanged = true;
                        });
                      },
                      children: List.generate(_nominatimSearchObjects.length, (
                        index,
                      ) {
                        final searchObject = _nominatimSearchObjects[index];
                        final placeSelector = _nominatimPlaceSelectors[index];

                        return Row(
                          key: ValueKey(searchObject),
                          children: [
                            ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                            IconButton(
                              onPressed: () => setState(() {
                                _nominatimSearchObjects.removeAt(index);
                                _nominatimPlaceSelectors.removeAt(index);
                              }),
                              icon: const Icon(Icons.remove),
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
                                    onTextChanged: (_) =>
                                        placeSelector.resetSelection(),
                                    decoration: const InputDecoration(
                                      labelText: "Zaustavno mjesto",
                                    ),
                                    onSelectionChanged: (value) {
                                      _request.isChanged = true;
                                      setState(
                                        () => placeSelector.selectPlace(value),
                                      );
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
            onPressed: () => setState(_addStopPlace),
            icon: const Icon(Icons.add_location_rounded),
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
      onSelectionChanged: (value) {
        _request.isChanged = true;
        setState(() {
          _nominatimPlaceSelectorForFinalLocation.selectPlace(value);
          _request.finalLocation = value;
        });
      },
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
      onSaved: (value) => _request.finalLocation = value,
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
      onDateTimeChanged: (dateTime) {
        _request.isChanged = true;
        setState(() {
          _request.fareDateTime = dateTime;
        });
      },
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
        onChanged: (value) {
          _request.isChanged = true;
        },
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
      height: context.screenHeight - 200,
      child: Consumer<SearchFareProvider>(
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
                children: List.generate(provider.searchResult.items.length, (
                  i,
                ) {
                  final isActive = i == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 12 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? context.primaryColor : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchFareDriverCard(
    BuildContext context,
    SearchFareResponse driver,
  ) {
    return GestureDetector(
      onTap: () => _toggleSelectedDriver(driver),
      child: Card(
        surfaceTintColor: _selectedDrivers.containsKey(driver.profileId)
            ? context.primaryColor
            : null,
        borderOnForeground: true,
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              spacing: 12,
              children: [
                SizedBox(height: 12),
                Avatar(user: driver),
                Text("${driver.firstName} ${driver.lastName}"),
                Text("${driver.averageReview} / ${driver.numberOfReviews}"),
                SizedBox(
                  child: Center(
                    child: Consumer<SearchFareProvider>(
                      builder:
                          (
                            BuildContext context,
                            SearchFareProvider provider,
                            Widget? _,
                          ) {
                            return DropdownMenuFormField<UserVehicleResponse>(
                              enableFilter: false,
                              enableSearch: false,
                              key: Key(driver.profileId.toString()),
                              initialSelection:
                                  driver.vehicles!.indexWhere(
                                        (i) =>
                                            i.vehicleId ==
                                            provider
                                                .fareDrivers[driver.profileId]
                                                ?.vehicleId,
                                      ) !=
                                      -1
                                  ? driver.vehicles!.firstWhere(
                                      (i) =>
                                          i.vehicleId ==
                                          provider
                                              .fareDrivers[driver.profileId]
                                              ?.vehicleId,
                                    )
                                  : null,
                              width: 300,
                              onSelected: (value) =>
                                  _onSelectedDriverVehicle(value),
                              leadingIcon: Image.asset(
                                "images/vehicleFallback.png",
                                width: 15,
                              ),
                              hintText: "Izaberite vozilo",
                              dropdownMenuEntries: driver.vehicles!.map((i) {
                                return DropdownMenuEntry(
                                  value: i,
                                  label:
                                      "${i.vehicle.manufacturer} ${i.vehicle.model} ${i.modelYear}",
                                );
                              }).toList(),
                            );
                          },
                    ),
                  ),
                ),
                Consumer<SearchFareProvider>(
                  builder: (context, provider, _) {
                    if (!provider.fareDrivers.containsKey(driver.profileId)) {
                      return SizedBox.shrink();
                    }
                    final fareDriver = provider.fareDrivers[driver.profileId];
                    return Column(
                      spacing: 8,
                      children: [
                        IconFieldWithText(
                          iconData: Icons.attach_money,
                          text: fareDriver!.additionalPrice == null
                              ? "${fareDriver.price}KM"
                              : "${fareDriver.price}KM (+${fareDriver.additionalPrice}KM)*",
                        ),
                        IconFieldWithText(
                          iconData: Icons.attach_money_rounded,
                          text:
                              "${round(fareDriver.price + (fareDriver.additionalPrice ?? 0), decimals: 2)}KM",
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _buildNegotiationDialog(driver.profileId),
              child: const Text("Uredi ponudu"),
            ),
          ],
        ),
      ),
    );
  }

  Future _buildNegotiationDialog(int profileId) async {
    var fareDriver = context.read<SearchFareProvider>().fareDrivers[profileId];
    await showDialog(
      context: context,
      builder: (context) {
        return GeneralDialog<SearchFareDriverResponse, dynamic>(
          title: "Uređivanje ponude",
          onSubmit: () async => true,
          submitButtonTitle: "Nastavi",
          entity: fareDriver,
          buildContent: _buildNegotiationDialogContent,
        );
      },
    );
  }

  List<Widget> _buildNegotiationDialogContent(
    BuildContext context,
    SearchFareDriverResponse fareDriver,
  ) {
    var price = fareDriver.price;
    var additionalPrice = fareDriver.additionalPrice;
    return [
      Row(
        spacing: 20,
        children: [
          Icon(Icons.price_change),
          Expanded(
            child: TextFormField(
              initialValue: price.toString(),
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null ||
                    double.parse(value) < 0) {
                  return "Unos nije validan!";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => setState(() {
                price = double.tryParse(value) ?? 0;
              }),
              onSaved: (value) => setState(() {
                fareDriver.price = price;
              }),
            ),
          ),
          Icon(Icons.add),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    double.tryParse(value) == null ||
                    double.parse(value) < 0) {
                  return "Unos nije validan!";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) => setState(() {
                additionalPrice = double.tryParse(value);
              }),
              initialValue: additionalPrice?.toString() ?? "0.0",
              onSaved: (value) => setState(() {
                fareDriver.additionalPrice = additionalPrice;
              }),
            ),
          ),
          Text("KM*"),
        ],
      ),
    ];
  }

  Widget _buildSummary() {
    return Row(
      spacing: 20,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.screenWidth * 0.4,
            maxHeight: 200,
          ),
          child: MapComponent(
            from: NominatimCityDto(
              long: _request.startLocation!.long,
              lat: _request.startLocation!.lat,
            ),
            to: NominatimCityDto(
              long: _nominatimPlaceSelectorForFinalLocation.locationBound!.lon,
              lat: _nominatimPlaceSelectorForFinalLocation.locationBound!.lat,
            ),
            stopPoints: _request.stopPlaces!
                .map((it) => NominatimCityDto(long: it.lon, lat: it.lat))
                .toList(),
          ),
        ),
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconFieldWithText(
              iconHint: "Vrijeme",
              iconData: Icons.timer,
              text: "${_searchFareSearchObject.duration!.round()} minuta",
            ),
            IconFieldWithText(
              iconHint: "Udaljenost",
              iconData: Icons.social_distance,
              text: "${_searchFareSearchObject.distance!.round()} km",
            ),
            IconFieldWithText(
              iconHint: "Vrijeme dolaska",
              iconData: Icons.watch_later,
              text: DateFormat.Hm().format(
                _searchFareSearchObject.fareDateTime!.add(
                  Duration(minutes: _searchFareSearchObject.duration!.toInt()),
                ),
              ),
            ),
            IconFieldWithText(
              iconHint: "Cijene",
              iconData: Icons.attach_money,
              text:
                  "${_selectedDrivers.entries.map((i) => "${i.value.price + (i.value.additionalPrice ?? 0)}KM").join(", ")}*",
            ),
          ],
        ),
      ],
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
          onPressed: (currentBreadCrumbIndex == 1 && _selectedDrivers.isEmpty)
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
    } else if (currentBreadCrumbIndex == 2) {
      await showDialog(
        context: context,
        builder: (context) {
          return _buildConfirmationDialog(context);
        },
      );
    }
  }

  Widget _buildConfirmationDialog(BuildContext context) {
    return ConfirmationDialog(
      content: const Text(
        "Da li ste sigurni da želite poslati zahtjeve izabranim vozačima?",
      ),
      onSubmit: () => _sendFareOffers(),
    );
  }

  Future _sendFareOffers() async {
    final request = FareOfferInsertRequest(
      originCityId: _request.startLocation!.id,
      destinationCity: NominatimCityDto.fromNominatimResponse(
        _request.finalLocation!,
      ),
      destinationName: _request.finalLocation!.displayName,
      length: _searchFareSearchObject.distance!,
      duration: _searchFareSearchObject.duration!,
      driversPrices: _selectedDrivers.entries
          .map(
            (it) => FareOfferDriverPriceDto(
              userVehicleId: it.value.userVehicleId,
              driverId: it.value.id,
              price: it.value.price,
              additionalPrice: it.value.additionalPrice,
            ),
          )
          .toList(),
      fareDateTime: _searchFareSearchObject.fareDateTime!,
      stopPoints: _nominatimPlaceSelectors
          .where((it) => it.locationBound != null)
          .map(
            (it) => StopPointDto(
              name: it.locationBound!.displayName,
              lat: it.locationBound!.lat,
              long: it.locationBound!.lon,
            ),
          )
          .toList(),
    );
    await context.read<FareOfferProvider>().insert(request);
    Constants.messengerKey.currentState?.showSnackBar(
      SuccessSnackBar(
        message: "Zahtjevi su uspješno poslani izabranim vozačima!",
      ),
    );
    if (!mounted) return;
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  Future<void> _onClickRecommendedDriver() async {
    if (_request.isChanged && (_formKey.currentState?.validate() ?? false)) {
      setState(() {
        _uiProvider.startLoading();
      });
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
      _selectedDrivers.clear();
      context.read<SearchFareProvider>().clearFareDrivers();
      context.read<SearchFareProvider>().clearData(_searchFareSearchObject);
      var route = await GetIt.I<MapProvider>().getRoute(
        NominatimCityDto(
          long: _request.startLocation!.long,
          lat: _request.startLocation!.lat,
        ),
        NominatimCityDto(
          long: _request.finalLocation!.lon,
          lat: _request.finalLocation!.lat,
        ),
        stopPlaces: _request.stopPlaces!
            .map((it) => NominatimCityDto(long: it.lon, lat: it.lat))
            .toList(),
        includeLocationNames: false,
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
    }
    setState(() {
      currentBreadCrumbIndex = 1;
      _uiProvider.disableLoading();
    });
    _request.isChanged = false;
  }

  Future<void> _onSelectedDriverVehicle(
    UserVehicleResponse? userVehicle,
  ) async {
    if (userVehicle == null) {
      return;
    }
    final searchObject = SearchFareDriverSearchObject(
      page: 0,
      pageSize: 0,
      budget: _searchFareSearchObject.budget,
      distance: _searchFareSearchObject.distance,
      fareDateTime: _searchFareSearchObject.fareDateTime,
      originCityId: _searchFareSearchObject.originCityId,
      duration: _searchFareSearchObject.duration,
      userVehicleId: userVehicle.id,
    );
    await context.read<SearchFareProvider>().fetchFareDriver(
      userVehicle.profileId,
      queryParameters: searchObject.toJson(),
    );
  }

  void _toggleSelectedDriver(SearchFareResponse driver) {
    final driverId = driver.profileId;
    if (_selectedDrivers.containsKey(driverId)) {
      setState(() {
        _selectedDrivers.remove(driverId);
      });
      return;
    }
    if (!context.read<SearchFareProvider>().fareDrivers.containsKey(driverId)) {
      Constants.messengerKey.currentState?.showSnackBar(
        ErrorSnackBar(message: "Morate izabrati vozilo!"),
      );
      return;
    }
    setState(() {
      _selectedDrivers[driverId] = context
          .read<SearchFareProvider>()
          .fareDrivers[driverId]!;
    });
  }
}
