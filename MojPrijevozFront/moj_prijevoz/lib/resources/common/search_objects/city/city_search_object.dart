import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/search_objects/base_search_object.dart';

part 'city_search_object.g.dart';

@JsonSerializable()
class CitySearchObject extends BaseSearchObject {
  final String? contains;
  CitySearchObject({this.contains, super.page, super.pageSize});

  @override
  Map<String, dynamic> toJson() => _$CitySearchObjectToJson(this);
}
