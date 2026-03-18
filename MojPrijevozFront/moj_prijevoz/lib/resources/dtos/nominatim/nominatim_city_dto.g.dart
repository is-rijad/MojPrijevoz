// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nominatim_city_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NominatimCityDto _$NominatimCityDtoFromJson(Map<String, dynamic> json) =>
    NominatimCityDto(
      destinationLong: json['destinationLong'] as String,
      destinationLat: json['destinationLat'] as String,
    );

Map<String, dynamic> _$NominatimCityDtoToJson(NominatimCityDto instance) =>
    <String, dynamic>{
      'destinationLong': instance.destinationLong,
      'destinationLat': instance.destinationLat,
    };
