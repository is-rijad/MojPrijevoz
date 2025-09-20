import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/create_user_request.dart';
import 'package:moj_prijevoz/widgets/dropdowns/city_paged_dropdown.dart';
import 'package:email_validator/email_validator.dart';
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
      TextFormField(
        keyboardType: TextInputType.name,
        decoration: InputDecoration(label: const Text("Ime")),
        validator: (value) {
          if (value == null || value.isEmpty) return "Ime nije validno!";
          return null;
        },
        onSaved: (value) => _request.firstName = value!,
      ),

      TextFormField(
        keyboardType: TextInputType.name,
        decoration: InputDecoration(label: const Text("Prezime")),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Prezime nije validno!";
          }
          return null;
        },
        onSaved: (value) => _request.lastName = value!,
      ),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(label: const Text("Email")),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              !EmailValidator.validate(value)) {
            return "Email nije validan!";
          }
          return null;
        },
        onSaved: (value) => _request.email = value!,
      ),

      TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(label: const Text("Korisničko ime")),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              !Constants.usernameRegex.hasMatch(value)) {
            return "Korisničko ime nije validno!";
          }
          return null;
        },
        onSaved: (value) => _request.username = value!,
      ),
    ];
  }

  List<Widget> _buildPasswordInputs(BuildContext context) {
    return <Widget>[
      TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(label: const Text("Lozinka")),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              !Constants.passwordRegex.hasMatch(value)) {
            return "Lozinka nije validna!";
          }
          return null;
        },
        onSaved: (value) => _request.password = value!,
      ),

      TextFormField(
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(label: const Text("Ponovite lozinku")),
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              !Constants.passwordRegex.hasMatch(value)) {
            return "Lozinka nije validna!";
          }
          return null;
        },
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
