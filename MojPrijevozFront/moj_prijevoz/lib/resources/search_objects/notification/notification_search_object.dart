import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/search_objects/base/base_search_object.dart';

part 'notification_search_object.g.dart';

@JsonSerializable()
class NotificationSearchObject extends BaseSearchObject {
  NotificationSearchObject({required super.page, required super.pageSize});

  @override
  Map<String, dynamic> toJson() => _$NotificationSearchObjectToJson(this);

  factory NotificationSearchObject.fromJson(Map<String, dynamic> json) =>
      _$NotificationSearchObjectFromJson(json);
}
