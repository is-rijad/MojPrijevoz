// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drivers_discount_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriversDiscountSearchObject _$DriversDiscountSearchObjectFromJson(
  Map<String, dynamic> json,
) => DriversDiscountSearchObject(
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$DriversDiscountSearchObjectToJson(
  DriversDiscountSearchObject instance,
) => <String, dynamic>{'page': instance.page, 'pageSize': instance.pageSize};
