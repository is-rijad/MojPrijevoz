import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/providers/user_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final UserProvider _userProvider = GetIt.I<UserProvider>();
  final CityProvider _cityProvider = GetIt.I<CityProvider>();

  int? cityId;
  CitySearchObject searchObject = CitySearchObject();
  List<CityResponse> cities = List.empty();

  Future<List<CityResponse>> _loadCities() async {
    return (await _cityProvider.getAll(searchObject))?.items ?? List.empty();
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
              children: [
                FutureBuilder<List<CityResponse>>(
                  future: _loadCities(),
                  builder: (context, snapshot) {
                    final cities = snapshot.data ?? List.empty();

                    return DropdownButton<int>(
                      hint: const Text("Select city"),
                      value: cityId,
                      items: cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city.id,
                              child: Text(city.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          cityId = value;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
