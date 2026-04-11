import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/profile_type.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

part 'fare_search_object.g.dart';

@JsonSerializable()
class FareSearchObject extends BaseSearchObject {
  ProfileType fareRole;
  FareSearchObject({
    required this.fareRole,
    required super.page,
    required super.pageSize,
  });

  @override
  Map<String, dynamic> toJson() => _$FareSearchObjectToJson(this);

  factory FareSearchObject.fromJson(Map<String, dynamic> json) =>
      _$FareSearchObjectFromJson(json);
}
