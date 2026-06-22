import 'package:flutter/material.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/common/providers/base_provider.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/base_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';
import 'package:moj_prijevoz_admin/common/wrappers/load_until_ready_wrapper.dart';
import 'package:provider/provider.dart';

class PaginatedTable<
  T extends JsonResponse,
  TProvider extends BaseGetProvider,
  TSearchObject extends BaseSearchObject
>
    extends StatefulWidget {
  final int? pageSize;
  final TSearchObject searchObject;
  final List<String> header;
  final List<Widget Function(T)> items;
  final double? headingRowHeight;
  final double? dataRowMaxHeight;

  final Future<void> Function(T? selectedItem)? onTap;
  final Future<void> Function(T selectedItem)? onSecondaryOrLongPress;

  const PaginatedTable({
    super.key,
    this.pageSize,
    required this.searchObject,
    required this.header,
    required this.items,
    this.onTap,
    this.onSecondaryOrLongPress,
    this.dataRowMaxHeight,
    this.headingRowHeight,
  });

  @override
  State<StatefulWidget> createState() =>
      _PaginatedTableState<T, TProvider, TSearchObject>();
}

class _PaginatedTableState<
  T extends JsonResponse,
  TProvider extends BaseGetProvider,
  TSearchObject extends BaseSearchObject
>
    extends State<PaginatedTable<T, TProvider, TSearchObject>> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

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
    final searchResult = context.watch<TProvider>().searchResult;

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowHeight: widget.headingRowHeight ?? 56,
              dataRowMaxHeight: widget.dataRowMaxHeight ?? 56,
              columns: widget.header
                  .map(
                    (h) => DataColumn(
                      label: Text(
                        h,
                        style: TextStyle(color: context.primaryColor),
                      ),
                    ),
                  )
                  .toList(),
              rows: searchResult.items.map((item) {
                return DataRow(
                  cells: widget.items.map((method) {
                    return DataCell(
                      MouseRegion(
                        cursor: _hasClick()
                            ? SystemMouseCursors.click
                            : SystemMouseCursors.basic,
                        child: GestureDetector(
                          onTap: () => widget.onTap?.call(item),
                          onSecondaryTap: () =>
                              widget.onSecondaryOrLongPress?.call(item),
                          onLongPress: () =>
                              widget.onSecondaryOrLongPress?.call(item),
                          child: method(item as T),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  bool _hasClick() {
    return widget.onTap != null;
  }
}
