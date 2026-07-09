import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/providers/vehicles_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/vehicle/vehicle_upsert_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/vehicle_response.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class OneVehiclePage extends StatefulWidget {
  final int? vehicleId;
  const OneVehiclePage({super.key, required this.vehicleId});

  @override
  State<StatefulWidget> createState() => _OneVehiclePageState();
}

class _OneVehiclePageState extends RouteAwareState<OneVehiclePage> {
  late VehicleResponse _vehicleResponse;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _OneVehiclePageState() : super(action: DrawerMenuAction.vehicles);
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
      appBarTitle: "Upravljanje vozilom",
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<VehiclesProvider>(
      builder: (c, provider, _) {
        return Column(
          spacing: 10,
          children: [
            _buildTopButtons(c),
            _buildVehicleData(),
            _buildButtons(c),
          ],
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
            onPressed: widget.vehicleId != null
                ? () async => await _deleteVehicle(context)
                : null,
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future _refreshForm(BuildContext context) async {
    _formKey.currentState?.reset();
    if (!context.mounted) return;
  }

  Widget _buildVehicleData() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.4,
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
                    initialValue: _vehicleResponse.manufacturer,

                    onSaved: (newValue) =>
                        _vehicleResponse.manufacturer = newValue!,
                    decoration: InputDecoration(
                      label: const TextHeadlineSmall("Proizvođač"),
                    ),
                  ),
                  TextFormField(
                    initialValue: _vehicleResponse.model,
                    onSaved: (newValue) => _vehicleResponse.model = newValue!,
                    decoration: InputDecoration(
                      label: const TextHeadlineSmall("Model"),
                    ),
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
    if (widget.vehicleId != null) {
      _vehicleResponse = await context.read<VehiclesProvider>().getById(
        widget.vehicleId!,
      );
    } else {
      _vehicleResponse = VehicleResponse(
        id: -1,
        manufacturer: "",
        model: "",
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
              if (widget.vehicleId != null) {
                await context.read<VehiclesProvider>().updateWithEvent(
                  widget.vehicleId!,
                  VehicleUpsertRequest(
                    manufacturer: _vehicleResponse.manufacturer,
                    model: _vehicleResponse.model,
                  ),
                );
              } else {
                await context.read<VehiclesProvider>().insertWithEvent(
                  VehicleUpsertRequest(
                    manufacturer: _vehicleResponse.manufacturer,
                    model: _vehicleResponse.model,
                  ),
                );
              }

              Constants.messengerKey.currentState?.showSnackBar(
                SuccessSnackBar(message: "Promjene su uspješno spremljene!"),
              );
            }
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

  Future _deleteVehicle(BuildContext context) async {
    final isDone = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: "Da li ste sigurni da želite obrisati vozilo?",
          onSubmit: () async {
            await context.read<VehiclesProvider>().deleteWithEvent(
              widget.vehicleId!,
            );

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
