import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz_admin/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/all_ratings_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_profile/user_profile_response.dart';

part 'rating_response.g.dart';

@JsonSerializable()
class RatingResponse extends AllRatingsResponse {
  final String? comment;
  final int fareId;
  final FareResponse? fare;
  RatingResponse({
    this.comment,
    required this.fareId,
    this.fare,
    required super.id,
    required super.fromId,
    required super.toId,
    required super.grade,
    required super.isVisible,
    required super.createdAt,
    super.from,
    super.to,
  });

  factory RatingResponse.fromJson(Map<String, dynamic> json) =>
      _$RatingResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RatingResponseToJson(this);
}
