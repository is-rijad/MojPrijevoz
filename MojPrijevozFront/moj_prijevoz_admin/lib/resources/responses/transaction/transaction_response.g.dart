// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      id: (json['id'] as num).toInt(),
      fareId: (json['fareId'] as num).toInt(),
      side: $enumDecode(_$TransactionSideEnumMap, json['side']),
      amount: (json['amount'] as num).toDouble(),
      postedAt: json['postedAt'] == null
          ? null
          : DateTime.parse(json['postedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      fare: json['fare'] == null
          ? null
          : FareResponse.fromJson(json['fare'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionResponseToJson(
  TransactionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'fareId': instance.fareId,
  'side': _$TransactionSideEnumMap[instance.side]!,
  'amount': instance.amount,
  'postedAt': instance.postedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'fare': instance.fare,
};

const _$TransactionSideEnumMap = {
  TransactionSide.credit: 0,
  TransactionSide.debit: 1,
};
