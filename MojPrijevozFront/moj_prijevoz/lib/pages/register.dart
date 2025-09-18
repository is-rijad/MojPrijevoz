import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/widgets/paged_dropdown.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PagedDropdown<
                  CityResponse,
                  int,
                  CityProvider,
                  CitySearchObject
                >(
                  searchObject: CitySearchObject(),
                  getLabel: (i) => i.name,
                  defaultLabel: "Grad",
                  onChanged: (value) => print(value.name),
                  getValue: (i) => i.id,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
