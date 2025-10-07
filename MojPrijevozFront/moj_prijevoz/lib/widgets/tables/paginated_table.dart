import 'package:flutter/material.dart';
import 'package:moj_prijevoz/providers/base_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:moj_prijevoz/widgets/wrappers/load_until_ready_wrapper.dart';
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
  final List<String Function(T)> items;

  final Future<void> Function(T? selectedItem)? buildUpsertDialog;
  final Future<void> Function(T selectedItem)? buildDeleteDialog;

  const PaginatedTable({
    super.key,
    this.pageSize,
    required this.searchObject,
    required this.header,
    required this.items,
    this.buildUpsertDialog,
    this.buildDeleteDialog,
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
  final _scrollController = ScrollController();

  final bool _isLoading = false;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (_isLoading || !context.read<TProvider>().searchResult.hasMore) return;

    setState(() {
      _isLoading == true;
    });
    await context.read<TProvider>().fetchData(widget.searchObject);
    if (mounted) {
      setState(() {
        _isLoading == false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadUntilReadyWrapper(buildFunction: _build, futureFunction: _init);
  }

  Future<bool> _init() async {
    await context.read<TProvider>().fetchData(widget.searchObject);
    return true;
  }

  Widget _build(BuildContext context) {
    final searchResult = context.watch<TProvider>().searchResult;
    return Flexible(
      fit: FlexFit.loose,
      child: Column(
        children: [
          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            children: [
              TableRow(
                decoration: BoxDecoration(color: Color(0xFFEFEFEF)),
                children: widget.header.map((i) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      i,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Table(
                border: TableBorder.all(color: Colors.grey.shade200),
                children: searchResult.items
                    .map((item) => _buildRow(context, item as T))
                    .toList(),
              ),
            ),
          ),

          if (searchResult.hasMore)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  TableRow _buildRow(BuildContext context, T item) {
    return TableRow(
      children: widget.items
          .map(
            (method) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => widget.buildUpsertDialog?.call(item),
                onSecondaryTap: () => widget.buildDeleteDialog?.call(item),
                onLongPress: () => widget.buildDeleteDialog?.call(item),
                child: Text(method(item), textAlign: TextAlign.center),
              ),
            ),
          )
          .toList(),
    );
  }
}
