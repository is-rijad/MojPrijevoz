import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/user_vehicle_status.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/components/request_changes_component.dart';
import 'package:moj_prijevoz_admin/providers/request_changes_provider.dart';
import 'package:moj_prijevoz_admin/providers/user_vehicles_provider.dart';
import 'package:moj_prijevoz_admin/providers/users_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/request_changes/request_changes_request.dart';
import 'package:moj_prijevoz_admin/resources/requests/user_vehicle/user_vehicle_update_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class OneUserVehiclePage extends StatefulWidget {
  final int userVehicleId;
  const OneUserVehiclePage({super.key, required this.userVehicleId});

  @override
  State<StatefulWidget> createState() => _OneUserVehiclePageState();
}

class _OneUserVehiclePageState extends RouteAwareState<OneUserVehiclePage> {
  late UserVehicleResponse _userVehicleResponse;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dropDownStatusController = TextEditingController();

  _OneUserVehiclePageState() : super(action: DrawerMenuAction.userVehicles);
  @override
  Widget build(BuildContext context_) {
    return ChangeNotifierProvider(
      create: (_) => RequestChangesProvider(),
      builder: (context, _) => LoadUntilReadyWrapper(
        buildFunction: (_) => _build(context),
        futureFunction: _init,
      ),
    );
  }

  @override
  void dispose() {
    _dropDownStatusController.dispose();
    super.dispose();
  }

  Widget _build(BuildContext context) {
    return PageWrapper(
      body: _buildBody(context),
      appBarTitle: "Upravljanje korisnikovim vozilom",
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (c, provider, _) {
        return Column(
          children: [
            _buildTopButtons(c),
            _buildUserVehicleData(),
            _buildRequestChanges(),
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
        ],
      ),
    );
  }

  Future _refreshForm(BuildContext context) async {
    _userVehicleResponse = await context
        .read<UserVehiclesProvider>()
        .getByIdWithEvent(widget.userVehicleId);
    _dropDownStatusController.text =
        userVehicleStatusMap[_userVehicleResponse.status]!;
    if (!context.mounted) return;
    context.read<RequestChangesProvider>().refresh();
    _formKey.currentState?.reset();
  }

  Widget _buildUserVehicleData() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Constants.placeholderTextColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: _userVehicleResponse.picture != null
                      ? Image.network(
                          _userVehicleResponse.picture!,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                "images/vehiclePlaceholder.png",
                                fit: BoxFit.fill,
                              ),
                        )
                      : Image.asset(
                          "images/vehiclePlaceholder.png",
                          fit: BoxFit.fill,
                        ),
                ),
                TextTitleMedium(_userVehicleResponse.toString()),
                DropdownMenu<UserVehicleStatus>(
                  controller: _dropDownStatusController,
                  onSelected: (value) => _userVehicleResponse.status = value!,
                  initialSelection: _userVehicleResponse.status,
                  label: const TextHeadlineSmall("Status"),
                  dropdownMenuEntries: userVehicleStatusMap.entries
                      .map(
                        (it) =>
                            DropdownMenuEntry(value: it.key, label: it.value),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestChanges() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: context.screenHeight * 0.4,
        child: RequestChangesComponent<UserVehicleResponse>(
          formKey: _formKey,
          entity: _userVehicleResponse,
        ),
      ),
    );
  }

  Future<bool> _init() async {
    _userVehicleResponse = await context.read<UserVehiclesProvider>().getById(
      widget.userVehicleId,
    );
    return true;
  }

  Widget _buildButtons(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    if (_formKey.currentState?.validate() ?? false) {
      final provider = context.read<RequestChangesProvider>();

      await this.context.read<UserVehiclesProvider>().updateWithEvent(
        widget.userVehicleId,
        UserVehicleUpdateRequest(status: _userVehicleResponse.status),
      );
      Constants.messengerKey.currentState?.showSnackBar(
        SuccessSnackBar(message: "Status je uspješno izmijenjen!"),
      );
      if (context.mounted && !provider.isEmpty()) {
        final request = RequestChangesRequest(
          notes: provider.getNotes(),
          selectedItems: provider.getSelectedItems(),
        );
        await context.read<UserVehiclesProvider>().requestChangesWithEvent(
          widget.userVehicleId,
          request,
        );

        Constants.messengerKey.currentState?.showSnackBar(
          SuccessSnackBar(message: "Uspješno ste zatražili izmjene!"),
        );
      }
    }
    if (context.mounted) {
      Constants.navigatorKey.currentState?.pop();
    }
  }
}
