import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/dropdowns/paged_dropdown.dart';

class PagedDropdownFormField<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, T, TSearchObject>,
  TSearchObject extends BaseSearchObject
>
    extends FormField<T> {
  PagedDropdownFormField({
    super.key,
    required TSearchObject searchObject,
    required String Function(T) getLabel,
    required TValue Function(T) getValue,
    String? defaultLabel,
    T? defaultItem,
    required ValueChanged<T> onChanged,
    super.onSaved,
    super.validator,
    super.initialValue,
    InputDecoration? decoration,
    bool autovalidate = false,
  }) : super(
         autovalidateMode: autovalidate
             ? AutovalidateMode.always
             : AutovalidateMode.disabled,
         builder: (fieldState) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               PagedDropdown<T, TValue, TProvider, TSearchObject>(
                 searchObject: searchObject,
                 decoration: decoration,
                 getLabel: getLabel,
                 getValue: getValue,
                 defaultLabel: defaultLabel,
                 onChanged: (value) {
                   fieldState.didChange(value);
                   onChanged(value);
                 },
                 defaultItem: defaultItem,
               ),
               if (fieldState.errorText != null)
                 Padding(
                   padding: const EdgeInsets.only(top: 4.0),
                   child: Text(
                     fieldState.errorText!,
                     style: TextStyle(color: Colors.red[700], fontSize: 12),
                   ),
                 ),
             ],
           );
         },
       );
}
