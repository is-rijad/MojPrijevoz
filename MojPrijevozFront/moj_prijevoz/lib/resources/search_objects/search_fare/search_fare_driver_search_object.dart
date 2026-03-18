// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/resources/search_objects/search_fare/search_fare_search_object.dart';

part 'search_fare_driver_search_object.g.dart';

@JsonSerializable()
class SearchFareDriverSearchObject extends SearchFareSearchObject {
  int? profileId;
  int? userVehicleId;
  SearchFareDriverSearchObject({
    this.profileId,
    this.userVehicleId,
    super.originCityId,
    super.fareDateTime,
    super.budget,
    super.distance,
    super.duration,
    required super.page,
    required super.pageSize,
  });

  @override
  Map<String, dynamic> toJson() => _$SearchFareDriverSearchObjectToJson(this);

  factory SearchFareDriverSearchObject.fromJson(Map<String, dynamic> json) =>
      _$SearchFareDriverSearchObjectFromJson(json);
}
