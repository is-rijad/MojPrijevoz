import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/common/resources/search_objects/string_search_object.dart';

part 'administrator_search_object.g.dart';

@JsonSerializable()
class AdministratorSearchObject extends StringSearchObject {
  AdministratorSearchObject({
    super.contains,
    required super.page,
    required super.pageSize,
    super.orderBy,
    super.orderDirection,
  });

  factory AdministratorSearchObject.fromJson(Map<String, dynamic> json) =>
      _$AdministratorSearchObjectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdministratorSearchObjectToJson(this);
}
