// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenerateReportRequest _$GenerateReportRequestFromJson(
  Map<String, dynamic> json,
) =>
    GenerateReportRequest(
        type: $enumDecodeNullable(_$ReportTypeEnumMap, json['type']),
        period: $enumDecodeNullable(_$ReportPeriodEnumMap, json['period']),
      )
      ..from = json['from'] == null
          ? null
          : DateTime.parse(json['from'] as String)
      ..to = json['to'] == null ? null : DateTime.parse(json['to'] as String);

Map<String, dynamic> _$GenerateReportRequestToJson(
  GenerateReportRequest instance,
) => <String, dynamic>{
  'type': _$ReportTypeEnumMap[instance.type],
  'period': _$ReportPeriodEnumMap[instance.period],
  'from': instance.from?.toIso8601String(),
  'to': instance.to?.toIso8601String(),
};

const _$ReportTypeEnumMap = {
  ReportType.registeredUsers: 0,
  ReportType.fares: 1,
};

const _$ReportPeriodEnumMap = {
  ReportPeriod.mtd: 0,
  ReportPeriod.wtd: 1,
  ReportPeriod.ytd: 2,
  ReportPeriod.custom: 3,
};
