// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_offer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOfferResponse _$FareOfferResponseFromJson(Map<String, dynamic> json) =>
    FareOfferResponse(
      id: (json['id'] as num).toInt(),
      side: $enumDecode(_$FareOfferSideEnumMap, json['side']),
      status: $enumDecode(_$FareOfferStatusEnumMap, json['status']),
      price: (json['price'] as num).toDouble(),
      additionalPrice: (json['additionalPrice'] as num?)?.toDouble(),
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
      'status': _$FareOfferStatusEnumMap[instance.status]!,
      'price': instance.price,
      'additionalPrice': instance.additionalPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'fareId': instance.fareId,
      'lastOfferId': instance.lastOfferId,
      'fare': instance.fare,
    };

const _$FareOfferSideEnumMap = {
  FareOfferSide.passenger: 0,
  FareOfferSide.driver: 1,
};

const _$FareOfferStatusEnumMap = {
  FareOfferStatus.rejected: 0,
  FareOfferStatus.accepted: 1,
  FareOfferStatus.waitingForResponse: 2,
};
