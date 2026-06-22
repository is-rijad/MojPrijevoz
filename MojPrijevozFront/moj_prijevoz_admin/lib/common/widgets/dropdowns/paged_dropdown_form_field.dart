import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
import 'package:moj_prijevoz_admin/common/widgets/dropdowns/paged_dropdown.dart';

class PagedDropdownFormField<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends FormField<T> {
  PagedDropdownFormField({
    super.key,
    required TSearchObject searchObject,
    required String Function(T) getLabel,
    required TValue Function(T) getValue,
    String? defaultLabel,
    ValueChanged<T>? onSelectionChanged,
    ValueChanged<T>? onTextChanged,
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
                 onSelectionChanged: (value) {
                   fieldState.didChange(value);
                   onSelectionChanged?.call(value);
                 },
                 selectedItem: initialValue,
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
