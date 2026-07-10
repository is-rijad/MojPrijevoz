// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_transactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllTransactionsResponse _$AllTransactionsResponseFromJson(
  Map<String, dynamic> json,
) => AllTransactionsResponse(
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
  feeAmount: (json['feeAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AllTransactionsResponseToJson(
  AllTransactionsResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'fareId': instance.fareId,
  'side': _$TransactionSideEnumMap[instance.side]!,
  'amount': instance.amount,
  'feeAmount': instance.feeAmount,
  'postedAt': instance.postedAt?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'fare': instance.fare,
};

const _$TransactionSideEnumMap = {
  TransactionSide.credit: 0,
  TransactionSide.debit: 1,
};
