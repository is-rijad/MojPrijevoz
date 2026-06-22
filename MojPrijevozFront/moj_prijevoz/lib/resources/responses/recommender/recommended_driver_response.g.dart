// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_driver_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendedDriverResponse _$RecommendedDriverResponseFromJson(
  Map<String, dynamic> json,
) => RecommendedDriverResponse(
  originCityName: json['originCityName'] as String,
  destinationName: json['destinationName'] as String,
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  picture: json['picture'] as String?,
  averageRating: (json['averageRating'] as num).toDouble(),
  ridesCount: (json['ridesCount'] as num).toInt(),
  status: $enumDecode(_$AccountStatusEnumMap, json['status']),
);

Map<String, dynamic> _$RecommendedDriverResponseToJson(
  RecommendedDriverResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'picture': instance.picture,
  'status': _$AccountStatusEnumMap[instance.status]!,
  'averageRating': instance.averageRating,
  'originCityName': instance.originCityName,
  'destinationName': instance.destinationName,
  'ridesCount': instance.ridesCount,
};

const _$AccountStatusEnumMap = {
  AccountStatus.banned: 0,
  AccountStatus.active: 1,
  AccountStatus.waitingForChanges: 2,
  AccountStatus.waitingForReview: 3,
};
