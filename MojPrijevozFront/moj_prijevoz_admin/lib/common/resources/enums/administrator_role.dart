import 'package:json_annotation/json_annotation.dart';

enum AdministartorRole {
  @JsonValue(0)
  moderator,
  @JsonValue(1)
  admin,
}

final Map<AdministartorRole, String> administratorRoleFieldMap = {
  AdministartorRole.moderator: "Moderator",
  AdministartorRole.admin: "Administrator",
};
