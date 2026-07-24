import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/orderable_search_object.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'transaction_search_object.g.dart';

@JsonSerializable()
class TransactionSearchObject extends OrderableSearchObject
    implements JsonRequest {
  int? userId;
  int? month;
  bool isPosted;
  TransactionSearchObject({
    required super.page,
    required super.pageSize,
    super.orderBy,
    super.orderDirection,
    required this.userId,
    required this.month,
    required this.isPosted,
  });

  factory TransactionSearchObject.fromJson(Map<String, dynamic> json) =>
      _$TransactionSearchObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TransactionSearchObjectToJson(this);
}
