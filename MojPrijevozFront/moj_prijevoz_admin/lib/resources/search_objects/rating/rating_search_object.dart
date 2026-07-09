import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';

part 'rating_search_object.g.dart';

@JsonSerializable()
class RatingSearchObject extends StringSearchObject {
  RatingSearchObject({
    required super.page,
    required super.pageSize,
    super.contains,
    super.orderBy,
    super.orderDirection,
  });

  factory RatingSearchObject.fromJson(Map<String, dynamic> json) =>
      _$RatingSearchObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RatingSearchObjectToJson(this);
}
