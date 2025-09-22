import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/create_user_request.dart';
import 'package:moj_prijevoz/widgets/dropdowns/city_paged_dropdown.dart';
import 'package:moj_prijevoz/widgets/form_fields/email_form_field.dart';
import 'package:moj_prijevoz/widgets/form_fields/name_form_field.dart';
import 'package:moj_prijevoz/widgets/form_fields/password_form_field.dart';
import 'package:moj_prijevoz/widgets/form_fields/username_form_field.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _userProvider = GetIt.I<UserProvider>(param1: LoadingType.global);
  final _request = CreateUserRequest();

  @override
  Widget build(BuildContext context) {
    return FormWrapper(
      formKey: _formKey,
      appBar: AppBar(title: const Text("Registracija")),
      children: [
        ..._buildUserPersonalData(context),
        ..._buildPasswordInputs(context),
        SizedBox(height: 8),
        _buildCityDropdown(context),
        SizedBox(height: 12),
        _buildSubmitButton(context),
      ],
    );
  }

  List<Widget> _buildUserPersonalData(BuildContext context) {
    return <Widget>[
      NameFormField(
        decoration: InputDecoration(label: const Text("Ime")),
        onSaved: (value) => _request.firstName = value!,
        errorMessage: "Ime nije validno!",
      ),

      NameFormField(
        decoration: InputDecoration(label: const Text("Prezime")),
        onSaved: (value) => _request.lastName = value!,
        errorMessage: "Prezime nije validno!",
      ),
      EmailFormField(
        decoration: InputDecoration(label: const Text("Email")),
        onSaved: (value) => _request.email = value!,
      ),

      UsernameFormField(
        decoration: InputDecoration(label: const Text("Korisničko ime")),
        onSaved: (value) => _request.username = value!,
      ),
    ];
  }

  List<Widget> _buildPasswordInputs(BuildContext context) {
    return <Widget>[
      PasswordFormField(
        decoration: InputDecoration(label: const Text("Lozinka")),
        onSaved: (value) => _request.password = value!,
      ),

      PasswordFormField(
        decoration: InputDecoration(label: const Text("Ponovite lozinku")),
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
      widthFactor: 0.8,
      child: ElevatedButton(
        onPressed: _submitForm,
        child: const Text("Registruj se"),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _userProvider.insert(_request);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
