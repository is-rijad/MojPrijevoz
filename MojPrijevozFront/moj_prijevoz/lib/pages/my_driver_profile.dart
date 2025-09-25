import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/access_token_handler.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/error_handler.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/providers/user_vehicle_provider.dart';
import 'package:moj_prijevoz/providers/vehicle_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/common/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz/resources/requests/user_vehicle/user_vehicle_upsert_request.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz/resources/search_objects/user_vehicle/user_vehicle_search_object.dart';
import 'package:moj_prijevoz/resources/search_objects/vehicle/vehicle_search_object.dart';
import 'package:moj_prijevoz/widgets/alert_dialog/alert_dialog_content.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/icon_field_with_text.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class MyDriverProfile extends StatefulWidget {
  const MyDriverProfile({super.key});

  @override
  State<StatefulWidget> createState() => _MyDriverProfileState();
}

class _MyDriverProfileState extends State<MyDriverProfile> {
  late int? _profileId;
  final _formKey = GlobalKey<FormState>();
  final _userVehicleProvider = GetIt.I<UserVehicleProvider>(
    param1: LoadingType.global,
  );
  final _uiProvider = GetIt.I<UIProvider>();
  bool get isDriver => _profileId != null;

  UserVehicleUpsertRequest? _userVehicleUpsertRequest;

  late UserVehicleSearchObject _searchObject;
  final _userVehicles = SearchResult<UserVehicleResponse>();
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;
  final ValueNotifier<String?> _errorMessage = ValueNotifier(null);
  final _pageSize = 4;

