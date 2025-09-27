// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drivers_discount_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriversDiscountResponse _$DriversDiscountResponseFromJson(
  Map<String, dynamic> json,
) => DriversDiscountResponse(
  id: (json['id'] as num).toInt(),
  minKm: (json['minKm'] as num).toDouble(),
  maxKm: (json['maxKm'] as num?)?.toDouble(),
  discount: (json['discount'] as num).toDouble(),
);

Map<String, dynamic> _$DriversDiscountResponseToJson(
  DriversDiscountResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'minKm': instance.minKm,
  'maxKm': instance.maxKm,
  'discount': instance.discount,
};
