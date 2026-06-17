import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/image_picker_provider.dart';
import 'package:moj_prijevoz/providers/user_profile_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/requests/user/update_user_request.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/dropdowns/city_paged_dropdown.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/email_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/name_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/password_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/username_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/avatar.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
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

  late final int _userProfileId;

  late final UserProfileProvider _userProfileProvider;

  late final UserProfileResponse _userProfile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userProvider = context.read<UserProvider>();
    _cityProvider = context.read<CityProvider>();
    _userProfileProvider = context.read<UserProfileProvider>();
    super.didChangeDependencies();
  }

  Future<bool> _getUserInfo() async {
    _userId = context.read<AuthProvider>().accessTokenPayload.id;
    _userProfileId = (await context.read<AuthProvider>().getProfileId(
      ProfileType.passenger,
    ))!;
    _userData = await _userProvider.getById(_userId);
    _userCity = await _cityProvider.getById(_userData.cityId);
    _userProfile = await _userProfileProvider.getById(_userProfileId);
    return true;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FormData formData = FormData.fromMap({
        ..._userUpdateRequest.toJson(),
        "picture": _userUpdateRequest.picture,
      });
      await _userProvider.update(_userId, null, formData: formData);
      if (!mounted) return;
      await context.read<AuthProvider>().getNewToken();
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
        paddingFactor: 0,
        screenWidthFactor: 0.8,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        formKey: _formKey,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              decoration: BoxDecoration(
                color: context.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              width: context.screenWidth * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextLabelLarge("Broj vožnji"),
                  TextLabelLarge(_userProfile.numberOfFares.toString()),
                ],
              ),
            ),
          ),
          _buildProfilePicture(context),
          ..._buildPersonalData(context),
          SizedBox(height: 24),
          ..._buildPasswords(context),
          SizedBox(height: 36),
          _buildSubmitButton(context),
        ],
      ),
      appBarTitle: "Moj profil",
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () async => await _onPickImage(),
      child: Stack(
        children: [
          Avatar(
            user: _userData,
            maxRadius: 50,
            fontSize: 10,
            showAccountStatus: true,
          ),
          Positioned(
            width: 25,
            right: 0,
            top: 0,
            child: Image.asset("images/editImage.png"),
          ),
        ],
      ),
    );
  }

  Future<void> _onPickImage() async {
    final file = await GetIt.I<ImagePickerProvider>().pickImage();
    if (file != null) {
      _userUpdateRequest.picture = file["picture"];
      setState(() {
        _userData.imagePreview = file["file"];
      });
    }
  }

  List<Widget> _buildPersonalData(BuildContext context) {
    return [
      Flexible(
        child: NameFormField(
          decoration: InputDecorationWithIcon(
            iconData: Icons.person,
            iconHint: "Ime",
          ),
          initialValue: _userData.firstName,
          errorMessage: "Ime nije validno!",
          onSaved: (value) => _userUpdateRequest.firstName = value,
        ),
      ),
      Flexible(
        child: NameFormField(
          decoration: InputDecorationWithIcon(
            iconData: Icons.person,
            iconHint: "Prezime",
          ),
          initialValue: _userData.lastName,
          errorMessage: "Prezime nije validno!",
          onSaved: (value) => _userUpdateRequest.lastName = value,
        ),
      ),
      Flexible(
        child: EmailFormField(
          decoration: InputDecorationWithIcon(
            iconData: Icons.email,
            iconHint: "Email",
          ),
          initialValue: _userData.email,
          onSaved: (value) => _userUpdateRequest.email = value,
        ),
      ),
      Flexible(
        child: UsernameFormField(
          decoration: InputDecorationWithIcon(
            iconData: Icons.person,
            iconHint: "Korisničko ime",
          ),
          initialValue: _userData.username,
          onSaved: (value) => _userUpdateRequest.username = value,
        ),
      ),

      SizedBox(height: 12),
      Flexible(
        child: CityPagedDropdown(
          onSaved: (value) => _userUpdateRequest.cityId = value!.id,
          initialValue: _userCity,
          validator: (value) {
            if (value == null) {
              return "Grad je obavezan!";
            }
            return null;
          },
        ),
      ),
    ];
  }

  List<Widget> _buildPasswords(BuildContext context) {
    return [
      Flexible(
        child: PasswordFormField(
          decoration: InputDecorationWithIcon(
            iconData: Icons.password,
            iconHint: "Stara lozinka",
            hintText: "Stara lozinka",
          ),
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
          decoration: InputDecorationWithIcon(
            iconData: Icons.password,
            iconHint: "Nova lozinka",
            hintText: "Nova lozinka",
          ),
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
          decoration: InputDecorationWithIcon(
            iconData: Icons.password,
            iconHint: "Potvrda lozinke",
            hintText: "Potvrda lozinke",
          ),
          controller: _passwordAgainController,
          required: false,
          onSaved: (value) {
            _userUpdateRequest.passwordAgain = (value?.isNotEmpty ?? false
                ? value
                : null);
          },
        ),
      ),
    ];
  }

  Widget _buildSubmitButton(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: PrimaryButton(onPressed: _submitForm, text: "Snimi"),
    );
  }
}
