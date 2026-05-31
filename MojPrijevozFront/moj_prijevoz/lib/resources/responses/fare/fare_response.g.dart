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
  fareOffers: (json['fareOffers'] as List<dynamic>)
      .map((e) => FareOfferResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  fareStartAfter: json['fareStartAfter'] == null
      ? null
      : DateTime.parse(json['fareStartAfter'] as String),
  userVehicleId: (json['userVehicleId'] as num).toInt(),
  userVehicle: json['userVehicle'] == null
      ? null
      : UserVehicleResponse.fromJson(
          json['userVehicle'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$FareResponseToJson(FareResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': _$FareStatusEnumMap[instance.status]!,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'fareDataId': instance.fareDataId,
      'userVehicleId': instance.userVehicleId,
      'createdAt': instance.createdAt.toIso8601String(),
      'fareStartAfter': instance.fareStartAfter?.toIso8601String(),
      'fareData': instance.fareData,
      'driver': instance.driver,
      'passenger': instance.passenger,
      'fareOffers': instance.fareOffers,
      'userVehicle': instance.userVehicle,
    };

const _$FareStatusEnumMap = {
  FareStatus.rejected: 0,
  FareStatus.inNegotiation: 1,
  FareStatus.accepted: 2,
  FareStatus.cancelled: 3,
  FareStatus.expired: 4,
  FareStatus.payed: 5,
  FareStatus.inProgress: 6,
  FareStatus.completed: 7,
};
