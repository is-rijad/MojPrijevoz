// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_fare_driver_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFareDriverResponse _$SearchFareDriverResponseFromJson(
  Map<String, dynamic> json,
) => SearchFareDriverResponse(
  id: (json['id'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  additionalPrice: (json['additionalPrice'] as num?)?.toDouble(),
  vehicleId: (json['vehicleId'] as num).toInt(),
  userVehicleId: (json['userVehicleId'] as num).toInt(),
);

Map<String, dynamic> _$SearchFareDriverResponseToJson(
  SearchFareDriverResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'price': instance.price,
  'additionalPrice': instance.additionalPrice,
  'userVehicleId': instance.userVehicleId,
  'vehicleId': instance.vehicleId,
};
