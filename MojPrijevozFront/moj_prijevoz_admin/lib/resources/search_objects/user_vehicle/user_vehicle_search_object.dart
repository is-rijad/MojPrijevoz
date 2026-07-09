import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';

part 'user_vehicle_search_object.g.dart';

@JsonSerializable()
class UserVehicleSearchObject extends StringSearchObject {
  UserVehicleSearchObject({
    super.contains,
    required super.page,
    required super.pageSize,
    super.orderBy,
    super.orderDirection,
  });

  factory UserVehicleSearchObject.fromJson(Map<String, dynamic> json) =>
      _$UserVehicleSearchObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserVehicleSearchObjectToJson(this);
}
