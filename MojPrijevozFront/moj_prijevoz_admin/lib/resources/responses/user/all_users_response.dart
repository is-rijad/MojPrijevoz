import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'all_users_response.g.dart';

@JsonSerializable()
class AllUsersResponse extends JsonResponse {
  @override
  final int id;
  String firstName;
  String lastName;
  final String email;
  final String username;
  AccountStatus status;
  final String phoneNumber;
  final DateTime registeredAt;

  AllUsersResponse({
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.email,
    required this.username,
    required this.status,
    required this.phoneNumber,
    required this.registeredAt,
  });

  factory AllUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$AllUsersResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AllUsersResponseToJson(this);
}
