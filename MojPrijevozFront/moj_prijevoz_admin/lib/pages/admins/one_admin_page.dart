import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/constants.dart';
import 'package:moj_prijevoz_admin/common/drawer_menu_action.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/administrator_role.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/common/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz_admin/common/widgets/common_form_fields/email_form_field.dart';
import 'package:moj_prijevoz_admin/common/widgets/common_form_fields/name_form_field.dart';
import 'package:moj_prijevoz_admin/common/widgets/common_form_fields/username_form_field.dart';
import 'package:moj_prijevoz_admin/common/widgets/dialogs/confirmation_dialog.dart';
import 'package:moj_prijevoz_admin/common/widgets/snackbars.dart';
import 'package:moj_prijevoz_admin/common/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz_admin/providers/administrator_provider.dart';
import 'package:moj_prijevoz_admin/resources/requests/administrator/administrator_upsert_request.dart';
import 'package:moj_prijevoz_admin/resources/responses/administrator/administrator_response.dart';
import 'package:moj_prijevoz_admin/widgets/states/route_aware_state.dart';
import 'package:moj_prijevoz_admin/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class OneAdminPage extends StatefulWidget {
  final int? userId;
  const OneAdminPage({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => _OneAdminPageState();
}

class _OneAdminPageState extends RouteAwareState<OneAdminPage> {
  late AdministratorResponse _administratorResponse;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _statusController = TextEditingController();
  final _roleController = TextEditingController();

  _OneAdminPageState() : super(action: DrawerMenuAction.admins);
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
      appBarTitle: "Upravljanje administratorom",
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<AdministratorProvider>(
      builder: (c, provider, _) {
        return Column(
          spacing: 10,
          children: [_buildTopButtons(c), _buildAdminData(), _buildButtons(c)],
        );
      },
    );
  }

  @override
  void dispose() {
    _statusController.dispose();
    _roleController.dispose();
    super.dispose();
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
            onPressed: widget.userId != null
                ? () async => await _deleteAdmin(context)
                : null,
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future _refreshForm(BuildContext context) async {
    _formKey.currentState?.reset();
    _statusController.text = accountStatusMap[_administratorResponse.status]!;
    _roleController.text =
        administratorRoleFieldMap[_administratorResponse.role]!;
  }

  Widget _buildAdminData() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.4,
          vertical: 12,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              ..._buildPersonalData(context),
              DropdownMenu<AccountStatus>(
                width: context.screenWidth * 0.2,
                controller: _statusController,
                onSelected: (value) => _administratorResponse.status = value!,
                initialSelection: _administratorResponse.status,
                label: const TextHeadlineSmall("Status"),
                dropdownMenuEntries: accountStatusMap.entries
                    .where(
                      (it) =>
                          it.key == AccountStatus.active ||
                          it.key == AccountStatus.banned,
                    )
                    .map(
                      (it) => DropdownMenuEntry(value: it.key, label: it.value),
                    )
                    .toList(),
              ),
              DropdownMenu<AdministartorRole>(
                width: context.screenWidth * 0.2,
                controller: _roleController,
                onSelected: (value) => _administratorResponse.role = value!,
                initialSelection: _administratorResponse.role,
                label: const TextHeadlineSmall("Uloga"),
                dropdownMenuEntries: administratorRoleFieldMap.entries
                    .map(
                      (it) => DropdownMenuEntry(value: it.key, label: it.value),
                    )
                    .toList(),
              ),
              if (widget.userId != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Checkbox(
                      value: _administratorResponse.changePassword ?? false,
                      onChanged: (value) => setState(() {
                        _administratorResponse.changePassword = value!;
                      }),
                    ),
                    const TextLabelLarge("Izmjena šifre?"),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPersonalData(BuildContext context) {
    return <Widget>[
      NameFormField(
        initialValue: _administratorResponse.firstName,
        decoration: InputDecoration(hintText: "Mujo"),
        onSaved: (value) => _administratorResponse.firstName = value!,
        errorMessage: "Ime nije validno!",
      ),

      NameFormField(
        initialValue: _administratorResponse.lastName,

        decoration: InputDecoration(hintText: "Mujić"),
        onSaved: (value) => _administratorResponse.lastName = value!,
        errorMessage: "Prezime nije validno!",
      ),
      EmailFormField(
        initialValue: _administratorResponse.email,

        decoration: InputDecoration(hintText: "mujo@gmail.com"),
        onSaved: (value) => _administratorResponse.email = value!,
      ),

      UsernameFormField(
        initialValue: _administratorResponse.username,

        decoration: InputDecoration(hintText: "mujo.mujic"),
        onSaved: (value) => _administratorResponse.username = value!,
      ),
    ];
  }

  Future<bool> _init() async {
    if (widget.userId != null) {
      _administratorResponse = await context
          .read<AdministratorProvider>()
          .getById(widget.userId!);
    } else {
      _administratorResponse = AdministratorResponse(
        id: -1,
        firstName: "",
        lastName: "",
        role: AdministartorRole.moderator,
        email: '',
        username: '',
        status: AccountStatus.active,
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
              _formKey.currentState?.save();
              if (widget.userId != null) {
                await context.read<AdministratorProvider>().updateWithEvent(
                  widget.userId!,
                  AdministratorUpsertRequest(
                    email: _administratorResponse.email,
                    firstName: _administratorResponse.firstName,
                    lastName: _administratorResponse.lastName,
                    username: _administratorResponse.username,
                    changePassword:
                        _administratorResponse.changePassword ?? false,
                    role: _administratorResponse.role,
                    status: _administratorResponse.status,
                  ),
                );
              } else {
                await context.read<AdministratorProvider>().insertWithEvent(
                  AdministratorUpsertRequest(
                    email: _administratorResponse.email,
                    firstName: _administratorResponse.firstName,
                    lastName: _administratorResponse.lastName,
                    username: _administratorResponse.username,
                    changePassword:
                        _administratorResponse.changePassword ?? false,
                    role: _administratorResponse.role,
                    status: _administratorResponse.status,
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

  Future _deleteAdmin(BuildContext context) async {
    final isDone = await showDialog<bool?>(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          content: "Da li ste sigurni da želite ukloniti administratora?",
          onSubmit: () async {
            await context.read<AdministratorProvider>().deleteWithEvent(
              widget.userId!,
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
