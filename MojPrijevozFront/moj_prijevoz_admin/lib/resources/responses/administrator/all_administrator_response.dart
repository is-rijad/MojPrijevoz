// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz_admin/common/resources/enums/administrator_role.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'all_administrator_response.g.dart';

@JsonSerializable()
class AllAdministratorResponse extends JsonResponse {
  @override
  final int id;
  String firstName;
  String lastName;
  String email;
  String username;
  AccountStatus status;
  AdministartorRole role;

  AllAdministratorResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.status,
    required this.role,
  });

  factory AllAdministratorResponse.fromJson(Map<String, dynamic> json) =>
      _$AllAdministratorResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AllAdministratorResponseToJson(this);
}
