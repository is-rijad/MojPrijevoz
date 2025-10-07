import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:moj_prijevoz/common/env.dart';
import 'package:moj_prijevoz/common/user_exception.dart';
import 'package:moj_prijevoz/resources/requests/maps/maps_route_request.dart';
import 'package:moj_prijevoz/resources/responses/city/city_response.dart';
import 'package:moj_prijevoz/resources/responses/maps/maps_route_response.dart';

class MapProvider {
  final _dio = Dio();
  final _apiUrl = Environment.openRouteApiUrl;

  Future<MapsRouteResponse> getRoute(
    CityResponse cityFrom,
    CityResponse cityTo,
  ) async {
    try {
      final body = MapsRouteRequest(
        coordinates: [
          [cityFrom.long, cityFrom.lat],
          [cityTo.long, cityTo.lat],
        ],
        radiuses: [-1],
        units: "km",
      );
      final response = await _dio.post(
        "${_apiUrl}directions/driving-car",
        data: body.toJson(),
        options: _setRequestOptions(),
      );
      return MapsRouteResponse(
        routePoints: _decodePolyline(response.data["routes"][0]["geometry"]),
        distance: response.data["routes"][0]["summary"]["distance"],
        duration: response.data["routes"][0]["summary"]["duration"],
      );
    } on DioException catch (e) {
      throw UserException("Greška prilikom preuzimanja rute!");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final result = PolylinePoints.decodePolyline(encoded);

    return result
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  Options _setRequestOptions() {
    var options = Options(contentType: "application/json");
    var headersMap = <String, dynamic>{};
    try {
      headersMap.addEntries(
        <String, dynamic>{"Authorization": Environment.openRouteKey}.entries,
      );
    } on Exception {}

    options.headers = headersMap;
    return options;
  }
}
