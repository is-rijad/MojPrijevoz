import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/base/string_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/dropdowns/base_dropdown.dart';

class AutocompleteTextInput<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends BaseDropdown<T, TValue, TProvider, TSearchObject> {
  const AutocompleteTextInput({
    super.key,
    required super.getLabel,
    required super.getValue,
    required super.searchObject,
    super.onSelectionChanged,
    super.onTextChanged,
    super.defaultLabel,
    super.decoration,
    super.selectedItem,
  });

  @override
  State<BaseDropdown> createState() =>
      _AutocompleteTextInputState<T, TValue, TProvider, TSearchObject>();
}

class _AutocompleteTextInputState<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends
        BaseDropdownState<
          AutocompleteTextInput<T, TValue, TProvider, TSearchObject>,
          T,
          TValue,
          TProvider,
          TSearchObject
        > {
  @override
  bool get autoOpenDropdown => false;
}
