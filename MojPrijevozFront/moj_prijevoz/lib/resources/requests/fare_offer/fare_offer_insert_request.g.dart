// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_offer_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOfferInsertRequest _$FareOfferInsertRequestFromJson(
  Map<String, dynamic> json,
) => FareOfferInsertRequest(
  originCityId: (json['originCityId'] as num).toInt(),
  destinationCity: NominatimCityDto.fromJson(
    json['destinationCity'] as Map<String, dynamic>,
  ),
  length: (json['length'] as num).toDouble(),
  duration: (json['duration'] as num).toDouble(),
  driversPrices: (json['driversPrices'] as List<dynamic>)
      .map((e) => FareOfferDriverPriceDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  fareDateTime: DateTime.parse(json['fareDateTime'] as String),
);

Map<String, dynamic> _$FareOfferInsertRequestToJson(
  FareOfferInsertRequest instance,
) => <String, dynamic>{
  'originCityId': instance.originCityId,
  'destinationCity': instance.destinationCity.toJson(),
  'length': instance.length,
  'duration': instance.duration,
  'driversPrices': instance.driversPrices.map((e) => e.toJson()).toList(),
  'fareDateTime': instance.fareDateTime.toIso8601String(),
};
