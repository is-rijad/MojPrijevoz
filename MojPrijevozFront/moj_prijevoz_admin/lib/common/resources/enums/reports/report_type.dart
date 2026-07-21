import 'package:json_annotation/json_annotation.dart';

enum ReportType {
  @JsonValue(0)
  registeredUsers,
  @JsonValue(1)
  fares,
}

final Map<ReportType, String> reportTypeMap = {
  ReportType.registeredUsers: "Registrovani korisnici",
  ReportType.fares: "Sve vožnje",
};
