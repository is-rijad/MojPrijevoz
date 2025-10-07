import 'package:flutter/material.dart';
import 'package:moj_prijevoz/components/map/map_component.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/wrappers/page_wrapper.dart';

class MapPage extends StatefulWidget {
  final CityResponse to;

  const MapPage({super.key, required this.to});

  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _formKey = GlobalKey<FormState>();
  CityResponse? from;
  CityResponse? to;

  @override
  void initState() {
    to = widget.to;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(body: _build(context));
  }

  Widget _build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child:
                      PagedDropdownFormField<
                        CityResponse,
                        int,
                        CityProvider,
                        CitySearchObject
                      >(
                        getLabel: (i) => i.name,
                        getValue: (i) => i.id,
                        searchObject: CitySearchObject(page: 1, pageSize: 5),
                        onSaved: (newValue) => setState(() {
                          from = newValue;
                        }),
                      ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child:
                      PagedDropdownFormField<
                        CityResponse,
                        int,
                        CityProvider,
                        CitySearchObject
                      >(
                        getLabel: (i) => i.name,
                        getValue: (i) => i.id,
                        searchObject: CitySearchObject(page: 1, pageSize: 5),
                        onSaved: (newValue) => setState(() {
                          to = newValue;
                        }),
                        initialValue: to,
                      ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                  },
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        ),

        MapComponent(from: from, to: to),
      ],
    );
  }
}
