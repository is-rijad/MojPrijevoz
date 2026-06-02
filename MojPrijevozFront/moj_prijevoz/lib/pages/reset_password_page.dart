import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/pages/home_page.dart';
import 'package:moj_prijevoz/pages/register.dart';
import 'package:moj_prijevoz/providers/auth_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/login_request.dart';
import 'package:moj_prijevoz/resources/requests/user/reset_password_request.dart';
import 'package:moj_prijevoz/widgets/buttons/primary_button.dart';
import 'package:moj_prijevoz/widgets/common_form_fields/password_form_field.dart';
import 'package:moj_prijevoz/widgets/snackbars.dart';
import 'package:moj_prijevoz/widgets/texts/text_widgets.dart';
import 'package:moj_prijevoz/widgets/wrappers/form_wrapper.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _noCodeFormKey = GlobalKey<FormState>();
  final _request = ResetPasswordRequest();
  String? code;

  @override
  Widget build(BuildContext context) {
    if (code == null) return _buildNoCodeForm();
    return _buildWithCodeForm();
  }

  Widget _buildNoCodeForm() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const TextTitleSmall("Reset lozinke")),
        body: FormWrapper(
          paddingFactor: 0,
          screenWidthFactor: 0.8,
          mainAxisAlignment: MainAxisAlignment.center,
          formKey: _noCodeFormKey,

          children: [
            const TextHeadlineSmall(
              "Da biste resetovali lozinku, unesite email.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),

            TextFormField(
              decoration: InputDecorationWithIcon(
                iconData: Icons.email,
                iconHint: "Email",
                hintText: "mujo.mujic@gmail.com",
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null ||
                    !value.isNotEmpty ||
                    (!EmailValidator.validate(value))) {
                  return "Email nije validan!";
                }
                return null;
              },
              onSaved: (value) => _request.email = value!,
            ),
            SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: PrimaryButton(
                text: "Nastavi",
                onPressed: () async => await noCodeSubmit(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> noCodeSubmit(BuildContext context) async {
    if (_noCodeFormKey.currentState?.validate() ?? true) {
      _noCodeFormKey.currentState?.save();
      final response = await context.read<UserProvider>().requestResetPassword(
        _request,
      );
      setState(() {
        code = response.code;
      });
      Constants.messengerKey.currentState!.showSnackBar(
        SuccessSnackBar(
          message: "Kod za reset lozinke je poslan na Vašu email adresu!",
        ),
      );
    }
  }

  Widget _buildWithCodeForm() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const TextTitleSmall("Reset lozinke")),
        body: FormWrapper(
          paddingFactor: 0,
          screenWidthFactor: 0.8,
          mainAxisAlignment: MainAxisAlignment.center,
          formKey: _formKey,
          children: [
            const TextHeadlineSmall(
              "Unesite kod koji ste dobili putem emaila, kao i novu lozinku.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecorationWithIcon(
                iconData: Icons.numbers,
                iconHint: "Kod",
                hintText: "12345678",
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    !value.isNotEmpty ||
                    int.tryParse(value) == null) {
                  return "Kod nije validan!";
                }
                return null;
              },
              onSaved: (value) => _request.code = value!,
            ),
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
            SizedBox(height: 20),

            FractionallySizedBox(
              widthFactor: 0.7,
              child: PrimaryButton(
                text: "Resetuj lozinku",
                onPressed: () async => await withCodeSubmit(context),
              ),
            ),
            SizedBox(height: 10),

            FractionallySizedBox(
              widthFactor: 0.7,
              child: ElevatedButton(
                child: const Text("Zatražite novi kod"),
                onPressed: () async => await noCodeSubmit(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> withCodeSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await context.read<UserProvider>().resetPassword(_request);
      Constants.messengerKey.currentState!.showSnackBar(
        SuccessSnackBar(message: "Uspješno ste resetovali lozinku!"),
      );
      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }
}
