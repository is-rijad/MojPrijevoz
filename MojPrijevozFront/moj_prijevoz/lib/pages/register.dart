import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/create_user_request.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/dropdowns/city_paged_dropdown.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/email_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/name_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/password_form_field.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/username_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _request = CreateUserRequest();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const TextTitleSmall("Registracija")),
        body: FormWrapper(
          paddingFactor: 0,
          screenWidthFactor: 0.8,
          mainAxisAlignment: MainAxisAlignment.center,
          formKey: _formKey,
          children: [
            ..._buildUserPersonalData(context),
            ..._buildPasswordInputs(context),
            SizedBox(height: 8),
            _buildCityDropdown(context),
            SizedBox(height: 36),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUserPersonalData(BuildContext context) {
    return <Widget>[
      NameFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.person,
          iconHint: "Ime",
          hintText: "Mujo",
        ),
        onSaved: (value) => _request.firstName = value!,
        errorMessage: "Ime nije validno!",
      ),

      NameFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.person,
          iconHint: "Prezime",
          hintText: "Mujić",
        ),
        onSaved: (value) => _request.lastName = value!,
        errorMessage: "Prezime nije validno!",
      ),
      EmailFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.email,
          iconHint: "Email",
          hintText: "mujo@gmail.com",
        ),
        onSaved: (value) => _request.email = value!,
      ),

      UsernameFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.person,
          iconHint: "Korisničko ime",
          hintText: "mujo.mujic",
        ),
        onSaved: (value) => _request.username = value!,
      ),
      InternationalPhoneNumberInput(
        countries: ["BA"],
        inputDecoration: InputDecorationWithIcon(
          iconData: Icons.phone,
          iconHint: "Broj mobitela",
          hintText: "61123456",
        ),
        hintText: null,
        errorMessage: "Broj mobitela nije validan",
        onInputChanged: (value) => _request.phoneNumber = value.phoneNumber,
      ),
    ];
  }

  List<Widget> _buildPasswordInputs(BuildContext context) {
    return <Widget>[
      PasswordFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.password,
          iconHint: "Lozinka",
          hintText: "••••••••",
        ),
        onSaved: (value) => _request.password = value!,
      ),

      PasswordFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.password,
          iconHint: "Ponovite lozinku",
          hintText: "••••••••",
        ),
        onSaved: (value) => _request.passwordAgain = value!,
      ),
    ];
  }

  Widget _buildCityDropdown(BuildContext context) {
    return CityPagedDropdown(
      onChanged: (value) => _request.cityId = value.id,
      validator: (value) {
        if (value == null) {
          return "Grad je obavezan!";
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: PrimaryButton(onPressed: _submitForm, text: "Registruj se"),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<UserProvider>().insert(_request);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
