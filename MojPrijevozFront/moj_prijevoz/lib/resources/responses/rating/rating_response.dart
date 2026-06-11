import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'rating_response.g.dart';

@JsonSerializable()
class RatingResponse extends JsonResponse {
  @override
  final int id;
  final int fareId;
  final String? comment;
  final int grade;
  final int fromId;
  final UserProfileResponse from;

  RatingResponse({
    required this.fareId,
    this.comment,
    required this.grade,
    required this.id,
    required this.fromId,
    required this.from,
  });

  @override
  Map<String, dynamic> toJson() => _$RatingResponseToJson(this);

  factory RatingResponse.fromJson(Map<String, dynamic> json) =>
      _$RatingResponseFromJson(json);
}
