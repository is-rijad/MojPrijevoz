import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/orderable_search_object.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';
import 'package:moj_prijevoz_admin/common/widgets/icons/input_decoration_with_icon.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class PaginatedTable<
  TAll extends JsonResponse,
  T extends TAll,
  TProvider extends BaseGetProvider<TAll, T, TSearchObject>,
  TSearchObject extends OrderableSearchObject
>
    extends StatefulWidget {
  final int? pageSize;
  final TSearchObject searchObject;
  final Map<String, String?> header;
  final List<Widget Function(TAll)> items;
  final double? headingRowHeight;
  final double? dataRowHeight;

  final Future<void> Function(TAll? selectedItem)? onTap;
  final Future<void> Function(TAll selectedItem)? onSecondaryOrLongPress;

  const PaginatedTable({
    super.key,
    this.pageSize,
    required this.searchObject,
    required this.header,
    required this.items,
    this.onTap,
    this.onSecondaryOrLongPress,
    this.dataRowHeight,
    this.headingRowHeight,
  });

  @override
  State<StatefulWidget> createState() =>
      _PaginatedTableState<TAll, T, TProvider, TSearchObject>();
}

class _PaginatedTableState<
  TAll extends JsonResponse,
  T extends TAll,
  TProvider extends BaseGetProvider<TAll, T, TSearchObject>,
  TSearchObject extends OrderableSearchObject
>
    extends State<PaginatedTable<TAll, T, TProvider, TSearchObject>> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _fetchData();
    }
  }

  Future<void> _onSort(String field, int index, bool ascending) async {
    setState(() {
      _sortColumnIndex = index;
      _sortAscending = ascending;
    });
    widget.searchObject.orderBy = field;
    widget.searchObject.orderDirection = ascending ? "asc" : "desc";
    context.read<TProvider>().clearData(widget.searchObject);
    await _fetchData();
  }

  Future<void> _onSearch(String value) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      setState(() {
        _sortColumnIndex = null;
      });
      if (widget.searchObject is! StringSearchObject) return;
      setState(() => _sortColumnIndex = null);
      (widget.searchObject as StringSearchObject).contains = value;
      context.read<TProvider>().clearData(widget.searchObject);
      await _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final provider = context.read<TProvider>();
    if (_isLoading || !provider.searchResult.hasMore) return;

    setState(() {
      _isLoading = true;
    });

    await provider.fetchData(widget.searchObject);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _init() async {
    await context.read<TProvider>().fetchData(widget.searchObject);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Widget _build(BuildContext context) {
    return Consumer<TProvider>(
      builder: (context, value, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 10,
                  children: [
                    if (widget.searchObject is StringSearchObject)
                      TextField(
                        onChanged: _onSearch,
                        decoration: InputDecorationWithIcon(
                          iconData: Icons.search,
                          iconHint: "Pretražite",
                          hintText: "Pretražite...",
                        ),
                      ),
                    Expanded(
                      child: DataTable2(
                        sortColumnIndex: _sortColumnIndex,
                        sortAscending: _sortAscending,
                        scrollController: _scrollController,
                        headingRowHeight: widget.headingRowHeight ?? 56,
                        dataRowHeight: widget.dataRowHeight ?? 56,
                        border: TableBorder.all(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        columns: widget.header.entries
                            .map(
                              (h) => DataColumn(
                                label: Text(
                                  h.key,
                                  style: TextStyle(color: context.primaryColor),
                                ),
                                onSort: h.value != null
                                    ? (columnIndex, ascending) => _onSort(
                                        h.value!,
                                        columnIndex,
                                        ascending,
                                      )
                                    : null,
                              ),
                            )
                            .toList(),
                        rows: value.searchResult.items.map((item) {
                          return DataRow(
                            cells: widget.items.map((method) {
                              return DataCell(
                                MouseRegion(
                                  cursor: _hasClick()
                                      ? SystemMouseCursors.click
                                      : SystemMouseCursors.basic,
                                  child: GestureDetector(
                                    onTap: () => widget.onTap?.call(item),
                                    onSecondaryTap: () => widget
                                        .onSecondaryOrLongPress
                                        ?.call(item),
                                    onLongPress: () => widget
                                        .onSecondaryOrLongPress
                                        ?.call(item),
                                    child: method(item),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _hasClick() {
    return widget.onTap != null;
  }
}
