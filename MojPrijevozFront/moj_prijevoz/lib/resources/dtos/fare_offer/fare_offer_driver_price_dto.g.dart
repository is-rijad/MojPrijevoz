// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_offer_driver_price_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOfferDriverPriceDto _$FareOfferDriverPriceDtoFromJson(
  Map<String, dynamic> json,
) => FareOfferDriverPriceDto(
  userVehicleId: (json['userVehicleId'] as num).toInt(),
  driverId: (json['driverId'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  additionalPrice: (json['additionalPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FareOfferDriverPriceDtoToJson(
  FareOfferDriverPriceDto instance,
) => <String, dynamic>{
  'driverId': instance.driverId,
  'userVehicleId': instance.userVehicleId,
  'price': instance.price,
  'additionalPrice': instance.additionalPrice,
};
