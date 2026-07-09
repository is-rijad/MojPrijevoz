import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/orderable_search_object.dart';

part 'transaction_search_object.g.dart';

@JsonSerializable()
class TransactionSearchObject extends OrderableSearchObject {
  TransactionSearchObject({
    required super.page,
    required super.pageSize,
    super.orderBy,
    super.orderDirection,
  });

  factory TransactionSearchObject.fromJson(Map<String, dynamic> json) =>
      _$TransactionSearchObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionSearchObjectToJson(this);
}
