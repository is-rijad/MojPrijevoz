// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_offer_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareOfferSearchObject _$FareOfferSearchObjectFromJson(
  Map<String, dynamic> json,
) => FareOfferSearchObject(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$FareOfferSearchObjectToJson(
  FareOfferSearchObject instance,
) => <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};
