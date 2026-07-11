// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fares_this_month_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaresThisMonthResponse _$FaresThisMonthResponseFromJson(
  Map<String, dynamic> json,
) => FaresThisMonthResponse(
  status: $enumDecode(_$FareStatusEnumMap, json['status']),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$FaresThisMonthResponseToJson(
  FaresThisMonthResponse instance,
) => <String, dynamic>{
  'status': _$FareStatusEnumMap[instance.status]!,
  'count': instance.count,
};

const _$FareStatusEnumMap = {
  FareStatus.rejected: 0,
  FareStatus.accepted: 1,
  FareStatus.inNegotiation: 2,
  FareStatus.expired: 3,
  FareStatus.payed: 4,
  FareStatus.cancelled: 5,
  FareStatus.inProgress: 6,
  FareStatus.completed: 7,
};
