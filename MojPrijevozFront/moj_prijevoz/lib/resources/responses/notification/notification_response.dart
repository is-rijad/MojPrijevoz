import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationResponse extends JsonResponse {
  @override
  final int id;
  final String message;
  final String type;
  final int? fareId;
  final int? side;
  final int? ratingId;
  bool isRead;
  final DateTime createdAt;

  NotificationResponse({
    required this.id,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.fareId,
    this.side,
    this.ratingId,
  });

  @override
  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseFromJson(json);
}
