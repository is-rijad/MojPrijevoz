import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/search_objects/base/string_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:provider/provider.dart';

abstract class BaseDropdown<
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends StatefulWidget {
  final TSearchObject searchObject;
  final String Function(T) getLabel;
  final TValue Function(T) getValue;
  final ValueChanged<T>? onSelectionChanged;
  final ValueChanged<String>? onTextChanged;
  final String? defaultLabel;
  final InputDecoration? decoration;
  final T? selectedItem;

  const BaseDropdown({
    super.key,
    required this.getLabel,
    required this.getValue,
    required this.searchObject,
    this.onSelectionChanged,
    this.defaultLabel,
    this.decoration,
    this.onTextChanged,
    this.selectedItem,
  });
}

class BaseDropdownState<
  TDropdown extends BaseDropdown<T, TValue, TProvider, TSearchObject>,
  T extends JsonParsable,
  TValue,
  TProvider extends BaseGetProvider<T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends State<TDropdown> {
  late final TSearchObject searchObject;
  final ScrollController _scrollController = ScrollController();
  final double _listElementHeight =
      Constants.autoCompleteTextInputElementHeight;
  final TextEditingController textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  T? selectedItem;

  bool isLoading = false;
  bool isOpen = false;

  bool get autoOpenDropdown =>
      throw UnimplementedError("Initialize autoOpenDropdown field in state");

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    searchObject = widget.searchObject;
    selectedItem = widget.selectedItem;
    _scrollController.addListener(_scrollListener);
    textController.text =
        widget.defaultLabel ??
        (selectedItem != null ? widget.getLabel(selectedItem!) : "");
  }

  @override
  void didUpdateWidget(covariant TDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedItem != oldWidget.selectedItem) {
      setState(() {
        selectedItem = widget.selectedItem;
        textController.text = (selectedItem != null
            ? widget.getLabel(selectedItem!)
            : "");
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      fetchPage();
    }
  }

  Future<void> fetchCleanPage() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    context.read<TProvider>().clearData(searchObject);
    await context.read<TProvider>().fetchData(searchObject);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPage() async {
    if (isLoading || !context.read<TProvider>().searchResult.hasMore) return;
    setState(() {
      isLoading = true;
    });

    await context.read<TProvider>().fetchData(searchObject);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> toggleDropdown() async {
    if (!isOpen &&
        !autoOpenDropdown &&
        (searchObject.contains?.isEmpty ?? true)) {
      return;
    }
    if (!isOpen) {
      if (selectedItem != null) {
        searchObject.contains = widget.getLabel(selectedItem!);
        await fetchCleanPage();
      }
      _overlayEntry = _createOverlay();
      if (!mounted) return;
      Overlay.of(context).insert(_overlayEntry!);
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(0);
      });
      setState(() {
        isOpen = true;
      });
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() {
        isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        final searchResult = context.watch<TProvider>().searchResult;
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => toggleDropdown(),
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height),
                child: Material(
                  elevation: 4,
                  child: SizedBox(
                    height: _listElementHeight * 4,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemExtent: _listElementHeight,
                      itemCount:
                          searchResult.items.length +
                          (searchResult.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (!isLoading && searchResult.items.isEmpty) {
                          return SizedBox.shrink();
                        }
                        if (index == searchResult.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return buildListTile(searchResult, index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ListTile buildListTile(SearchResult<T> searchResult, int index) {
    final item = searchResult.items[index];
    return ListTile(
      title: Text(widget.getLabel(item)),
      onTap: () => onSelectItem(searchResult, item),
    );
  }

  void onSelectItem(SearchResult<T> searchResult, T item) {
    widget.onTextChanged?.call(widget.getLabel(item));
    widget.onSelectionChanged?.call(item);
    toggleDropdown();
    setState(() {
      changeDropdownText(item);
      selectedItem = item;
    });
  }

  void changeDropdownText(T? item) {
    textController.text = item != null
        ? widget.getLabel(item)
        : widget.defaultLabel ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => toggleDropdown(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Constants.placeholderTextColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  onTap: () => toggleDropdown(),
                  focusNode: _focusNode,
                  onChanged: (value) => _onTextChanged(value),
                  decoration:
                      widget.decoration?.copyWith(border: InputBorder.none) ??
                      InputDecoration(border: InputBorder.none),
                ),
              ),
              buildArrowOnTextInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildArrowOnTextInput() {
    return SizedBox.shrink();
  }

  void _onTextChanged(String value) {
    widget.onTextChanged?.call(value);
    searchObject.contains = value.isNotEmpty ? value : null;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchCleanPage();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isOpen) {
          toggleDropdown();
        }
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      });
    });
  }
}
