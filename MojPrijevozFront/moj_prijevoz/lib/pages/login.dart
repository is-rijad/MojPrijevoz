import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/hiveDb.dart';
import 'package:moj_prijevoz/main.dart';
import 'package:moj_prijevoz/resources/requests/login_request.dart';
import 'package:moj_prijevoz/resources/responses/login_response.dart';
import 'package:moj_prijevoz/services/http_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  Future<void> submitForm() async {
    final httpService = GetIt.instance<HttpService>();
    var response = await httpService.post<LoginRequest, LoginResponse>(
      "user/login",
      LoginRequest(username: email, password: password),
    );
    if (response != null) {
      var hiveDb = await Hivedb.getInstance();
      hiveDb.put(Constants.accessTokenKey, response.token);
      var token = hiveDb.get(Constants.accessTokenKey);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(title: token!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Moj Prijevoz",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Korisničko ime",
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !Constants.usernameRegex.hasMatch(value)) {
                      return "Korisničko ime nije validno!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
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
                          onPressed: () {},
                          child: const Text(
                            "Nemate račun? Registrujte se.",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Zaboravili ste lozinku?",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: submitForm,
                      child: const Text("Uloguj se"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
