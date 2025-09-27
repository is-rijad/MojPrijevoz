import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/string_search_object.dart';

part 'city_search_object.g.dart';

@JsonSerializable()
class CitySearchObject extends StringSearchObject {
  CitySearchObject({
    super.contains,
    required super.page,
    required super.pageSize,
  });

  @override
  Map<String, dynamic> toJson() => _$CitySearchObjectToJson(this);
}
