import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

part 'user_vehicle_search_object.g.dart';

@JsonSerializable()
class UserVehicleSearchObject extends BaseSearchObject {
  final int profileId;

  UserVehicleSearchObject({
    required this.profileId,
    super.page,
    super.pageSize,
  });
  @override
  Map<String, dynamic> toJson() => _$UserVehicleSearchObjectToJson(this);
  factory UserVehicleSearchObject.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleSearchObjectFromJson(json);
}
