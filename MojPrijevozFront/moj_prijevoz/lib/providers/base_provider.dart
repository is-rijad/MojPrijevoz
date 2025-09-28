import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/providers/ui_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class BaseGetProvider<
  TResponse extends JsonResponse,
  TDetailedResponse extends JsonResponse,
  TSearchObject extends BaseSearchObject
> {
  final _httpProvider = GetIt.I<HttpProvider>();
  final _uiProvider = GetIt.I<UIProvider>();

  final String providerName;

  BaseGetProvider({required this.providerName});

  Future<TDetailedResponse> getById(int id) async {
    return await _httpProvider.getSingle<TDetailedResponse>(
      providerName,
      id: id,
    );
  }

  Future<SearchResult<TResponse>> getAll(TSearchObject search) async {
    _uiProvider.disableLoading();
    return await _httpProvider.getAll<TResponse, TSearchObject>(
      providerName,
      search,
    );
  }
}

abstract class BaseProvider<
  TResponse extends JsonResponse,
  TDetailedResponse extends JsonResponse,
  TSearchObject extends BaseSearchObject,
  TInsertRequest extends JsonRequest,
  TUpdateRequest extends JsonRequest
>
    extends BaseGetProvider<TResponse, TDetailedResponse, TSearchObject> {
  BaseProvider({required super.providerName});

  Future<TDetailedResponse> insert(TInsertRequest request) async {
    return await _httpProvider.post<TInsertRequest, TDetailedResponse>(
      providerName,
      request,
    );
  }

  Future<TDetailedResponse> update(int id, TUpdateRequest request) async {
    return await _httpProvider.put<TUpdateRequest, TDetailedResponse>(
      providerName,
      id,
      request,
    );
  }

  Future<void> delete(int id) async {
    await _httpProvider.delete(providerName, id);
  }
}
