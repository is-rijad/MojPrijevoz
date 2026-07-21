import 'package:json_annotation/json_annotation.dart';

enum ReportPeriod {
  @JsonValue(0)
  mtd,
  @JsonValue(1)
  wtd,
  @JsonValue(2)
  ytd,
  @JsonValue(3)
  custom,
}

final Map<ReportPeriod, String> reportPeriodMap = {
  ReportPeriod.mtd: "Od početka mjeseca",
  ReportPeriod.wtd: "Od početka sedmice",
  ReportPeriod.ytd: "Od početka godine",
  ReportPeriod.custom: "Datum",
};
