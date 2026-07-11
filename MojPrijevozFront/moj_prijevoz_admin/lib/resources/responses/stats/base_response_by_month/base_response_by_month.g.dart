// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response_by_month.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponseByMonth _$BaseResponseByMonthFromJson(Map<String, dynamic> json) =>
    BaseResponseByMonth(
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
      result: (json['result'] as num).toDouble(),
    );

Map<String, dynamic> _$BaseResponseByMonthToJson(
  BaseResponseByMonth instance,
) => <String, dynamic>{
  'month': instance.month,
  'year': instance.year,
  'result': instance.result,
};
