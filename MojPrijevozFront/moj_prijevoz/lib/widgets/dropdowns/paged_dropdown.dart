import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/resources/search_objects/base/string_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

class PagedDropdown<
  T extends JsonResponse,
  TValue,
  TProvider extends BaseGetProvider<T, T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends StatefulWidget {
  final TSearchObject searchObject;
  final String Function(T) getLabel;
  final TValue Function(T) getValue;
  final ValueChanged<T>? onChanged;
  final String? defaultLabel;
  final InputDecoration? decoration;
  final T? defaultItem;

  const PagedDropdown({
    super.key,
    required this.getLabel,
    required this.getValue,
    required this.searchObject,
    this.onChanged,
    this.defaultLabel,
    this.decoration,
    this.defaultItem,
  });

  @override
  State<PagedDropdown> createState() =>
      _PagedDropdownState<T, TValue, TProvider, TSearchObject>();
}

class _PagedDropdownState<
  T extends JsonResponse,
  TValue,
  TProvider extends BaseGetProvider<T, T, TSearchObject>,
  TSearchObject extends StringSearchObject
>
    extends State<PagedDropdown<T, TValue, TProvider, TSearchObject>> {
  late final TProvider _provider;
  late final TSearchObject _searchObject;
  final _searchResult = SearchResult<T>();
  final ScrollController _scrollController = ScrollController();
  final double _listElementHeight = 50;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  T? selectedItem;

  bool _isLoading = false;

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _provider = GetIt.I<TProvider>();
    _searchObject = widget.searchObject;
    _scrollController.addListener(_scrollListener);
    _changeSelectedItem(widget.defaultItem);
    _changeDropdownText(selectedItem);
    _fetchPage();
  }

  void _scrollToSelected() {
    if (_scrollController.hasClients && selectedItem != null) {
      try {
        _scrollController.animateTo(
          _listElementHeight *
              _searchResult.items.indexOf(
                _searchResult.items.firstWhere(
                  (i) => widget.getValue(i) == widget.getValue(selectedItem!),
                ),
              ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } on StateError {
        _scrollController.jumpTo(0);
      }
    } else {
      _scrollController.jumpTo(0);
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
      _fetchPage();
    }
  }

  Future<void> _fetchPage() async {
    if (_isLoading || !_searchResult.hasMore) return;

    setState(() {
      _isLoading = true;
    });
    final result = await _provider.getAll(_searchObject);
    if (!mounted) return;

    setState(() {
      result.copyTo(_searchResult);
      _searchObject.page++;
      _isLoading = false;
    });

    _overlayEntry?.markNeedsBuild();
  }

  void _toggleDropdown() {
    if (selectedItem != null) {
      _changeDropdownText(selectedItem);
    }
    if (_overlayEntry == null) {
      if (selectedItem != null) {
        _searchObject.contains = widget.getLabel(selectedItem!);
        _searchResult.items.clear();
        _searchResult.hasMore = true;
        _searchObject.page = 1;
        _fetchPage();
      }
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
      if (!_focusNode.hasFocus) {
        _focusNode.requestFocus();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected();
      });
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleDropdown,
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
                  height: 200,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemExtent: _listElementHeight,
                    itemCount:
                        _searchResult.items.length +
                        (_searchResult.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_searchResult.items.isEmpty) {
                        return SizedBox.shrink();
                      }
                      if (index == _searchResult.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final item = _searchResult.items[index];
                      return ListTile(
                        selected: selectedItem != null
                            ? widget.getValue(item) ==
                                  widget.getValue(selectedItem!)
                            : false,
                        title: Text(widget.getLabel(item)),
                        onTap: () {
                          widget.onChanged?.call(item);
                          _toggleDropdown();
                          setState(() {
                            _changeSelectedItem(item);
                            _changeDropdownText(item);
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _changeSelectedItem(T? item) {
    selectedItem = item;
  }

  void _changeDropdownText(T? item) {
    _textController.text = item != null
        ? widget.getLabel(item)
        : widget.defaultLabel ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onTap: _toggleDropdown,
                  focusNode: _focusNode,
                  onChanged: _onTextChanged,
                  decoration:
                      widget.decoration?.copyWith(border: InputBorder.none) ??
                      InputDecoration(border: InputBorder.none),
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  void _onTextChanged(String value) {
    _searchObject.contains = value.isNotEmpty ? value : null;
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchResult.items.clear();
      _searchResult.hasMore = true;
      _searchObject.page = 1;
      _fetchPage();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_overlayEntry == null) {
          _toggleDropdown();
        }
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
        _scrollController.jumpTo(0);
      });
    });
  }
}
