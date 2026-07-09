// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/enums/statuses/user_vehicle_status.dart';

import 'package:moj_prijevoz_admin/utils/json_parser.dart';

part 'user_vehicle_update_request.g.dart';

@JsonSerializable()
class UserVehicleUpdateRequest extends JsonRequest {
  UserVehicleStatus? status;

  UserVehicleUpdateRequest({this.status});

  factory UserVehicleUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleUpdateRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserVehicleUpdateRequestToJson(this);
}
