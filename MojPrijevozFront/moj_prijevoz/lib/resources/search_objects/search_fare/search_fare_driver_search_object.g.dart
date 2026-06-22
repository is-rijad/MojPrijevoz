// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_fare_driver_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFareDriverSearchObject _$SearchFareDriverSearchObjectFromJson(
  Map<String, dynamic> json,
) => SearchFareDriverSearchObject(
  profileId: (json['profileId'] as num?)?.toInt(),
  userVehicleId: (json['userVehicleId'] as num?)?.toInt(),
  originCityId: (json['originCityId'] as num?)?.toInt(),
  fareDateTime: json['fareDateTime'] == null
      ? null
      : DateTime.parse(json['fareDateTime'] as String),
  budget: (json['budget'] as num?)?.toDouble(),
  distance: (json['distance'] as num?)?.toDouble(),
  duration: (json['duration'] as num?)?.toDouble(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
)..driverId = (json['driverId'] as num?)?.toInt();

Map<String, dynamic> _$SearchFareDriverSearchObjectToJson(
  SearchFareDriverSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'originCityId': instance.originCityId,
  'fareDateTime': instance.fareDateTime?.toIso8601String(),
  'budget': instance.budget,
  'distance': instance.distance,
  'duration': instance.duration,
  'driverId': instance.driverId,
  'profileId': instance.profileId,
  'userVehicleId': instance.userVehicleId,
};
