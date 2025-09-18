import 'package:get_it/get_it.dart';
import 'package:moj_prijevoz/common/loading_type.dart';
import 'package:moj_prijevoz/providers/http_provider.dart';
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';
import 'package:moj_prijevoz/resources/common/search_result.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

abstract class BaseGetProvider<
  TGetResponse extends JsonParsable,
  TGetAllResponse extends JsonParsable,
  TSearchObject extends BaseSearchObject
> {
  late final HttpProvider httpProvider;
  final String providerName;
  final LoadingType loadingType;

  BaseGetProvider({required this.providerName, required this.loadingType}) {
    httpProvider = GetIt.I<HttpProvider>(param1: loadingType);
  }

  Future<TGetResponse> getById(int id) async {
    return await httpProvider.getById<TGetResponse>(id, providerName);
  }

  Future<SearchResult<TGetResponse>> getAll(TSearchObject search) async {
    return await httpProvider.get<TGetResponse, TSearchObject>(
      providerName,
      search,
    );
  }
}

abstract class BaseProvider<
  TGetResponse extends JsonParsable,
  TGetAllResponse extends JsonParsable,
  TSearchObject extends BaseSearchObject,
  TInsertRequest extends JsonParsable,
  TInsertResponse,
  TUpdateRequest extends JsonParsable,
  TUpdateResponse
>
    extends BaseGetProvider<TGetResponse, TGetAllResponse, TSearchObject> {
  BaseProvider({required super.providerName, required super.loadingType});

  Future<TInsertResponse> insert(TInsertRequest request) async {
    return await httpProvider.post<TInsertRequest, TInsertResponse>(
      providerName,
      request,
    );
  }
}
