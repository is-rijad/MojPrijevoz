// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_offer_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOfferUpdateRequest _$FareOfferUpdateRequestFromJson(
  Map<String, dynamic> json,
) => FareOfferUpdateRequest(
  price: (json['price'] as num?)?.toDouble(),
  additionalPrice: (json['additionalPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$FareOfferUpdateRequestToJson(
  FareOfferUpdateRequest instance,
) => <String, dynamic>{
  'price': instance.price,
  'additionalPrice': instance.additionalPrice,
};
