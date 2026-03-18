// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
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
  double averageReview;
  int numberOfReviews;
  List<UserVehicleResponse>? vehicles;

  SearchFareResponse({
    required this.id,
    required this.profileId,
    required this.firstName,
    required this.lastName,
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
