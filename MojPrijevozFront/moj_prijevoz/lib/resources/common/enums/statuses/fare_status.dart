import 'package:json_annotation/json_annotation.dart';

enum FareStatus {
  @JsonValue(0)
  waitingForNegotiation,
  @JsonValue(1)
  pending,
  @JsonValue(2)
  accepted,
  @JsonValue(3)
  rejected,
  @JsonValue(4)
  cancelled,
  @JsonValue(5)
  completed,
}

Map<FareStatus, String> fareStatusMap = {
  FareStatus.waitingForNegotiation: "Čeka na pregovor",
  FareStatus.pending: "Na čekanju",
  FareStatus.accepted: "Prihvaćena",
  FareStatus.rejected: "Odbijena",
  FareStatus.cancelled: "Otkazana",
  FareStatus.completed: "Završena",
};
