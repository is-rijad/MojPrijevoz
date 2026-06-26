import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
import 'package:moj_prijevoz_admin/common/widgets/dropdowns/paged_dropdown.dart';

class PagedDropdownFormField<
  TAll extends JsonParsable,
  T extends TAll,
  TValue,
  TProvider extends BaseGetProvider<TAll, T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends FormField<TAll> {
  PagedDropdownFormField({
    super.key,
    required TSearchObject searchObject,
    required String Function(TAll) getLabel,
    required TValue Function(TAll) getValue,
    String? defaultLabel,
    ValueChanged<TAll>? onSelectionChanged,
    ValueChanged<TAll>? onTextChanged,
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
               PagedDropdown<TAll, T, TValue, TProvider, TSearchObject>(
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
