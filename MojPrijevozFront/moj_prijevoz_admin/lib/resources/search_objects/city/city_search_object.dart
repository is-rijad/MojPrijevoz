import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';

part 'city_search_object.g.dart';

@JsonSerializable()
class CitySearchObject extends StringSearchObject {
  CitySearchObject({
    super.contains,
    required super.page,
    required super.pageSize,
    super.orderBy,
    super.orderDirection,
  });

  factory CitySearchObject.fromJson(Map<String, dynamic> json) =>
      _$CitySearchObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CitySearchObjectToJson(this);
}
