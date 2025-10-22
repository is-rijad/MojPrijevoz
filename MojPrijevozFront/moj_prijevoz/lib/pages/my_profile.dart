import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/common/gender.dart';
import 'package:moj_prijevoz/resources/requests/user/update_user_request.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/widgets/dropdowns/city_paged_dropdown.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/email_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/name_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/password_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/username_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<StatefulWidget> createState() => _MyProfilState();
}

class _MyProfilState extends State<MyProfile> {
  late final UserProvider _userProvider;
  late final CityProvider _cityProvider;
  late final UserResponse _userData;
  final _formKey = GlobalKey<FormState>();
  late final CityResponse _userCity;
  final _userUpdateRequest = UpdateUserRequest();
  late final int _userId;

  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userProvider = context.read<UserProvider>();
    _cityProvider = context.read<CityProvider>();
    super.didChangeDependencies();
  }

  Future<bool> _getUserInfo() async {
    _userId = context.read<AuthProvider>().accessTokenPayload.id;
    _userData = await _userProvider.getById(_userId);
    _userCity = await _cityProvider.getById(_userData.cityId);
    return true;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _userProvider.update(_userId, _userUpdateRequest);
      _resetForm();
      Constants.messengerKey.currentState?.showSnackBar(
        SuccessSnackBar(message: "Promjene su spremljene!"),
      );
    }
  }

  void _resetForm() {
    _oldPasswordController.text = "";
    _passwordController.text = "";
    _passwordAgainController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(
      futureFunction: _getUserInfo,
      buildFunction: _build,
    );
  }

  Widget _build(BuildContext context) {
    return PageWrapper(
      body: FormWrapper(
        mainAxisAlignment: MainAxisAlignment.start,
        formKey: _formKey,
        children: [
          ..._buildPersonalData(context),
          _buildPasswords(context),
          SizedBox(height: 12),
          _buildSubmitButton(context),
        ],
      ),
      appBarTitle: const Text("Moj profil"),
    );
  }

  List<Widget> _buildPersonalData(BuildContext context) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [const Text("Lični podaci")],
      ),
      Divider(),
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [Avatar(user: _userData, maxRadius: 60)],
          ),
          SizedBox(width: 50),
          Flexible(
            child: Column(
              children: [
                NameFormField(
                  initialValue: _userData.firstName,
                  errorMessage: "Ime nije validno!",
                  onSaved: (value) => _userUpdateRequest.firstName = value,
                ),
                NameFormField(
                  initialValue: _userData.lastName,
                  errorMessage: "Prezime nije validno!",
                  onSaved: (value) => _userUpdateRequest.lastName = value,
                ),
                UsernameFormField(
                  initialValue: _userData.username,
                  onSaved: (value) => _userUpdateRequest.username = value,
                ),
                EmailFormField(
                  initialValue: _userData.email,
                  onSaved: (value) => _userUpdateRequest.email = value,
                ),
                SizedBox(height: 12),
                CityPagedDropdown(
                  onSaved: (value) => _userUpdateRequest.cityId = value!.id,
                  initialValue: _userCity,
                  validator: (value) {
                    if (value == null) {
                      return "Grad je obavezan!";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<Gender>(
                  initialValue: _userData.gender,
                  hint: const Text("Spol"),
                  items: Gender.values
                      .map(
                        (i) => DropdownMenuItem(
                          value: i,
                          child: Text(translatedGenders[i]!),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => _userUpdateRequest.gender = value,
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  Widget _buildPasswords(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Lozinka"),
        Divider(),
        Flexible(
          child: PasswordFormField(
            controller: _oldPasswordController,
            required: false,
            onSaved: (value) {
              _userUpdateRequest.oldPassword = (value?.isNotEmpty ?? false
                  ? value
                  : null);
            },
          ),
        ),
        Flexible(
          child: PasswordFormField(
            controller: _passwordController,
            required: false,
            onSaved: (value) {
              _userUpdateRequest.password = (value?.isNotEmpty ?? false
                  ? value
                  : null);
            },
          ),
        ),
        Flexible(
          child: PasswordFormField(
            controller: _passwordAgainController,
            required: false,
            onSaved: (value) {
              _userUpdateRequest.passwordAgain = (value?.isNotEmpty ?? false
                  ? value
                  : null);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: ElevatedButton(onPressed: _submitForm, child: const Text("Snimi")),
    );
  }
}
