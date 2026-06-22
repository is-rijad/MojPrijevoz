import 'package:flutter/material.dart';
import 'package:moj_prijevoz/common/constants.dart';
import 'package:moj_prijevoz/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/common/providers/base_provider.dart';
import 'package:moj_prijevoz/common/resources/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';
import 'package:provider/provider.dart';

class ModalBottomSheet<
  T extends JsonParsable,
  TSearchObject extends BaseSearchObject,
  TProvider extends BaseGetProvider<T, TSearchObject>
>
    extends StatefulWidget {
  final TSearchObject searchObject;
  final String Function(T) getItemTitle;
  const ModalBottomSheet({
    super.key,
    required this.searchObject,
    required this.getItemTitle,
  });

  @override
  State<StatefulWidget> createState() =>
      _ModalBottomSheetState<T, TSearchObject, TProvider>();

  static Future<T> showModalSheet<
    T extends JsonParsable,
    TSearchObject extends BaseSearchObject,
    TProvider extends BaseGetProvider<T, TSearchObject>
  >(
    BuildContext context,
    TSearchObject searchObject,
    String Function(T) getItemTitle,
  ) async {
    final initialSearchResult = context.read<TProvider>().searchResult;
    final showModal = initialSearchResult.items.length > 1;
    if (showModal) {
      final response = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return ModalBottomSheet<T, TSearchObject, TProvider>(
            searchObject: searchObject,
            getItemTitle: getItemTitle,
          );
        },
      );
      if (response == null) {
        throw UserException("Morate izabrati lokaciju!");
      }
      return response as T;
    }
    if (initialSearchResult.items.isEmpty) {
      throw UserException("Nije moguće pronaći lokaciju!");
    }
    return initialSearchResult.items[0];
  }
}

class _ModalBottomSheetState<
  T extends JsonParsable,
  TSearchObject extends BaseSearchObject,
  TProvider extends BaseGetProvider<T, TSearchObject>
>
    extends State<ModalBottomSheet<T, TSearchObject, TProvider>> {
  bool _isLoading = false;

  Future<void> fetchData() async {
    if (_isLoading || !context.read<TProvider>().searchResult.hasMore) return;
    setState(() => _isLoading = true);
    await context.read<TProvider>().fetchData(widget.searchObject);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        final searchResult = context.watch<TProvider>().searchResult;

        return Container(
          decoration: BoxDecoration(
            color: context.canvasColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.secondaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 100) {
                    fetchData();
                  }
                  return false;
                },
                child: Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount:
                        searchResult.items.length +
                        (searchResult.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == searchResult.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final item = searchResult.items[index];

                      return ListTile(
                        title: Text(widget.getItemTitle.call(item)),
                        onTap: () {
                          Constants.navigatorKey.currentState?.pop(item);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
