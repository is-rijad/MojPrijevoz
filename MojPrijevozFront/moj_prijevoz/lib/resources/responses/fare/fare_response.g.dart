// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareResponse _$FareResponseFromJson(Map<String, dynamic> json) => FareResponse(
  id: (json['id'] as num).toInt(),
  status: $enumDecode(_$FareStatusEnumMap, json['status']),
  driverId: (json['driverId'] as num).toInt(),
  passengerId: (json['passengerId'] as num).toInt(),
  fareDataId: (json['fareDataId'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  fareData: json['fareData'] == null
      ? null
      : FareDataResponse.fromJson(json['fareData'] as Map<String, dynamic>),
  driver: json['driver'] == null
      ? null
      : UserProfileResponse.fromJson(json['driver'] as Map<String, dynamic>),
  passenger: json['passenger'] == null
      ? null
      : UserProfileResponse.fromJson(json['passenger'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FareResponseToJson(FareResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$FareStatusEnumMap[instance.status]!,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'fareDataId': instance.fareDataId,
      'createdAt': instance.createdAt.toIso8601String(),
      'fareData': instance.fareData,
      'driver': instance.driver,
      'passenger': instance.passenger,
    };

const _$FareStatusEnumMap = {
  FareStatus.waitingForNegotiation: 0,
  FareStatus.pending: 1,
  FareStatus.accepted: 2,
  FareStatus.rejected: 3,
  FareStatus.cancelled: 4,
  FareStatus.completed: 5,
};
