import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';

part 'users_search_object.g.dart';

@JsonSerializable()
class UsersSearchObject extends StringSearchObject {
  UsersSearchObject({
    super.contains,
    required super.page,
    required super.pageSize,
    super.orderBy,
    super.orderDirection,
  });

  factory UsersSearchObject.fromJson(Map<String, dynamic> json) =>
      _$UsersSearchObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UsersSearchObjectToJson(this);
}
