import 'package:json_annotation/json_annotation.dart';

enum FareOfferStatus {
  @JsonValue(0)
  rejected,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  waitingForResponse,
}

Map<FareOfferStatus, String> fareOfferStatusMap = {
  FareOfferStatus.rejected: "Odbijena",
  FareOfferStatus.accepted: "Prihvaćena",
  FareOfferStatus.waitingForResponse: "Čeka na odgovor",
};
