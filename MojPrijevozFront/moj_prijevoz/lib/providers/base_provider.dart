import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class BaseGetProvider<
  TResponse extends JsonParsable,
  TDetailedResponse extends JsonParsable,
  TSearchObject extends BaseSearchObject
> {
  late final HttpProvider httpProvider;
  final String providerName;
  final LoadingType loadingType;

  BaseGetProvider({required this.providerName, required this.loadingType}) {
    httpProvider = GetIt.I<HttpProvider>(param1: loadingType);
  }

  Future<TDetailedResponse> getById(int id) async {
    return await httpProvider.getSingle<TDetailedResponse>(
      providerName,
      id: id,
    );
  }

  Future<SearchResult<TResponse>> getAll(TSearchObject search) async {
    return await httpProvider.getAll<TResponse, TSearchObject>(
      providerName,
      search,
    );
  }
}

abstract class BaseProvider<
  TResponse extends JsonParsable,
  TDetailedResponse extends JsonParsable,
  TSearchObject extends BaseSearchObject,
  TInsertRequest extends JsonParsable,
  TUpdateRequest extends JsonParsable
>
    extends BaseGetProvider<TResponse, TDetailedResponse, TSearchObject> {
  BaseProvider({required super.providerName, required super.loadingType});

  Future<TDetailedResponse> insert(TInsertRequest request) async {
    return await httpProvider.post<TInsertRequest, TDetailedResponse>(
      providerName,
      request,
    );
  }

  Future<TDetailedResponse> update(int id, TUpdateRequest request) async {
    return await httpProvider.put<TUpdateRequest, TDetailedResponse>(
      providerName,
      id,
      request,
    );
  }
  
  Future<void> delete(int id) async {
    await httpProvider.delete(
      providerName,
      id,
    );
  }
}
