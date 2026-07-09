// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionSearchObject _$TransactionSearchObjectFromJson(
  Map<String, dynamic> json,
) => TransactionSearchObject(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  orderBy: json['orderBy'] as String?,
  orderDirection: json['orderDirection'] as String?,
);

Map<String, dynamic> _$TransactionSearchObjectToJson(
  TransactionSearchObject instance,
) => <String, dynamic>{
  'page': instance.page,
  'pageSize': instance.pageSize,
  'orderBy': instance.orderBy,
  'orderDirection': instance.orderDirection,
};
