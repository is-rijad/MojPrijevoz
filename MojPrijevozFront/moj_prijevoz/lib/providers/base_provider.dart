import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class BaseGetProvider<
  TResponse extends JsonParsable,
  TSearchObject extends BaseSearchObject
>
    with ChangeNotifier {
  final httpProvider = GetIt.I<HttpProvider>();
  final _uiProvider = GetIt.I<UIProvider>();

  final String providerName;
  final _searchResult = SearchResult<TResponse>();
  SearchResult<TResponse> get searchResult => _searchResult;

  BaseGetProvider({required this.providerName});

  Future<TResponse> getById(
    int id, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await httpProvider.getSingle<TResponse>(
      providerName,
      id: id,
      queryParameters: queryParameters,
    );
  }

  Future<SearchResult<TResponse>> _getAll(TSearchObject search) async {
    _uiProvider.disableLoading();
    return await httpProvider.getAll<TResponse, TSearchObject>(
      providerName,
      search,
    );
  }

  void clearData(TSearchObject searchObject) {
    _searchResult.items.clear();
    _searchResult.hasMore = true;
    searchObject.page = 1;
    notifyListeners();
  }

  Future<void> fetchData(TSearchObject searchObject) async {
    if (searchObject.page == 0 || searchObject.page == 1) {
      _searchResult.items.clear();
    }
    final newItems = await _getAll(searchObject);
    newItems.copyTo(_searchResult);
    searchObject.page++;
    notifyListeners();
  }

  Future<TResponse> getByIdWithEvent(
    int id, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await getById(id, queryParameters: queryParameters);
    notifyListeners();
    return response;
  }
}

abstract class BaseProvider<
  TResponse extends JsonResponse,
  TSearchObject extends BaseSearchObject,
  TInsertRequest extends JsonRequest,
  TUpdateRequest extends JsonRequest
>
    extends BaseGetProvider<TResponse, TSearchObject> {
  BaseProvider({required super.providerName});

  Future<TResponse> insert(TInsertRequest request) async {
    return await httpProvider.post<TInsertRequest, TResponse>(
      providerName,
      request,
    );
  }

  Future<TResponse> insertWithEvent(TInsertRequest request) async {
    final newItem = await insert(request);
    _searchResult.items.add(newItem);
    notifyListeners();
    return newItem;
  }

  Future<TResponse> update(int id, TUpdateRequest request) async {
    return await httpProvider.put<TUpdateRequest, TResponse>(
      providerName,
      id,
      request,
    );
  }

  Future<TResponse> updateWithEvent(int id, TUpdateRequest request) async {
    final updatedItem = await update(id, request);
    final index = _searchResult.items.indexOf(
      _searchResult.items.firstWhere((i) => i.id == id),
    );
    if (index == -1) {
      throw Exception("Item does not exist");
    }
    _searchResult.items[index] = updatedItem;
    notifyListeners();
    return updatedItem;
  }

  Future<void> delete(int id) async {
    await httpProvider.delete(providerName, id);
  }

  Future<void> deleteWithEvent(int id) async {
    await delete(id);
    final index = _searchResult.items.indexOf(
      _searchResult.items.firstWhere((i) => i.id == id),
    );
    if (index == -1) {
      throw Exception("Item does not exist");
    }
    _searchResult.items.removeAt(index);
    notifyListeners();
  }
}
