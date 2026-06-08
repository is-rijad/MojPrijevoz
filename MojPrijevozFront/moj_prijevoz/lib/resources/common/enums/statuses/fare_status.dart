import 'package:json_annotation/json_annotation.dart';

enum FareStatus {
  @JsonValue(0)
  rejected,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  inNegotiation,
  @JsonValue(3)
  expired,
  @JsonValue(4)
  payed,
  @JsonValue(5)
  cancelled,
  @JsonValue(6)
  inProgress,
  @JsonValue(7)
  completed,
}

Map<FareStatus, String> fareStatusMap = {
  FareStatus.inNegotiation: "U pregovorima",
  FareStatus.accepted: "Prihvaćena",
  FareStatus.rejected: "Odbijena",
  FareStatus.cancelled: "Otkazana",
  FareStatus.completed: "Završena",
  FareStatus.expired: "Istekla",
  FareStatus.inProgress: "U toku",
};
