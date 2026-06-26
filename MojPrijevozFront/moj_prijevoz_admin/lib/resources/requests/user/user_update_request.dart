// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz_admin/common/resources/enums/statuses/account_status.dart';
import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'user_update_request.g.dart';

@JsonSerializable()
class UserUpdateRequest extends JsonRequest {
  AccountStatus? status;
  UserUpdateRequest({this.status});

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserUpdateRequestToJson(this);
}
