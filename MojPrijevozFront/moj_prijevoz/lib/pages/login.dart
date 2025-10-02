import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/pages/home_page.dart';
import 'package:moj_prijevoz/pages/register.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/login_request.dart';
import 'package:moj_prijevoz/widgets/form_fields/password_form_field.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _loginRequest = LoginRequest();

  LoginPage({super.key});

  Future<void> submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<AuthProvider>().login(_loginRequest);
      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormWrapper(
        mainAxisAlignment: MainAxisAlignment.center,
        formKey: _formKey,
        children: [
          Image.asset(
            "images/mojPrijevoz.png",
            fit: BoxFit.fitWidth,
            width: 200,
            height: 200,
          ),
          ..._buildInputs(context),
          SizedBox(height: 12),
          ..._buildButtons(context),
        ],
      ),
    );
  }

  List<Widget> _buildInputs(BuildContext context) {
    return <Widget>[
      TextFormField(
        decoration: InputDecorationWithIcon(
          iconData: Icons.person,
          iconHint: "Korisničko ime ili email",
        ),
        keyboardType: TextInputType.text,
        validator: (value) {
          if (value == null ||
              !value.isNotEmpty ||
              (!Constants.usernameRegex.hasMatch(value) &&
                  !EmailValidator.validate(value))) {
            return "Korisničko ime ili email nije validan!";
          }
          return null;
        },
        onSaved: (value) => _loginRequest.username = value!,
      ),
      PasswordFormField(
        onSaved: (value) => _loginRequest.password = value!,
        decoration: InputDecorationWithIcon(
          iconData: Icons.password,
          iconHint: "Lozinka",
        ),
      ),
    ];
  }

  List<Widget> _buildButtons(BuildContext context) {
    return <Widget>[
      Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: ElevatedButton(
            onPressed: () => submitForm(context),
            child: const Text("Uloguj se"),
          ),
        ),
      ),
      SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            child: const Text(
              "Nemate račun? Registrujte se.",
              style: TextStyle(fontSize: 12),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            onPressed: () {},
            child: const Text(
              "Zaboravili ste lozinku?",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    ];
  }
}
