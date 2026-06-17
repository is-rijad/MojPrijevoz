import 'package:dio/dio.dart';
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
  final uiProvider = GetIt.I<UIProvider>();

  final String providerName;
  final searchResult = SearchResult<TResponse>();

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
    uiProvider.disableLoading();
    return await httpProvider.getAll<TResponse, TSearchObject>(
      providerName,
      search,
    );
  }

  void clearData(TSearchObject searchObject) {
    searchResult.items.clear();
    searchResult.hasMore = true;
    searchObject.page = 1;
  }

  Future<void> fetchData(TSearchObject searchObject) async {
    if (searchObject.page == 0 || searchObject.page == 1) {
      searchResult.items.clear();
    }
    final newItems = await _getAll(searchObject);
    newItems.copyTo(searchResult);
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

  Future<TResponse> insert(
    TInsertRequest? request, {
    FormData? formData,
  }) async {
    return await httpProvider.post<TInsertRequest, TResponse>(
      providerName,
      request,
      formData: formData,
    );
  }

  Future<TResponse> insertWithEvent(
    TInsertRequest? request, {
    FormData? formData,
  }) async {
    final newItem = await insert(request, formData: formData);
    insertLocally(newItem);
    return newItem;
  }

  void insertLocally(TResponse entity, {int? index}) {
    if (index == null) {
      searchResult.items.add(entity);
    } else {
      searchResult.items.insert(index, entity);
    }

    notifyListeners();
  }

  Future<TResponse?> update(
    int id,
    TUpdateRequest? request, {
    FormData? formData,
  }) async {
    return await httpProvider.put<TUpdateRequest, TResponse>(
      providerName,
      id,
      request,
      formData: formData,
    );
  }

  Future<TResponse?> updateWithEvent(
    int id,
    TUpdateRequest? request, {
    FormData? formData,
  }) async {
    final updatedItem = await update(id, request, formData: formData);
    if (updatedItem != null) {
      updateLocally(updatedItem);
      return updatedItem;
    }
    return null;
  }

  void updateLocally(TResponse entity) {
    final index = searchResult.items.indexOf(
      searchResult.items.firstWhere((i) => i.id == entity.id),
    );
    if (index == -1) {
      return;
    }
    searchResult.items[index] = entity;
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await httpProvider.delete(providerName, id);
  }

  Future<void> deleteWithEvent(int id) async {
    await delete(id);
    deleteLocally(id);
    notifyListeners();
  }

  void deleteLocally(int id) {
    final index = searchResult.items.indexOf(
      searchResult.items.firstWhere((i) => i.id == id),
    );
    if (index == -1) {
      return;
    }
    searchResult.items.removeAt(index);
  }
}
