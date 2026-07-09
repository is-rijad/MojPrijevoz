import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz_admin/common/resources/enums/administrator_role.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'administrator_upsert_request.g.dart';

@JsonSerializable()
class AdministratorUpsertRequest extends JsonRequest {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  AccountStatus? status;
  AdministartorRole? role;
  bool? changePassword;

  AdministratorUpsertRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.username,
    this.status,
    this.role,
    this.changePassword,
  });

  factory AdministratorUpsertRequest.fromJson(Map<String, dynamic> json) =>
      _$AdministratorUpsertRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdministratorUpsertRequestToJson(this);
}
