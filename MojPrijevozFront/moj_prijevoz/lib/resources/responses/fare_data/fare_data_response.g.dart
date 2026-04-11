// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareDataResponse _$FareDataResponseFromJson(Map<String, dynamic> json) =>
    FareDataResponse(
      id: (json['id'] as num).toInt(),
      originCityId: (json['originCityId'] as num).toInt(),
      destinationLat: json['destinationLat'] as String,
      destinationLong: json['destinationLong'] as String,
      length: (json['length'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      fareDateTime: DateTime.parse(json['fareDateTime'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      destinationName: json['destinationName'] as String,
      stopPoints: (json['stopPoints'] as List<dynamic>?)
          ?.map((e) => StopPointResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      originCity: json['originCity'] == null
          ? null
          : CityResponse.fromJson(json['originCity'] as Map<String, dynamic>),
      fareOffers: (json['fareOffers'] as List<dynamic>?)
          ?.map((e) => FareOfferResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FareDataResponseToJson(FareDataResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'originCityId': instance.originCityId,
      'destinationLat': instance.destinationLat,
      'destinationLong': instance.destinationLong,
      'length': instance.length,
      'duration': instance.duration,
      'fareDateTime': instance.fareDateTime.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'destinationName': instance.destinationName,
      'originCity': instance.originCity,
      'stopPoints': instance.stopPoints,
      'fareOffers': instance.fareOffers,
    };
