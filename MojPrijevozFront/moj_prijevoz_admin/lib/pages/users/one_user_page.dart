import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/icons/avatar.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/components/request_changes_component.dart';
import 'package:moj_prijevoz_admin/providers/request_changes_provider.dart';
import 'package:moj_prijevoz_admin/providers/users_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/request_changes/request_changes_request.dart';
import 'package:moj_prijevoz_admin/resources/requests/user/user_update_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class OneUserPage extends StatefulWidget {
  final int userId;
  const OneUserPage({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => _OneUserPageState();
}

class _OneUserPageState extends RouteAwareState<OneUserPage> {
  late UserResponse _userResponse;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dropDownStatusController = TextEditingController();

  _OneUserPageState() : super(action: DrawerMenuAction.users);
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
      appBarTitle: "Upravljanje korisnikom",
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (c, provider, _) {
        return Column(
          children: [
            _buildTopButtons(c),
            _buildUserData(),
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
    _userResponse = await context.read<UsersProvider>().getByIdWithEvent(
      widget.userId,
    );
    _dropDownStatusController.text = accountStatusMap[_userResponse.status]!;
    if (!context.mounted) return;
    context.read<RequestChangesProvider>().refresh();
    _formKey.currentState?.reset();
  }

  Widget _buildUserData() {
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
                Avatar(
                  user: _userResponse,
                  maxRadius: 50,
                  showAccountStatus: true,
                  fontSize: 10,
                ),
                TextTitleMedium(_userResponse.toString()),
                DropdownMenu<AccountStatus>(
                  controller: _dropDownStatusController,
                  onSelected: (value) => _userResponse.status = value!,
                  initialSelection: _userResponse.status,
                  label: const TextHeadlineSmall("Status"),
                  dropdownMenuEntries: accountStatusMap.entries
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
        child: RequestChangesComponent<UserResponse>(
          formKey: _formKey,
          entity: _userResponse,
        ),
      ),
    );
  }

  Future<bool> _init() async {
    _userResponse = await context.read<UsersProvider>().getById(widget.userId);
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

      await this.context.read<UsersProvider>().updateWithEvent(
        widget.userId,
        UserUpdateRequest(status: _userResponse.status),
      );
      Constants.messengerKey.currentState?.showSnackBar(
        SuccessSnackBar(message: "Status je uspješno izmijenjen!"),
      );
      if (context.mounted && !provider.isEmpty()) {
        final request = RequestChangesRequest(
          notes: provider.getNotes(),
          selectedItems: provider.getSelectedItems(),
        );
        await context.read<UsersProvider>().requestChangesWithEvent(
          widget.userId,
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
