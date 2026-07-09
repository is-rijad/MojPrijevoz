import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/user_exception.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/components/map/map_component.dart';
import 'package:moj_prijevoz_admin/providers/city_provider.dart';
import 'package:moj_prijevoz_admin/providers/map_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/city/city_upsert_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class OneCityPage extends StatefulWidget {
  final int? cityId;
  const OneCityPage({super.key, required this.cityId});

  @override
  State<StatefulWidget> createState() => _OneCityPageState();
}

class _OneCityPageState extends RouteAwareState<OneCityPage> {
  late CityResponse _cityResponse;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _cityNameController = TextEditingController();

  _OneCityPageState() : super(action: DrawerMenuAction.cities);
  @override
  Widget build(BuildContext context_) {
    return LoadUntilReadyWrapper(
      buildFunction: (context) => _build(context),
      futureFunction: _init,
    );
  }

  Widget _build(BuildContext context) {
    return PageWrapper(
      body: _buildBody(context),
      appBarTitle: "Upravljanje gradom",
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<CityProvider>(
      builder: (c, provider, _) {
        return Column(
          spacing: 10,
          children: [_buildTopButtons(c), _buildCityData(), _buildButtons(c)],
        );
      },
    );
  }

  Widget _buildTopButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async => await _refreshForm(context),
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: widget.cityId != null
                ? () async => await _deleteCity(context)
                : null,
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future _refreshForm(BuildContext context) async {
    _formKey.currentState?.reset();
    _cityNameController.clear();
    setState(() {
      GetIt.I<MapProvider>().reset();
    });
    if (!context.mounted) return;
  }

  Widget _buildCityData() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.2,
          vertical: 12,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 30,
                children: [
                  TextFormField(
                    controller: _cityNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Naziv je obavezan!";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: 500,
                    height: 250,
                    child: MapComponent(location: _cityResponse),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _init() async {
    if (widget.cityId != null) {
      _cityResponse = await context.read<CityProvider>().getById(
        widget.cityId!,
      );
      _cityNameController.text = _cityResponse.name;
    } else {
      _cityResponse = CityResponse(
        id: -1,
        name: "",
        lat: "43.9894986",
        long: "18.1816434",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    return true;
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: context.screenWidth * 0.4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          ElevatedButton(
            onPressed: () => Constants.navigatorKey.currentState?.pop(),
            child: const Text("Otkaži"),
          ),
          PrimaryButton(
            onPressed: () async => await _onSubmit(context),
            text: "Spremi",
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Future _onSubmit(BuildContext context) async {
    final isDone = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: "Da li ste sigurni da želite spremiti promjene?",
          onSubmit: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final selectedLocation = GetIt.I<MapProvider>().selectedLocation;
              if (selectedLocation == null) {
                throw UserException("Lokacija na mapi je obavezna!");
              }
              if (widget.cityId != null) {
                await context.read<CityProvider>().updateWithEvent(
                  widget.cityId!,
                  CityUpsertRequest(
                    name: _cityNameController.text,
                    lat: selectedLocation.latitude.toStringAsFixed(6),
                    long: selectedLocation.longitude.toStringAsFixed(6),
                  ),
                );
              } else {
                await context.read<CityProvider>().insertWithEvent(
                  CityUpsertRequest(
                    name: _cityNameController.text,
                    lat: selectedLocation.latitude.toStringAsFixed(6),
                    long: selectedLocation.longitude.toStringAsFixed(6),
                  ),
                );
              }

              Constants.messengerKey.currentState?.showSnackBar(
                SuccessSnackBar(message: "Promjene su uspješno spremljene!"),
              );
              Constants.navigatorKey.currentState?.pop(true);
            } else {
              Constants.navigatorKey.currentState?.pop(false);
            }
          },
        );
      },
    );
    if (isDone ?? false) {
      Constants.navigatorKey.currentState?.pop();
    }
  }

  Future _deleteCity(BuildContext context) async {
    final isDone = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: "Da li ste sigurni da želite obrisati grad?",
          onSubmit: () async {
            await context.read<CityProvider>().deleteWithEvent(widget.cityId!);

            Constants.messengerKey.currentState?.showSnackBar(
              SuccessSnackBar(message: "Promjene su uspješno spremljene!"),
            );

            if (context.mounted) {
              Constants.navigatorKey.currentState?.pop(true);
            }
          },
        );
      },
    );
    if (isDone ?? false) {
      Constants.navigatorKey.currentState?.pop();
    }
  }
}
