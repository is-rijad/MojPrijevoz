import 'package:json_annotation/json_annotation.dart';

enum FareStatus {
  @JsonValue(0)
  rejected,
  @JsonValue(1)
  inNegotiation,
  @JsonValue(2)
  accepted,
  @JsonValue(3)
  cancelled,
  @JsonValue(4)
  expired,
  @JsonValue(5)
  payed,
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
