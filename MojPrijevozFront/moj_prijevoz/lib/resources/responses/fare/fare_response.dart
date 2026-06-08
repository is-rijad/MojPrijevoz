// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

import 'package:moj_prijevoz/resources/common/enums/statuses/fare_status.dart';
import 'package:moj_prijevoz/resources/responses/fare_data/fare_data_response.dart';
import 'package:moj_prijevoz/resources/responses/fare_offer/fare_offer_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/utils/json_parser.dart';

part 'fare_response.g.dart';

@JsonSerializable()
class FareResponse extends JsonResponse {
  @override
  final int id;
  FareStatus status;
  final int driverId;
  final int passengerId;
  final int fareDataId;
  final int userVehicleId;
  final DateTime createdAt;
  final DateTime? fareStartAfter;
  final FareDataResponse? fareData;
  final UserProfileResponse? driver;
  final UserProfileResponse? passenger;
  final List<FareOfferResponse> fareOffers;
  final UserVehicleResponse? userVehicle;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isStartAvailable = false;
  FareOfferResponse? get lastFareOffer => fareOffers.last;
  FareResponse({
    required this.id,
    required this.status,
    required this.driverId,
    required this.passengerId,
    required this.fareDataId,
    required this.createdAt,
    required this.fareData,
    required this.driver,
    required this.passenger,
    required this.fareOffers,
    this.fareStartAfter,
    required this.userVehicleId,
    this.userVehicle,
  }) {
    isStartAvailable = false;
  }

  @override
  Map<String, dynamic> toJson() => _$FareResponseToJson(this);

  factory FareResponse.fromJson(Map<String, dynamic> json) =>
      _$FareResponseFromJson(json);
}
