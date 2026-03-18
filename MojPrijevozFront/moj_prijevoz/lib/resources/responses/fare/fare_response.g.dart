// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareResponse _$FareResponseFromJson(Map<String, dynamic> json) => FareResponse(
  id: (json['id'] as num).toInt(),
  originCityId: (json['originCityId'] as num).toInt(),
  destinationLat: json['destinationLat'] as String,
  destinationLong: json['destinationLong'] as String,
  length: (json['length'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
  status: $enumDecode(_$FareStatusEnumMap, json['status']),
  driverId: (json['driverId'] as num).toInt(),
  passengerId: (json['passengerId'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  fareDateTime: DateTime.parse(json['fareDateTime'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$FareResponseToJson(FareResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originCityId': instance.originCityId,
      'destinationLat': instance.destinationLat,
      'destinationLong': instance.destinationLong,
      'length': instance.length,
      'duration': instance.duration,
      'status': _$FareStatusEnumMap[instance.status]!,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'price': instance.price,
      'fareDateTime': instance.fareDateTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$FareStatusEnumMap = {
  FareStatus.waitingForNegotiation: 0,
  FareStatus.pending: 1,
  FareStatus.accepted: 2,
  FareStatus.rejected: 3,
  FareStatus.cancelled: 4,
  FareStatus.completed: 5,
};
