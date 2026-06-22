import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/search_objects/base/string_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/common/widgets/dropdowns/base_dropdown.dart';

class PagedDropdown<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends BaseDropdown<T, TValue, TProvider, TSearchObject> {
  const PagedDropdown({
    super.key,
    required super.getLabel,
    required super.getValue,
    required super.searchObject,
    super.onSelectionChanged,
    super.defaultLabel,
    super.decoration,
    super.selectedItem,
  });

  @override
  State<BaseDropdown> createState() =>
      _PagedDropdownState<T, TValue, TProvider, TSearchObject>();
}

class _PagedDropdownState<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends
        BaseDropdownState<
          PagedDropdown<T, TValue, TProvider, TSearchObject>,
          T,
          TValue,
          TProvider,
          TSearchObject
        > {
  @override
  bool get autoOpenDropdown => true;

  @override
  void initState() {
    super.initState();
    changeDropdownText(selectedItem);
  }

  @override
  Future<void> toggleDropdown() async {
    if (selectedItem != null) {
      changeDropdownText(selectedItem);
    }
    await super.toggleDropdown();
    await fetchCleanPage();
  }

  @override
  ListTile buildListTile(SearchResult<T> searchResult, int index) {
    final item = searchResult.items[index];
    return ListTile(
      selected: selectedItem != null
          ? widget.getValue(item) == widget.getValue(selectedItem!)
          : false,
      title: Text(widget.getLabel(item)),
      onTap: () => onSelectItem(searchResult, item),
    );
  }

  @override
  Widget buildArrowOnTextInput() {
    return !isOpen
        ? Icon(Icons.keyboard_arrow_down)
        : Icon(Icons.keyboard_arrow_up);
  }
}
