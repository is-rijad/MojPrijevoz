import 'dart:developer';

import 'package:moj_prijevoz_admin/common/resources/access_token_payload.dart';
import 'package:moj_prijevoz_admin/common/resources/responses/user/access_token_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/administrator/administrator_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/administrator/all_administrator_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/all_cities_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/fare/fare_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/fare_data/fare_data_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/all_ratings_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/rating/rating_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/fares_this_month/fares_this_month_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/users_by_city/users_by_city_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/base_response_by_month/base_response_by_month.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/all_transactions_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/transaction/transaction_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/user_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user/all_users_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/all_user_vehicles_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/user_vehicle/user_vehicle_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/all_vehicles_response.dart';
import 'package:moj_prijevoz_admin/resources/responses/vehicle/vehicle_response.dart';

typedef _FromJson<T> = T Function(Map<String, dynamic> json);

final Map<Type, _FromJson> _jsonFactories = {
  AccessTokenResponse: (json) => AccessTokenResponse.fromJson(json),
  AccessTokenPayload: (json) => AccessTokenPayload.fromJson(json),
  UserResponse: (json) => UserResponse.fromJson(json),
  AllUsersResponse: (json) => AllUsersResponse.fromJson(json),
  AllVehiclesResponse: (json) => AllVehiclesResponse.fromJson(json),
  VehicleResponse: (json) => VehicleResponse.fromJson(json),
  AllUserVehiclesResponse: (json) => AllUserVehiclesResponse.fromJson(json),
  UserVehicleResponse: (json) => UserVehicleResponse.fromJson(json),
  AllCitiesResponse: (json) => AllCitiesResponse.fromJson(json),
  CityResponse: (json) => CityResponse.fromJson(json),
  FareResponse: (json) => FareResponse.fromJson(json),
  FareDataResponse: (json) => FareDataResponse.fromJson(json),
  AllRatingsResponse: (json) => AllRatingsResponse.fromJson(json),
  RatingResponse: (json) => RatingResponse.fromJson(json),
  AllAdministratorResponse: (json) => AllAdministratorResponse.fromJson(json),
  AdministratorResponse: (json) => AdministratorResponse.fromJson(json),
  AllTransactionsResponse: (json) => AllTransactionsResponse.fromJson(json),
  TransactionResponse: (json) => TransactionResponse.fromJson(json),
  UsersByCityResponse: (json) => UsersByCityResponse.fromJson(json),
  BaseResponseByMonth: (json) => BaseResponseByMonth.fromJson(json),
  FaresThisMonthResponse: (json) => FaresThisMonthResponse.fromJson(json),
};

final Map<Type, Map<String, String>> _fieldsMapFactories =
    <Type, Map<String, String>>{
      UserResponse: UserResponse.userFieldsMap,
      UserVehicleResponse: UserVehicleResponse.userVehicleFieldsMap,
    };

T parseJson<T>(Map<String, dynamic> json) {
  final fromJson = _jsonFactories[T];
  if (fromJson == null) throw Exception("No factory for type $T");
  log("PARSING TO JSON => $json");
  return fromJson(json) as T;
}

Map<String, String> fieldsMap<T>() {
  final fieldMap = _fieldsMapFactories[T];
  if (fieldMap == null) throw Exception("No fields map factory for type $T");
  return fieldMap;
}

abstract class JsonParsable {
  Map<String, dynamic> toJson();
}

abstract class JsonRequest extends JsonParsable {}

abstract class JsonResponse extends JsonParsable {
  abstract final int id;
}
