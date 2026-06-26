import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/search_result.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
import 'package:moj_prijevoz_admin/common/widgets/dropdowns/base_dropdown.dart';

class PagedDropdown<
  TAll extends JsonParsable,
  T extends TAll,
  TValue,
  TProvider extends BaseGetProvider<TAll, T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends BaseDropdown<TAll, T, TValue, TProvider, TSearchObject> {
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
      _PagedDropdownState<TAll, T, TValue, TProvider, TSearchObject>();
}

class _PagedDropdownState<
  TAll extends JsonParsable,
  T extends TAll,
  TValue,
  TProvider extends BaseGetProvider<TAll, T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends
        BaseDropdownState<
          PagedDropdown<TAll, T, TValue, TProvider, TSearchObject>,
          TAll,
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
  ListTile buildListTile(SearchResult<TAll> searchResult, int index) {
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
