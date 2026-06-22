import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/common/resources/profile_type.dart';
import 'package:moj_prijevoz/common/resources/search_objects/base_search_object.dart';

part 'fare_search_object.g.dart';

@JsonSerializable()
class FareSearchObject extends BaseSearchObject {
  ProfileType fareRole;
  int? fareId;
  FareSearchObject({
    required this.fareRole,
    required super.page,
    required super.pageSize,
    this.fareId,
  });

  @override
  Map<String, dynamic> toJson() => _$FareSearchObjectToJson(this);

  factory FareSearchObject.fromJson(Map<String, dynamic> json) =>
      _$FareSearchObjectFromJson(json);
}
