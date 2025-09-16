import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/main.dart';
import 'package:moj_prijevoz/pages/register.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/requests/user/login_request.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final UserProvider _userProvider = GetIt.I<UserProvider>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  Future<void> submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var response = await _userProvider.login(
        LoginRequest(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
      if (response != null) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: response.token),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "images/mojPrijevoz.png",
                fit: BoxFit.fitWidth,
                width: 200,
                height: 200,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Korisničko ime",
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null ||
                            !value.isNotEmpty ||
                            !Constants.usernameRegex.hasMatch(value)) {
                          return "Korisničko ime nije validno!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null ||
                            !value.isNotEmpty ||
                            !Constants.passwordRegex.hasMatch(value)) {
                          return "Lozinka mora imati minimalno 8 karaktera, mala i velika slova, znakove i brojeve!";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: "Lozinka"),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Nemate račun? Registrujte se.",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                  EdgeInsets.zero,
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Zaboravili ste lozinku?",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () => submitForm(context),
                          child: const Text("Uloguj se"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
