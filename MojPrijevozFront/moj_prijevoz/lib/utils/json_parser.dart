import 'dart:developer';

import 'package:moj_prijevoz/resources/common/access_token_payload.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/drivers_discount/drivers_discount_response.dart';
import 'package:moj_prijevoz/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz/resources/responses/fare_data/fare_data_response.dart';
import 'package:moj_prijevoz/resources/responses/fare_offer/fare_offer_response.dart';
import 'package:moj_prijevoz/resources/responses/nominatim/nominatim_response.dart';
import 'package:moj_prijevoz/resources/responses/notification/notification_response.dart';
import 'package:moj_prijevoz/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz/resources/responses/search_fare/search_fare_driver_response.dart';
import 'package:moj_prijevoz/resources/responses/search_fare/search_fare_response.dart';
import 'package:moj_prijevoz/resources/responses/stop_points/stop_point_response.dart';
import 'package:moj_prijevoz/resources/responses/stripe/stripe_create_intent_response.dart';
import 'package:moj_prijevoz/resources/responses/user/access_token_response.dart';
import 'package:moj_prijevoz/resources/responses/user/request_reset_password_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_profile_response.dart';
import 'package:moj_prijevoz/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz/resources/responses/vehicle/vehicle_response.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

final Map<Type, _FromJson> _jsonFactories = {
  AccessTokenResponse: (json) => AccessTokenResponse.fromJson(json),
  CityResponse: (json) => CityResponse.fromJson(json),
  UserResponse: (json) => UserResponse.fromJson(json),
  AccessTokenPayload: (json) => AccessTokenPayload.fromJson(json),
  UserVehicleResponse: (json) => UserVehicleResponse.fromJson(json),
  VehicleResponse: (json) => VehicleResponse.fromJson(json),
  DriversDiscountResponse: (json) => DriversDiscountResponse.fromJson(json),
  NominatimResponse: (json) => NominatimResponse.fromJson(json),
  SearchFareResponse: (json) => SearchFareResponse.fromJson(json),
  SearchFareDriverResponse: (json) => SearchFareDriverResponse.fromJson(json),
  FareOfferResponse: (json) => FareOfferResponse.fromJson(json),
  FareResponse: (json) => FareResponse.fromJson(json),
  FareDataResponse: (json) => FareDataResponse.fromJson(json),
  StopPointResponse: (json) => StopPointResponse.fromJson(json),
  StripeCreateIntentResponse: (json) =>
      StripeCreateIntentResponse.fromJson(json),
  UserProfileResponse: (json) => UserProfileResponse.fromJson(json),
  RequestResetPasswordResponse: (json) =>
      RequestResetPasswordResponse.fromJson(json),
  RatingResponse: (json) => RatingResponse.fromJson(json),
  NotificationResponse: (json) => NotificationResponse.fromJson(json),
};

T parseJson<T>(Map<String, dynamic> json) {
  final fromJson = _jsonFactories[T];
  if (fromJson == null) throw Exception("No factory for type $T");
  log("PARSING TO JSON => $json");
  return fromJson(json) as T;
}

abstract class JsonParsable {
  Map<String, dynamic> toJson();
}

abstract class JsonRequest extends JsonParsable {}

abstract class JsonResponse extends JsonParsable {
  abstract final int id;
}
