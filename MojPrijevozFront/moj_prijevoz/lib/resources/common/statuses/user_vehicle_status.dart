import 'package:json_annotation/json_annotation.dart';

enum UserVehicleStatus {
  @JsonValue(0)
  deleted,
  @JsonValue(1)
  active,
  @JsonValue(2)
  waitingForChanges,
  @JsonValue(3)
  waitingForReview,
}

Map<UserVehicleStatus, String> userVehicleStatusMap = {
  UserVehicleStatus.deleted: "Obrisan",
  UserVehicleStatus.active: "Aktivan",
  UserVehicleStatus.waitingForChanges: "Čeka na izmjene (nije vidljiv)",
  UserVehicleStatus.waitingForReview: "Čeka na pregled (nije vidljiv)",
};
