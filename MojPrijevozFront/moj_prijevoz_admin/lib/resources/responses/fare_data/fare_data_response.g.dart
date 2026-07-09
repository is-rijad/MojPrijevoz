// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareDataResponse _$FareDataResponseFromJson(Map<String, dynamic> json) =>
    FareDataResponse(
      id: (json['id'] as num).toInt(),
      destinationName: json['destinationName'] as String,
      originCity: json['originCity'] == null
          ? null
          : CityResponse.fromJson(json['originCity'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FareDataResponseToJson(FareDataResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'destinationName': instance.destinationName,
      'originCity': instance.originCity,
    };
