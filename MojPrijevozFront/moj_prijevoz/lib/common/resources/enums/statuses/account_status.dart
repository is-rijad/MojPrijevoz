import 'package:json_annotation/json_annotation.dart';

enum AccountStatus {
  @JsonValue(0)
  banned,
  @JsonValue(1)
  active,
  @JsonValue(2)
  waitingForChanges,
  @JsonValue(3)
  waitingForReview,
}

Map<AccountStatus, String> accountStatusMap = {
  AccountStatus.banned: "Banovan",
  AccountStatus.active: "Aktivan",
  AccountStatus.waitingForChanges: "Čeka na izmjene",
  AccountStatus.waitingForReview: "Čeka na pregled",
};
