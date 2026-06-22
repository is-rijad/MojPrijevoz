import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

part 'recommended_drivers_search_object.g.dart';

@JsonSerializable()
class RecommendedDriversSearchObject extends BaseSearchObject {
  RecommendedDriversSearchObject({
    required super.page,
    required super.pageSize,
  });

  @override
  Map<String, dynamic> toJson() => _$RecommendedDriversSearchObjectToJson(this);
}
