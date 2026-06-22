import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/search_objects/string_search_object.dart';

part 'vehicle_search_object.g.dart';

@JsonSerializable()
class VehicleSearchObject extends StringSearchObject {
  VehicleSearchObject({
    super.contains,
    required super.page,
    required super.pageSize,
  });

  @override
  Map<String, dynamic> toJson() => _$VehicleSearchObjectToJson(this);

  factory VehicleSearchObject.fromJson(Map<String, dynamic> json) =>
      _$VehicleSearchObjectFromJson(json);
}
