import 'package:json_annotation/json_annotation.dart';

enum FareOfferStatus {
  @JsonValue(0)
  rejected,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  waitingForResponse,
  @JsonValue(3)
  expired,
  @JsonValue(4)
  payed,
  @JsonValue(5)
  cancelled,
}

Map<FareOfferStatus, String> fareOfferStatusMap = {
  FareOfferStatus.rejected: "Odbijena",
  FareOfferStatus.accepted: "Prihvaćena",
  FareOfferStatus.cancelled: "Otkazana",
  FareOfferStatus.waitingForResponse: "Čeka na odgovor",
  FareOfferStatus.expired: "Istekla",
  FareOfferStatus.payed: "Plaćena",
};
