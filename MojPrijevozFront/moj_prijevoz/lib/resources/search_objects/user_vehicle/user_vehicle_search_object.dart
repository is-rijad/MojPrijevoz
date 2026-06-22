import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/search_objects/base_search_object.dart';

part 'user_vehicle_search_object.g.dart';

@JsonSerializable()
class UserVehicleSearchObject extends BaseSearchObject {
  final int profileId;

  UserVehicleSearchObject({
    required this.profileId,
    required super.page,
    required super.pageSize,
  });
  @override
  Map<String, dynamic> toJson() => _$UserVehicleSearchObjectToJson(this);
  factory UserVehicleSearchObject.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleSearchObjectFromJson(json);
}
