import 'package:json_annotation/json_annotation.dart';
import 'package:moj_prijevoz/resources/common/enums/statuses/account_status.dart';
import 'package:moj_prijevoz/resources/common/user_for_circle_avatar_interface.dart';

import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'search_fare_response.g.dart';

@JsonSerializable()
class SearchFareResponse extends JsonResponse
    implements UserForCircleAvatarInterface {
  @override
  final int id;
  int profileId;
  @override
  String firstName;
  @override
  String lastName;
  @override
  String? picture;
  @override
  AccountStatus status;
  double averageReview;
  int numberOfReviews;
  List<UserVehicleResponse>? vehicles;

  SearchFareResponse({
    required this.id,
    required this.profileId,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.picture,
    required this.averageReview,
    required this.numberOfReviews,
    this.vehicles,
  });

  @override
  Map<String, dynamic> toJson() => _$SearchFareResponseToJson(this);

  factory SearchFareResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchFareResponseFromJson(json);
}
