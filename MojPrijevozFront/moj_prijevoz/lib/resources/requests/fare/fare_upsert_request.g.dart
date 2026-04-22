// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareUpsertRequest _$FareUpsertRequestFromJson(Map<String, dynamic> json) =>
    FareUpsertRequest(
      originCityId: (json['originCityId'] as num).toInt(),
      destinationCity: NominatimCityDto.fromJson(
        json['destinationCity'] as Map<String, dynamic>,
      ),
      length: (json['length'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      status: $enumDecode(_$FareStatusEnumMap, json['status']),
      driverId: (json['driverId'] as num).toInt(),
      passengerId: (json['passengerId'] as num).toInt(),
      fareDateTime: DateTime.parse(json['fareDateTime'] as String),
    );

Map<String, dynamic> _$FareUpsertRequestToJson(FareUpsertRequest instance) =>
    <String, dynamic>{
      'originCityId': instance.originCityId,
      'destinationCity': instance.destinationCity,
      'length': instance.length,
      'duration': instance.duration,
      'status': _$FareStatusEnumMap[instance.status]!,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'fareDateTime': instance.fareDateTime.toIso8601String(),
    };

const _$FareStatusEnumMap = {
  FareStatus.inNegotiation: 0,
  FareStatus.accepted: 1,
  FareStatus.rejected: 2,
  FareStatus.cancelled: 3,
  FareStatus.completed: 4,
  FareStatus.expired: 5,
  FareStatus.inProgress: 6,
};
