import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'users_response.g.dart';

@JsonSerializable()
class UsersResponse extends JsonResponse {
  @override
  final int id;
  String firstName;
  String lastName;
  final String email;
  final String username;
  AccountStatus status;
  final String phoneNumber;
  final DateTime registeredAt;

  UsersResponse({
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.email,
    required this.username,
    required this.status,
    required this.phoneNumber, required this.registeredAt,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) =>
      _$UsersResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UsersResponseToJson(this);
}
