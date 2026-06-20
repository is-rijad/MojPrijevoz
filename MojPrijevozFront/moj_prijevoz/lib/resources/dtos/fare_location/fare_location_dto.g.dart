// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareLocationDto _$FareLocationDtoFromJson(Map<String, dynamic> json) =>
    FareLocationDto(
      userId: (json['userId'] as num).toInt(),
      lat: json['lat'] as String,
      lon: json['lon'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      isAccurate: json['isAccurate'] as bool,
    );

Map<String, dynamic> _$FareLocationDtoToJson(FareLocationDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'lat': instance.lat,
      'lon': instance.lon,
      'dateTime': instance.dateTime.toIso8601String(),
      'isAccurate': instance.isAccurate,
    };