  Future<void> _onPageChanged(int value) async {
    if (value == (_searchObject.pageSize * _searchObject.page) - 1 &&
        _userVehicles.hasMore) {
      _uiProvider.disableLoading();

      _searchObject.page++;
      var newItems = (await _userVehicleProvider.getAll(_searchObject));

      if (!mounted) return;
      setState(() {
        newItems.copyTo(_userVehicles);
      });
    }
    setState(() {
      _currentPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Future<bool> _init() async {
    _profileId = await AccessTokenHandler.getProfileId(ProfileType.driver);
    if (isDriver) await _initDriverData();
    return true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _initDriverData() async {
    _searchObject = UserVehicleSearchObject(
      profileId: _profileId!,
      pageSize: _pageSize,
    );
    (await _userVehicleProvider.getAll(_searchObject)).copyTo(_userVehicles);
  }

  Widget _build(BuildContext context) {
    return PageWrapper(
      body: isDriver ? _buildDriverPage(context) : _buildBecomeDriver(context),
      appBarTitle: isDriver
          ? const Text("Moj profil (vozač)")
          : const Text("Postani vozač"),
    );
  }

  Widget _buildBecomeDriver(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Još niste vozač?"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _buildVehicleUpsertDialog(context, null),
            child: const Text("Postanite vozač"),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverPage(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text("Broj vožnji"), const Text("0")],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Moja vozila"),
              ElevatedButton(
                onPressed: () => _buildVehicleUpsertDialog(context, null),
                child: const Text("Dodaj vozilo"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: _userVehicles.items
                  .map((i) => _buildUserVehicleCard(context, i))
                  .toList(),
            ),
          ),
          SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_userVehicles.items.length, (i) {
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
      ),
    );
  }

  Widget _buildUserVehicleCard(
    BuildContext context,
    UserVehicleResponse userVehicle,
  ) {
    return GestureDetector(
      onTap: () => _buildVehicleUpsertDialog(context, userVehicle),
      onLongPress: () => _buildVehicleDeleteDialog(context, userVehicle),
      onSecondaryTap: () => _buildVehicleDeleteDialog(context, userVehicle),
      child: Card(
        borderOnForeground: true,
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${userVehicle.vehicle.manufacturer} ${userVehicle.vehicle.model}",
            ),
            SizedBox(height: 20),
            _buildVehiclePicture(context, userVehicle),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.calendar_month,
                        text: "${userVehicle.modelYear.toString()}.",
                        iconHint: "Godina proizvodnje",
                      ),
                      SizedBox(height: 10),
                      IconFieldWithText(
                        width: 100,

                        iconData: Icons.local_gas_station,
                        text:
                            "${userVehicle.fuelConsumption.toString()} l/100km",
                        iconHint: "Prosječna potrošnja goriva",
                      ),
                      SizedBox(height: 10),
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.money,
                        text: "${userVehicle.pricePerKm.toString()} KM/km",
                        iconHint: "Cijena po kilometru",
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.person,
                        text: userVehicle.vehicle.numberOfSeats.toString(),
                        iconHint: "Broj sjedećih mjesta",
                      ),
                      SizedBox(height: 10),
                      IconFieldWithText(
                        width: 100,
                        iconData: Icons.info,
                        text: userVehicleStatusMap[userVehicle.status]!,
                        iconHint: "Status vozila",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehiclePicture(
    BuildContext context,
    UserVehicleResponse userVehicle,
  ) {
    double imageHeight = 200;
    if (userVehicle.picture != null) {
      return Image.network(userVehicle.picture!, height: imageHeight);
    }
    return Image.asset(
      "images/vehicleFallback.png",
      height: imageHeight,
      color: context.primaryColor,
    );
  }

  Future<void> _buildVehicleUpsertDialog(
    BuildContext context,
    UserVehicleResponse? selectedVehicle,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectedVehicle != null
                  ? const Text("Uredi vozilo")
                  : const Text("Dodaj vozilo"),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.cancel),
              ),
            ],
          ),
          content: AlertDialogContent(
            errorMessageValueNotifier: _errorMessage,
            child: FormWrapper(
              formKey: _formKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildVehicleUpsertForm(context, selectedVehicle),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildVehicleUpsertForm(
    BuildContext context,
    UserVehicleResponse? selectedVehicle,
  ) {
    _userVehicleUpsertRequest = UserVehicleUpsertRequest();
    return [
      PagedDropdownFormField<
        VehicleResponse,
        int,
        VehicleProvider,
        VehicleSearchObject
      >(
        searchObject: VehicleSearchObject(),
        getLabel: (i) => i.toString(),
        getValue: (i) => i.id,
        decoration: InputDecorationWithIcon(
          iconData: Icons.directions_car_filled,
          iconHint: "Vozilo",
        ),
        onSaved: (value) => _userVehicleUpsertRequest!.vehicleId = value!.id,
        validator: (value) {
          if (value == null) return "Vozilo je obavezno!";
          return null;
        },
        initialValue: selectedVehicle?.vehicle,
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: false,
        ),
        decoration: InputDecorationWithIcon(
          iconData: Icons.calendar_month,
          iconHint: "Godina proizvodnje",
        ),
        onSaved: (value) =>
            _userVehicleUpsertRequest!.modelYear = int.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Godina proizvodnje je obavezna!";
          }
          if (int.tryParse(value) == null) {
            return "Godina proizvodnje mora biti broj!";
          }
          return null;
        },
        initialValue: selectedVehicle?.modelYear.toString(),
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        decoration: InputDecorationWithIcon(
          iconData: Icons.local_gas_station,
          iconHint: "Prosječna potrošnja goriva",
        ),
        onSaved: (value) =>
            _userVehicleUpsertRequest!.fuelConsumption = double.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Prosječna potrošnja goriva je obavezna!";
          }
          if (double.tryParse(value) == null) {
            return "Prosječna potrošnja goriva mora biti broj!";
          }
          if (double.parse(value) < 0 || double.parse(value) > 50) {
            return "Prosječna potrošnja goriva ne smije biti manja od 0, ni veća od 50!";
          }
          return null;
        },
        initialValue: selectedVehicle?.fuelConsumption.toString(),
      ),
      TextFormField(
        keyboardType: TextInputType.numberWithOptions(
          signed: true,
          decimal: true,
        ),
        decoration: InputDecorationWithIcon(
          iconData: Icons.money,
          iconHint: "Cijena po kilometru",
        ),
        onSaved: (value) =>
            _userVehicleUpsertRequest!.pricePerKm = double.parse(value!),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Cijena po kilometru je obavezna!";
          }
          if (double.tryParse(value) == null) {
            return "Cijena po kilometru mora biti broj!";
          }
          if (double.parse(value) < 0 || double.parse(value) > 10) {
            return "Cijena po kilometru ne smije biti manja od 0, ni veća od 10!";
          }
          return null;
        },
        initialValue: selectedVehicle?.pricePerKm.toString(),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () => _submitForm(selectedVehicle),
        child: selectedVehicle != null
            ? const Text("Spremi promjene")
            : const Text("Dodaj vozilo"),
      ),
    ];
  }

  Future<void> _submitForm(UserVehicleResponse? selectedVehicle) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (selectedVehicle != null) {
          var updatedItem = await _userVehicleProvider.update(
            selectedVehicle.id,
            _userVehicleUpsertRequest!,
          );
          var indexOfSelected = _userVehicles.items.indexOf(selectedVehicle);
          if (indexOfSelected != -1 && mounted) {
            setState(() {
              _userVehicles.items[indexOfSelected] = updatedItem;
            });
          }
        } else {
          var newItem = await _userVehicleProvider.insert(
            _userVehicleUpsertRequest!,
          );
          if (!mounted) return;
          if (!_userVehicles.hasMore && isDriver) {
            setState(() {
              _userVehicles.items.add(newItem);
            });
          }

          if (!isDriver) {
            var response = await GetIt.I<AuthProvider>(
              param1: LoadingType.global,
            ).getNewToken();
            await AccessTokenHandler.setAccessToken(response.token);
            var driverProfileId = await AccessTokenHandler.getProfileId(
              ProfileType.driver,
            );
            if (!mounted) return;

            setState(() {
              _profileId = driverProfileId;
              _searchObject = UserVehicleSearchObject(
                profileId: _profileId!,
                pageSize: _pageSize,
              );
            });
            var newVehicles = await _userVehicleProvider.getAll(_searchObject);
            if (!mounted) return;
            setState(() {
              newVehicles.copyTo(_userVehicles);
            });
          }
        }
        if (!mounted) return;
        Navigator.pop(context);
        Constants.messengerKey.currentState!.showSnackBar(
          SuccessSnackBar(message: "Uspješno spremljeno!"),
        );
      } on Exception catch (ex, stack) {
        _errorMessage.value = ErrorHandler.handle(ex, stack);
      }
    }
  }

  Future<void> _buildVehicleDeleteDialog(
    BuildContext context,
    UserVehicleResponse selectedVehicle,
  ) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Obriši vozilo"),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.cancel),
              ),
            ],
          ),
          content: AlertDialogContent(
            errorMessageValueNotifier: _errorMessage,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Da li ste sigurni da želite obrisati vozilo ${selectedVehicle.vehicle.toString()}?",
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Otkaži"),
                    ),
                    ElevatedButton(
                      onPressed: () => _deleteVehicle(selectedVehicle),
                      child: const Text("Obriši"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteVehicle(UserVehicleResponse selectedVehicle) async {
    try {
      await _userVehicleProvider.delete(selectedVehicle.id);
      if (!mounted) return;
      setState(() {
        _userVehicles.items.remove(selectedVehicle);
      });
      Navigator.pop(context);
      Constants.messengerKey.currentState!.showSnackBar(
        SuccessSnackBar(message: "Uspješno obrisano!"),
      );
    } on Exception catch (ex, stack) {
      _errorMessage.value = ErrorHandler.handle(ex, stack);
    }
  }
}
