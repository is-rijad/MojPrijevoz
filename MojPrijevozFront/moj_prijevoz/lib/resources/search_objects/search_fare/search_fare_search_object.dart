import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

part 'search_fare_search_object.g.dart';

@JsonSerializable()
class SearchFareSearchObject extends BaseSearchObject {
  int? originCityId;
  DateTime? fareDateTime;
  double? budget;
  double? distance;
  double? duration;

  SearchFareSearchObject({
    this.originCityId,
    this.fareDateTime,
    this.budget,
    this.distance,
    this.duration,
    required super.page,
    required super.pageSize,
  });

  @override
  Map<String, dynamic> toJson() => _$SearchFareSearchObjectToJson(this);

  factory SearchFareSearchObject.fromJson(Map<String, dynamic> json) =>
      _$SearchFareSearchObjectFromJson(json);
}
