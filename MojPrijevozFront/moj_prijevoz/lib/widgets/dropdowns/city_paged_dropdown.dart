import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/city_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/city/city_search_object.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown_form_field.dart';
import 'package:moj_prijevoz/widgets/icons/input_decoration_with_icon.dart';

class CityPagedDropdown extends StatelessWidget {
  final ValueChanged<CityResponse>? onChanged;
  final Function(CityResponse?)? onSaved;
  final String? Function(CityResponse?)? validator;
  final CityResponse? initialValue;
  const CityPagedDropdown({
    super.key,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.onSaved,
  });
  @override
  Widget build(BuildContext context) {
    return PagedDropdownFormField<
      CityResponse,
      int,
      CityProvider,
      CitySearchObject
    >(
      searchObject: CitySearchObject(),
      getLabel: (i) => i.name,
      getValue: (i) => i.id,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      decoration: InputDecorationWithIcon(
        iconData: Icons.location_city,
        iconHint: "Grad",
      ),
    );
  }
}
