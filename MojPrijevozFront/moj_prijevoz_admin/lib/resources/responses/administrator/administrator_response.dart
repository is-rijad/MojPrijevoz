// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/administrator_role.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';

import 'package:moj_prijevoz_admin/resources/responses/administrator/all_administrator_response.dart';

part 'administrator_response.g.dart';

@JsonSerializable()
class AdministratorResponse extends AllAdministratorResponse {
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? changePassword;
  AdministratorResponse({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.role,
    required super.email,
    required super.username,
    required super.status,
    this.changePassword,
  });

  factory AdministratorResponse.fromJson(Map<String, dynamic> json) =>
      _$AdministratorResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdministratorResponseToJson(this);
}
