import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/pages/home_page.dart';
import 'package:moj_prijevoz/pages/register.dart';
import 'package:moj_prijevoz/pages/reset_password_page.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/login_request.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/password_form_field.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
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
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormWrapper(
        paddingFactor: 0,
        screenWidthFactor: 0.8,
        mainAxisAlignment: MainAxisAlignment.center,
        formKey: _formKey,
        children: [
          Image.asset("images/mojPrijevoz.png", height: 100, width: 100),
          Text(
            "Moj Prijevoz",
            style: TextStyle(
              fontFamily: "Inter",
              color: context.primaryColor,
              fontWeight: FontWeight(900),
              fontSize: 32,
            ),
          ),
          SizedBox(height: 36),
          ..._buildInputs(context),
          SizedBox(height: 36),
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
          hintText: "mujo.mujic",
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null ||
              !value.isNotEmpty ||
              (!Constants.usernameRegex.hasMatch(value) &&
                  !EmailValidator.validate(value))) {
            return "Korisničko ime ili email nije validan!";
          }
          return null;
        },
        onSaved: (value) => _loginRequest.usernameOrEmail = value!,
      ),
      PasswordFormField(
        onSaved: (value) => _loginRequest.password = value!,
        decoration: InputDecorationWithIcon(
          iconData: Icons.password,
          iconHint: "Lozinka",
          hintText: "••••••••",
        ),
      ),
    ];
  }

  List<Widget> _buildButtons(BuildContext context) {
    return <Widget>[
      Center(
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: PrimaryButton(
            onPressed: () => submitForm(context),
            text: "Prijavi se",
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
            child: const TextBodySmall("Nemate račun? Registrujte se."),
          ),
          TextButton(
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ResetPasswordPage()),
              );
            },
            child: const TextBodySmall("Zaboravili ste lozinku?"),
          ),
        ],
      ),
    ];
  }
}
