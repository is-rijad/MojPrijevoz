import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/common/resources/search_objects/string_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/texts/autocomplete/autocomplete_text_input.dart';

class AutocompleteTextInputFormField<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends FormField<T> {
  AutocompleteTextInputFormField({
    super.key,
    required TSearchObject searchObject,
    required String Function(T) getLabel,
    required TValue Function(T) getValue,
    String? defaultLabel,
    ValueChanged<T>? onSelectionChanged,
    ValueChanged<String>? onTextChanged,
    super.initialValue,
    super.onSaved,
    super.validator,
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
               AutocompleteTextInput<T, TValue, TProvider, TSearchObject>(
                 searchObject: searchObject,
                 decoration: decoration,
                 getLabel: getLabel,
                 getValue: getValue,
                 defaultLabel: defaultLabel,
                 onTextChanged: onTextChanged,
                 selectedItem: initialValue,
                 onSelectionChanged: (value) {
                   fieldState.didChange(value);
                   onSelectionChanged?.call(value);
                 },
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
