// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_offer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOfferResponse _$FareOfferResponseFromJson(Map<String, dynamic> json) =>
    FareOfferResponse(
      id: (json['id'] as num).toInt(),
      side: $enumDecode(_$FareOfferSideEnumMap, json['side']),
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      fareId: (json['fareId'] as num).toInt(),
      lastOfferId: (json['lastOfferId'] as num?)?.toInt(),
      fare: json['fare'] == null
          ? null
          : FareResponse.fromJson(json['fare'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FareOfferResponseToJson(FareOfferResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'side': _$FareOfferSideEnumMap[instance.side]!,
      'price': instance.price,
      'createdAt': instance.createdAt.toIso8601String(),
      'fareId': instance.fareId,
      'lastOfferId': instance.lastOfferId,
      'fare': instance.fare,
    };

const _$FareOfferSideEnumMap = {
  FareOfferSide.passenger: 0,
  FareOfferSide.driver: 1,
};
