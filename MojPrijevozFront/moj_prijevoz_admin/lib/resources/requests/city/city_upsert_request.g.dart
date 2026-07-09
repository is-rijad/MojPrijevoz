// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityUpsertRequest _$CityUpsertRequestFromJson(Map<String, dynamic> json) =>
    CityUpsertRequest(
      name: json['name'] as String?,
      lat: json['lat'] as String?,
      long: json['long'] as String?,
    );

Map<String, dynamic> _$CityUpsertRequestToJson(CityUpsertRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lat': instance.lat,
      'long': instance.long,
    };
