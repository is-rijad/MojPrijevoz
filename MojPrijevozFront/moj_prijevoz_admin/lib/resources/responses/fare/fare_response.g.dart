// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareResponse _$FareResponseFromJson(Map<String, dynamic> json) => FareResponse(
  id: (json['id'] as num).toInt(),
  fareDataId: (json['fareDataId'] as num).toInt(),
  fareData: json['fareData'] == null
      ? null
      : FareDataResponse.fromJson(json['fareData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$FareResponseToJson(FareResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fareDataId': instance.fareDataId,
      'fareData': instance.fareData,
    };
