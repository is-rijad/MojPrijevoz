import 'package:json_annotation/json_annotation.dart';

enum FareStatus {
  @JsonValue(0)
  inNegotiation,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  rejected,
  @JsonValue(3)
  cancelled,
  @JsonValue(4)
  completed,
  @JsonValue(5)
  expired,
  @JsonValue(6)
  inProgress,
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
