// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_fare_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFareSearchObject _$SearchFareSearchObjectFromJson(
  Map<String, dynamic> json,
) => SearchFareSearchObject(
  originCityId: (json['originCityId'] as num?)?.toInt(),
  fareDateTime: json['fareDateTime'] == null
      ? null
      : DateTime.parse(json['fareDateTime'] as String),
  budget: (json['budget'] as num?)?.toDouble(),
  distance: (json['distance'] as num?)?.toDouble(),
  duration: (json['duration'] as num?)?.toDouble(),
  driverId: (json['driverId'] as num?)?.toInt(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$SearchFareSearchObjectToJson(
  SearchFareSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'originCityId': instance.originCityId,
  'fareDateTime': instance.fareDateTime?.toIso8601String(),
  'budget': instance.budget,
  'distance': instance.distance,
  'duration': instance.duration,
  'driverId': instance.driverId,
};
