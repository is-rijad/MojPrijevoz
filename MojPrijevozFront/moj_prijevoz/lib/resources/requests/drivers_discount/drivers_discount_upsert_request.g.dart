// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drivers_discount_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriversDiscountUpsertRequest _$DriversDiscountUpsertRequestFromJson(
  Map<String, dynamic> json,
) => DriversDiscountUpsertRequest(
  minKm: (json['minKm'] as num).toDouble(),
  maxKm: (json['maxKm'] as num?)?.toDouble(),
  discount: (json['discount'] as num).toDouble(),
);

Map<String, dynamic> _$DriversDiscountUpsertRequestToJson(
  DriversDiscountUpsertRequest instance,
) => <String, dynamic>{
  'minKm': instance.minKm,
  'maxKm': instance.maxKm,
  'discount': instance.discount,
};
